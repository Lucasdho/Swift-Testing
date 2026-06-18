import SwiftData
import Foundation

@Model
final class Sculpture: ProductDisplayable {
    var id: String
    var name: String
    var price: Decimal
    var salePrice: Decimal?
    var status: ProductStatus
    var imageURLs: [String]
    var imageAspectRatio: Double?
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
        salePrice: Decimal? = nil,
        status: ProductStatus = .none,
        imageURLs: [String] = [],
        imageAspectRatio: Double? = nil,
        productDescription: String = "",
        material: String,
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
        self.imageAspectRatio = imageAspectRatio
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
