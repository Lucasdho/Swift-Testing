import SwiftData
import Foundation

@Model
final class ArtPiece: ProductDisplayable {
    var name: String
    var price: Decimal
    var imageURLs: [String]
    var productDescription: String
    var createdAt: Date

    var artType: String
    var artist: String

    var category: Category { .art }

    init(
        name: String,
        price: Decimal,
        imageURLs: [String] = [],
        productDescription: String = "",
        artType: String,
        artist: String,
        createdAt: Date = .now
    ) {
        self.name = name
        self.price = price
        self.imageURLs = imageURLs
        self.productDescription = productDescription
        self.artType = artType
        self.artist = artist
        self.createdAt = createdAt
    }

    func displayAttributes() -> [(label: String, value: String)] {
        [("Type", artType), ("Artist", artist)]
    }
}
