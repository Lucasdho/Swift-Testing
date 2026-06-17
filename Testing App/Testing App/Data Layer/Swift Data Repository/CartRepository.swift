import SwiftData
import Foundation

@MainActor
final class CartRepository: StoreRepository<CartItem> {

    func addOrIncrement(_ product: any ProductDisplayable) throws {
        let all = try fetchAll()
        // find existing item for this product (in-memory — cart is small)
        let existing = all.first { item in
            switch product {
            case let p as Painting:  return item.painting === p
            case let a as ArtPiece:  return item.artPiece === a
            case let g as Garment:   return item.garment === g
            default: return false
            }
        }
        if let existing {
            existing.quantity += 1
            try persistenceStack.context?.save()
        } else {
            let item: CartItem
            switch product {
            case let p as Painting:  item = CartItem(painting: p)
            case let a as ArtPiece:  item = CartItem(artPiece: a)
            case let g as Garment:   item = CartItem(garment: g)
            default: throw DataLayerError.invalidModelType
            }
            try add(item)
        }
    }

    func totalPrice() throws -> Decimal {
        try fetchAll().reduce(Decimal.zero) { sum, item in
            guard let product = item.product else { return sum }
            return sum + product.price * Decimal(item.quantity)
        }
    }

    func save() throws {
        try persistenceStack.context?.save()
    }
}
