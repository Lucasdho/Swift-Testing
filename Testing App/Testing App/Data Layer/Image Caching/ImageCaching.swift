//
//  ImageCaching.swift
//  theordeal
//
//  Created by Lucas Oliveira on 28/11/25.
//


import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// Shared image cache implementing a three-layer fetch strategy: L1 memory → L2 disk (SwiftData) → L3 network.
///
/// In-flight requests for the same URL are deduplicated via `activeTasks` so a URL is never
/// downloaded more than once concurrently. All public methods are safe to call from any context.
actor ImageCaching {
    static let shared = ImageCaching()

    @MainActor private var imageRepository: ImageRepository?

    // L1 cache: fast RAM-backed store
    private let memoryCache = NSCache<NSString, NSData>()

    // Deduplication: prevents parallel downloads for the same URL
    private var activeTasks: [URL: Task<Data?, Never>] = [:]

    private init() {
        // Cap memory usage to avoid RAM pressure
        memoryCache.countLimit = 100
        memoryCache.totalCostLimit = 1024 * 1024 * 100 // ~100 MB

        Task { @MainActor in
            do {
                self.imageRepository = try .init(stack: .init(modelTypes: [ImageModel.self], isMemoryOnly: false, storeName: "image-cache"))
            } catch {
                print(error)
            }
        }
    }

    /// Removes all cached images from both L1 (memory) and L2 (disk).
    public func removeAllImages() async {
        memoryCache.removeAllObjects()
        guard let repo = await self.imageRepository else { return }

        do {
            try await repo.deleteAll(ImageModel.self)
        } catch {
            print(DataLayerError.deleteFailed(error))
        }
    }

    private func fetchDataFromURL(url: URL) async -> Data? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            return nil
        }
    }

    @MainActor
    private func fetchFromSwiftData(url: URL) -> Data? {
        return self.imageRepository?.fetchImage(byID: url.absoluteString)?.imageData
    }

    @MainActor
    private func saveToSwiftData(url: URL, data: Data) {
        let newImage = ImageModel(id: url.absoluteString, imageData: data, uploadedAt: Date())
        do {
            try self.imageRepository?.add(newImage)
        } catch {
            print(DataLayerError.addFailed(error))
        }
    }

    /// Returns image data for `url` using the three-layer cache.
    ///
    /// Lookup order: L1 (NSCache) → L2 (SwiftData disk) → L3 (network download).
    /// A concurrent call for the same URL joins the existing in-flight task rather than starting a new download.
    public func getImage(url: URL?) async -> Data? {
        guard let url else { return nil }
        let cacheKey = url.absoluteString as NSString

        // L1: RAM cache
        if let cachedData = memoryCache.object(forKey: cacheKey) {
            return cachedData as Data
        }

        // Deduplication: join an existing download task if one is already in flight
        if let existingTask = activeTasks[url] {
            return await existingTask.value
        }

        let task = Task<Data?, Never> {

            // L2: disk cache (SwiftData)
            if let dbData = await self.fetchFromSwiftData(url: url) {
                self.memoryCache.setObject(dbData as NSData, forKey: cacheKey)
                return dbData
            }

            // L3: network — guard against empty/corrupt responses (< 1 KB)
            if let downloadedData = await self.fetchDataFromURL(url: url), downloadedData.count > 1000 {
                self.memoryCache.setObject(downloadedData as NSData, forKey: cacheKey)
                await self.saveToSwiftData(url: url, data: downloadedData)
                return downloadedData
            }

            return nil
        }

        activeTasks[url] = task
        let finalData = await task.value
        activeTasks[url] = nil

        return finalData
    }
}
