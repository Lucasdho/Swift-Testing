import SwiftData
import Foundation

@Model
final class Painting: ProductDisplayable {
    var id: String
    var name: String
    var price: Decimal
    var salePrice: Decimal?
    var status: ProductStatus
    var imageURLs: [String]
    var productDescription: String
    var createdAt: Date

    var medium: String
    var dimensions: String
    var artist: String

    var category: Category { .painting }

    init(
        id: String = UUID().uuidString,
        name: String,
        price: Decimal,
        salePrice: Decimal? = nil,
        status: ProductStatus = .none,
        imageURLs: [String] = [],
        productDescription: String = "",
        medium: String,
        dimensions: String,
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
        self.medium = medium
        self.dimensions = dimensions
        self.artist = artist
        self.createdAt = createdAt
    }

    func displayAttributes() -> [(label: String, value: String)] {
        [("Medium", medium), ("Dimensions", dimensions), ("Artist", artist)]
    }
}
