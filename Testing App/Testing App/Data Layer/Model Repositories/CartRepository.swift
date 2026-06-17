import SwiftData
import Foundation

@MainActor
final class CartRepository: StoreRepository<CartItem> {

    func addOrIncrement(_ product: any ProductDisplayable) throws {
        let all = try fetchAll()
        // ponytail: in-memory scan — cart is small
        let existing = all.first { item in
            switch product {
            case let p as Painting:   return item.painting === p
            case let s as Sculpture:  return item.sculpture === s
            case let c as Ceramic:    return item.ceramic === c
            case let j as Jewelry:    return item.jewelry === j
            case let cl as Cloth:     return item.cloth === cl
            default: return false
            }
        }
        if let existing {
            existing.quantity += 1
            try persistenceStack.context?.save()
        } else {
            let item: CartItem
            switch product {
            case let p as Painting:   item = CartItem(painting: p)
            case let s as Sculpture:  item = CartItem(sculpture: s)
            case let c as Ceramic:    item = CartItem(ceramic: c)
            case let j as Jewelry:    item = CartItem(jewelry: j)
            case let cl as Cloth:     item = CartItem(cloth: cl)
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
