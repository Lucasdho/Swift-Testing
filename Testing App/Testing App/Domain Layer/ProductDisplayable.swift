import Foundation

enum Category: String, CaseIterable, Codable {
    case painting
    case art
    case clothing

    var categoryDisplayName: String {
        switch self {
        case .painting: "Paintings & Ceramics"
        case .art: "Art"
        case .clothing: "Clothes"
        }
    }
}

enum Condition: String, CaseIterable, Codable {
    case new
    case good
    case fair
}

// AnyObject required — SwiftData @Model types are classes
protocol ProductDisplayable: AnyObject {
    var name: String { get set }
    var price: Decimal { get set }
    var imageURLs: [String] { get set }
    var productDescription: String { get set }
    var category: Category { get }
    var createdAt: Date { get set }
    func displayAttributes() -> [(label: String, value: String)]
}

extension ProductDisplayable {
    /// Stable identity for ForEach — safe because all conformers are reference types (@Model classes)
    var objectID: ObjectIdentifier { ObjectIdentifier(self) }

    var categoryDisplayName: String {
        switch category {
        case .painting: "Paintings & Ceramics"
        case .art: "Art"
        case .clothing: "Clothes"
        }
    }
}
