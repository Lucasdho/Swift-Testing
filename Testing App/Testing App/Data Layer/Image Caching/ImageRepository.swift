//
//  ImageRepository.swift
//  theordeal
//
//  Created by Lucas Oliveira on 03/12/25.
//

import Foundation
import SwiftData

/// SwiftData-backed repository for ``ImageModel``, used as the L2 disk cache by ``ImageCaching``.
@MainActor
final class ImageRepository: StoreRepository<ImageModel> {

    /// Fetches the cached image whose `id` matches the given URL string, or `nil` if not found.
    func fetchImage(byID id: String) -> ImageModel? {
        guard let context = persistenceStack.context else { return nil }

        // Matches the model's `id` property against the given string.
        let predicate = #Predicate<ImageModel> { model in
            model.id == id
        }

        let descriptor = FetchDescriptor<ImageModel>(predicate: predicate)

        do {
            let results = try context.fetch(descriptor)
            return results.first
        } catch {
            print("[ImageRepository] fetchImage(byID: \(id)) failed: \(error)")
            return nil
        }
    }

    /// Persists `image` to the SwiftData store.
    func saveImage(_ image: ImageModel) throws {
        try self.add(image)
    }
}
