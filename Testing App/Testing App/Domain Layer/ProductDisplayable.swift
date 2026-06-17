import Foundation

enum Category: String, CaseIterable, Codable {
    case painting
    case sculpture
    case ceramic
    case jewelry
    case clothing

    var categoryDisplayName: String {
        switch self {
        case .painting:  "Paintings"
        case .sculpture: "Sculptures"
        case .ceramic:   "Ceramics"
        case .jewelry:   "Jewelry"
        case .clothing:  "Clothes"
        }
    }
}

enum Condition: String, CaseIterable, Codable {
    case new
    case good
    case fair
}

// AnyObject required — SwiftData @Model types are classes.
// Identifiable is NOT listed here — @Model provides it non-isolated via PersistentModel.
// Adding Identifiable here creates a main-actor-isolated duplicate that breaks PersistentModel.
// Each model's `var id: String` satisfies PersistentModel's Identifiable requirement directly.
protocol ProductDisplayable: AnyObject {
    var id: String { get set }
    var name: String { get set }
    var price: Decimal { get set }
    var imageURLs: [String] { get set }
    var productDescription: String { get set }
    var category: Category { get }
    var createdAt: Date { get set }
    func displayAttributes() -> [(label: String, value: String)]
}

extension ProductDisplayable {
    var categoryDisplayName: String { category.categoryDisplayName }
}
