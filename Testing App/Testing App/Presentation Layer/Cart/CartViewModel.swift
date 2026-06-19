import SwiftData
import Foundation

/// Manages cart business logic for ``CartView``.
///
/// Receives a ``CartRepository`` injected by the DI layer —
/// never talks to ``DIContainer`` directly.
@Observable
@MainActor
final class CartViewModel {

    private let repository: CartRepository

    init(repository: CartRepository) {
        self.repository = repository
    }

    // MARK: - Quantity mutations

    func decrement(_ item: CartItem) {
        guard item.quantity > 1 else { return }
        item.quantity -= 1
        try? repository.save()
    }

    func increment(_ item: CartItem) {
        item.quantity += 1
        try? repository.save()
    }

    // MARK: - Deletion

    func delete(_ item: CartItem) {
        try? repository.delete(item)
    }

    func delete(at offsets: IndexSet, in items: [CartItem]) {
        for index in offsets {
            delete(items[index])
        }
    }

    // MARK: - Summary

    func totalPrice(for items: [CartItem]) -> Decimal {
        items.reduce(Decimal.zero) { sum, item in
            guard let product = item.product else { return sum }
            return sum + product.effectivePrice * Decimal(item.quantity)
        }
    }
}
