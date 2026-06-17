import SwiftData
import Foundation

@Model
final class Jewelry: ProductDisplayable {
    var id: String
    var name: String
    var price: Decimal
    var imageURLs: [String]
    var productDescription: String
    var createdAt: Date

    var material: String
    var jewelryType: String
    var artist: String

    var category: Category { .jewelry }

    init(
        id: String = UUID().uuidString,
        name: String,
        price: Decimal,
        imageURLs: [String] = [],
        productDescription: String = "",
        material: String,
        jewelryType: String,
        artist: String,
        createdAt: Date = .now
    ) {
        self.id = id
        self.name = name
        self.price = price
        self.imageURLs = imageURLs
        self.productDescription = productDescription
        self.material = material
        self.jewelryType = jewelryType
        self.artist = artist
        self.createdAt = createdAt
    }

    func displayAttributes() -> [(label: String, value: String)] {
        [("Type", jewelryType), ("Material", material), ("Artist", artist)]
    }
}
