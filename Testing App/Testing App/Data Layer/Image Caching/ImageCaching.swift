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

actor ImageCaching {
    static let shared = ImageCaching()
    
    @MainActor private var imageRepository: ImageRepository?
    
    // L1 Cache: Memória RAM rápida
    private let memoryCache = NSCache<NSString, NSData>()
    
    // Deduplicação: Evita múltiplos downloads paralelos para a mesma URL
    private var activeTasks: [URL: Task<Data?, Never>] = [:]
    
    private init() {
        // Inicializa o cache com limite para não estourar a RAM
        memoryCache.countLimit = 100
        memoryCache.totalCostLimit = 1024 * 1024 * 100 // ~100 MB
        
        Task { @MainActor in
            do {
                self.imageRepository = try .init(stack: .init(modelTypes: [ImageModel.self], isMemoryOnly: false))
            } catch {
                print(error)
            }
        }
    }
    
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
    
    /// Método principal para buscar imagens usando 3 camadas (L1, L2, L3) e Deduplicação.
    public func getImage(url: URL?) async -> Data? {
        guard let url else { return nil }
        let cacheKey = url.absoluteString as NSString
        
        // 1. Checa L1 Cache (Memória RAM)
        if let cachedData = memoryCache.object(forKey: cacheKey) {
            return cachedData as Data
        }
        
        // 2. Previne downloads duplicados: junta-se a uma task em andamento se existir
        if let existingTask = activeTasks[url] {
            return await existingTask.value
        }
        
        // 3. Cria a nova tarefa de busca
        let task = Task<Data?, Never> {
            
            // L2 Cache (Disco / SwiftData)
            if let dbData = await self.fetchFromSwiftData(url: url) {
                self.memoryCache.setObject(dbData as NSData, forKey: cacheKey)
                return dbData
            }
            
            // L3 (Network) (downloadedData.count > 1000 garante que não é um objeto vazio)
            if let downloadedData = await self.fetchDataFromURL(url: url), downloadedData.count > 1000 {
                // Popula L1 e L2
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
