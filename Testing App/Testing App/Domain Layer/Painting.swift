import SwiftData
import Foundation

@Model
final class Painting: ProductDisplayable {
    var name: String
    var price: Decimal
    var imageURLs: [String]
    var productDescription: String
    var createdAt: Date

    var medium: String
    var dimensions: String
    var artist: String

    var category: Category { .painting }

    init(
        name: String,
        price: Decimal,
        imageURLs: [String] = [],
        productDescription: String = "",
        medium: String,
        dimensions: String,
        artist: String,
        createdAt: Date = .now
    ) {
        self.name = name
        self.price = price
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
