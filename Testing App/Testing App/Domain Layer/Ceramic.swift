import SwiftData
import Foundation

@Model
final class Ceramic: ProductDisplayable {
    var id: String
    var name: String
    var price: Decimal
    var salePrice: Decimal?
    var status: ProductStatus
    var imageURLs: [String]
    var productDescription: String
    var createdAt: Date

    var technique: String
    var glaze: String
    var artist: String

    var category: Category { .ceramic }

    init(
        id: String = UUID().uuidString,
        name: String,
        price: Decimal,
        salePrice: Decimal? = nil,
        status: ProductStatus = .none,
        imageURLs: [String] = [],
        productDescription: String = "",
        technique: String,
        glaze: String,
        artist: String,
        createdAt: Date = .now
    ) {
        self.id = id
        self.name = name
        self.price = price
        self.salePrice = salePrice
        self.status = status
        self.imageURLs = imageURLs
        self.productDescription = productDescription
        self.technique = technique
        self.glaze = glaze
        self.artist = artist
        self.createdAt = createdAt
    }

    func displayAttributes() -> [(label: String, value: String)] {
        [("Technique", technique), ("Glaze", glaze), ("Artist", artist)]
    }
}
