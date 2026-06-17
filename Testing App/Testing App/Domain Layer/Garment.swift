import SwiftData
import Foundation

@Model
final class Garment: ProductDisplayable {
    var name: String
    var price: Decimal
    var imageURLs: [String]
    var productDescription: String
    var createdAt: Date

    var clothingSize: String
    var condition: Condition
    var brand: String

    var category: Category { .clothing }

    init(
        name: String,
        price: Decimal,
        imageURLs: [String] = [],
        productDescription: String = "",
        clothingSize: String,
        condition: Condition,
        brand: String = "",
        createdAt: Date = .now
    ) {
        self.name = name
        self.price = price
        self.imageURLs = imageURLs
        self.productDescription = productDescription
        self.clothingSize = clothingSize
        self.condition = condition
        self.brand = brand
        self.createdAt = createdAt
    }

    func displayAttributes() -> [(label: String, value: String)] {
        var attrs: [(String, String)] = [
            ("Size", clothingSize),
            ("Condition", condition.rawValue.capitalized)
        ]
        if !brand.isEmpty { attrs.append(("Brand", brand)) }
        return attrs
    }
}
