import SwiftData
import Foundation

@Model
final class Jewelry: ProductDisplayable {
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
    var jewelryType: String
    var artist: String

    var category: Category { .jewelry }

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
        jewelryType: String,
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
        self.jewelryType = jewelryType
        self.artist = artist
        self.createdAt = createdAt
    }

    func displayAttributes() -> [(label: String, value: String)] {
        [("Type", jewelryType), ("Material", material), ("Artist", artist)]
    }
}
