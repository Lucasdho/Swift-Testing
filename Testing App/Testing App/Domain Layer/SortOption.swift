import Foundation

enum SortOption: String, CaseIterable {
    case none            = "Default"
    case popularity      = "Popular"
    case recent          = "Recent"
    case priceAscending  = "Price ↑"
    case priceDescending = "Price ↓"

    var icon: String {
        switch self {
        case .none:            "arrow.up.arrow.down"
        case .popularity:      "flame"
        case .recent:          "clock"
        case .priceAscending:  "arrow.up.circle"
        case .priceDescending: "arrow.down.circle"
        }
    }
}
