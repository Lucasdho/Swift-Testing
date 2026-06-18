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
    let engagement: EngagementRepository

    /// True when the store was corrupted and destroyed on this launch — use to re-trigger seeding.
    let resetOccurred: Bool

    /// The single ModelContainer to pass to .modelContainer() — keeps @Query in sync with repos.
    var modelContainer: ModelContainer? { stack.container }

    // All model types registered in one place; must match what PersistenceStack receives.
    static let allModelTypes: [any PersistentModel.Type] = [
        Painting.self, Sculpture.self, Ceramic.self, Jewelry.self, Cloth.self,
        CartItem.self,
        ProductEngagement.self
    ]

    init() {
        // ponytail: schema version guard — bump this string whenever @Model types change.
        // Deletes the store BEFORE SwiftData opens it, avoiding fatal nil-cast crashes that
        // try? cannot catch. Replace with VersionedSchema migration plan if data preservation matters.
        let schemaVersion = "v2"
        var didReset = UserDefaults.standard.string(forKey: "sd.schemaVersion") != schemaVersion
        if didReset {
            DIContainer.deleteStoreFiles()
            UserDefaults.standard.set(schemaVersion, forKey: "sd.schemaVersion")
        }

        let s: PersistenceStack
        do {
            s = try PersistenceStack(modelTypes: DIContainer.allModelTypes, isMemoryOnly: false)
        } catch {
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
        engagement = try! EngagementRepository(stack: s)
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
