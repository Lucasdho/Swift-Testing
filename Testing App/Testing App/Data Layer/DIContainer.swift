import SwiftData
import Foundation

/// Single source of truth for the SwiftData stack and all repositories.
/// Owns the one ModelContainer; every repository is built from this same stack.
/// No other code should construct a PersistenceStack or ModelContainer.
@Observable
@MainActor
final class DIContainer {

    let stack: PersistenceStack

    // Repositories — all share the same stack, so they share the same ModelContext
    let cart: CartRepository
    let paintings: PaintingRepository
    let sculptures: SculptureRepository
    let ceramics: CeramicRepository
    let jewelry: JewelryRepository
    let cloths: ClothRepository

    /// True when the store was corrupted and destroyed on this launch — use to re-trigger seeding.
    let resetOccurred: Bool

    /// The single ModelContainer to pass to .modelContainer() — keeps @Query in sync with repos.
    var modelContainer: ModelContainer? { stack.container }

    // All model types registered in one place; must match what PersistenceStack receives.
    static let allModelTypes: [any PersistentModel.Type] = [
        Painting.self, Sculpture.self, Ceramic.self, Jewelry.self, Cloth.self, CartItem.self
    ]

    init() {
        var didReset = false
        let s: PersistenceStack
        do {
            let candidate = try PersistenceStack(modelTypes: DIContainer.allModelTypes, isMemoryOnly: false)
            // ponytail: probe fetch — ModelContainer.init can succeed even when the store has stale
            // persistent history that makes all queries fail. Catch it here so the reset path fires.
            guard let ctx = candidate.context,
                  (try? ctx.fetchCount(FetchDescriptor<Painting>())) != nil else {
                throw DataLayerError.addFailed(NSError(domain: "PersistenceStack", code: 1))
            }
            s = candidate
        } catch {
            // ponytail: destructive reset — corrupted store from partial-schema open (dev iteration only);
            // if data preservation is needed later, replace with a migration plan instead.
            DIContainer.deleteStoreFiles()
            s = try! PersistenceStack(modelTypes: DIContainer.allModelTypes, isMemoryOnly: false)
            didReset = true
        }
        stack = s
        cart = try! CartRepository(stack: s)
        paintings = try! PaintingRepository(stack: s)
        sculptures = try! SculptureRepository(stack: s)
        ceramics = try! CeramicRepository(stack: s)
        jewelry = try! JewelryRepository(stack: s)
        cloths = try! ClothRepository(stack: s)
        resetOccurred = didReset
    }

    private static func deleteStoreFiles() {
        guard let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first,
              let items = try? FileManager.default.contentsOfDirectory(at: base, includingPropertiesForKeys: nil)
        else { return }
        for item in items where item.lastPathComponent.hasPrefix("default.store") || item.lastPathComponent.hasPrefix(".default.store") {
            try? FileManager.default.removeItem(at: item)
        }
    }
}
