import SwiftData
import Foundation

@Model
final class CartItem {
    // ponytail: three optionals instead of a protocol-typed relationship — SwiftData can't store existentials
    @Relationship(deleteRule: .nullify) var painting: Painting?
    @Relationship(deleteRule: .nullify) var artPiece: ArtPiece?
    @Relationship(deleteRule: .nullify) var garment: Garment?
    var quantity: Int
    var addedAt: Date

    var product: (any ProductDisplayable)? { painting ?? artPiece ?? garment }

    init(painting: Painting, quantity: Int = 1) {
        self.painting = painting
        self.quantity = quantity
        self.addedAt = .now
    }

    init(artPiece: ArtPiece, quantity: Int = 1) {
        self.artPiece = artPiece
        self.quantity = quantity
        self.addedAt = .now
    }

    init(garment: Garment, quantity: Int = 1) {
        self.garment = garment
        self.quantity = quantity
        self.addedAt = .now
    }
}
