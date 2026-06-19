import SwiftData
import Foundation

/// A single line item in the shopping cart, linking a quantity to one ``ProductDisplayable``.
///
/// Each product type is stored as a separate optional relationship because SwiftData
/// cannot store protocol-typed (`any ProductDisplayable`) relationships. Exactly one
/// of the five optionals is non-nil per instance; `product` exposes whichever is set.
@Model
final class CartItem {
    var id: String
    // ponytail: five optionals instead of a protocol-typed relationship — SwiftData can't store existentials
    @Relationship(deleteRule: .nullify) var painting: Painting?
    @Relationship(deleteRule: .nullify) var sculpture: Sculpture?
    @Relationship(deleteRule: .nullify) var ceramic: Ceramic?
    @Relationship(deleteRule: .nullify) var jewelry: Jewelry?
    @Relationship(deleteRule: .nullify) var cloth: Cloth?
    var quantity: Int
    var addedAt: Date

    var product: (any ProductDisplayable)! { painting ?? sculpture ?? ceramic ?? jewelry ?? cloth }

    init(painting: Painting, quantity: Int = 1) {
        self.id = UUID().uuidString; self.painting = painting; self.quantity = quantity; self.addedAt = .now
    }
    init(sculpture: Sculpture, quantity: Int = 1) {
        self.id = UUID().uuidString; self.sculpture = sculpture; self.quantity = quantity; self.addedAt = .now
    }
    init(ceramic: Ceramic, quantity: Int = 1) {
        self.id = UUID().uuidString; self.ceramic = ceramic; self.quantity = quantity; self.addedAt = .now
    }
    init(jewelry: Jewelry, quantity: Int = 1) {
        self.id = UUID().uuidString; self.jewelry = jewelry; self.quantity = quantity; self.addedAt = .now
    }
    init(cloth: Cloth, quantity: Int = 1) {
        self.id = UUID().uuidString; self.cloth = cloth; self.quantity = quantity; self.addedAt = .now
    }
}
