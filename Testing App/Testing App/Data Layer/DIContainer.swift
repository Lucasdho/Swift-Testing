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
    let artPieces: ArtPieceRepository
    let garments: GarmentRepository

    /// True when the store was corrupted and destroyed on this launch — use to re-trigger seeding.
    let resetOccurred: Bool

    /// The single ModelContainer to pass to .modelContainer() — keeps @Query in sync with repos.
    var modelContainer: ModelContainer? { stack.container }

    // All model types registered in one place; must match what PersistenceStack receives.
    static let allModelTypes: [any PersistentModel.Type] = [
        Painting.self, ArtPiece.self, Garment.self, CartItem.self, ImageModel.self
    ]

    init() {
        var didReset = false
        let s: PersistenceStack
        do {
            s = try PersistenceStack(modelTypes: DIContainer.allModelTypes, isMemoryOnly: false)
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
        artPieces = try! ArtPieceRepository(stack: s)
        garments = try! GarmentRepository(stack: s)
        resetOccurred = didReset
    }

    private static func deleteStoreFiles() {
        guard let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else { return }
        for name in ["default.store", "default.store-wal", "default.store-shm"] {
            try? FileManager.default.removeItem(at: base.appendingPathComponent(name))
        }
    }
}
