import SwiftData
import Foundation

@Model
final class Sculpture: ProductDisplayable {
    var id: String
    var name: String
    var price: Decimal
    var imageURLs: [String]
    var productDescription: String
    var createdAt: Date

    var material: String
    var dimensions: String
    var artist: String

    var category: Category { .sculpture }

    init(
        id: String = UUID().uuidString,
        name: String,
        price: Decimal,
        imageURLs: [String] = [],
        productDescription: String = "",
        material: String,
        dimensions: String,
        artist: String,
        createdAt: Date = .now
    ) {
        self.id = id
        self.name = name
        self.price = price
        self.imageURLs = imageURLs
        self.productDescription = productDescription
        self.material = material
        self.dimensions = dimensions
        self.artist = artist
        self.createdAt = createdAt
    }

    func displayAttributes() -> [(label: String, value: String)] {
        [("Material", material), ("Dimensions", dimensions), ("Artist", artist)]
    }
}
