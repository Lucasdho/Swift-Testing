import SwiftData
import Foundation

@Model
final class ProductEngagement {
    var productId: String
    var viewCount: Int
    var cartAddCount: Int

    // ponytail: mirrors backend aggregate — computed from stored counters, not persisted
    var popularityScore: Int { viewCount + cartAddCount }

    init(productId: String) {
        self.productId = productId
        self.viewCount = 0
        self.cartAddCount = 0
    }
}
