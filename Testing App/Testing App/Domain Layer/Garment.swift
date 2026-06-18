import SwiftData
import Foundation

@Model
final class Cloth: ProductDisplayable {
    var id: String
    var name: String
    var price: Decimal
    var salePrice: Decimal?
    var status: ProductStatus
    var imageURLs: [String]
    var imageAspectRatio: Double?
    var productDescription: String
    var createdAt: Date

    var clothingSize: String
    var condition: Condition
    var brand: String

    var category: Category { .clothing }

    init(
        id: String = UUID().uuidString,
        name: String,
        price: Decimal,
        salePrice: Decimal? = nil,
        status: ProductStatus = .none,
        imageURLs: [String] = [],
        imageAspectRatio: Double? = nil,
        productDescription: String = "",
        clothingSize: String,
        condition: Condition,
        brand: String = "",
        createdAt: Date = .now
    ) {
        self.id = id
        self.name = name
        self.price = price
        self.salePrice = salePrice
        self.status = status
        self.imageURLs = imageURLs
        self.imageAspectRatio = imageAspectRatio
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
