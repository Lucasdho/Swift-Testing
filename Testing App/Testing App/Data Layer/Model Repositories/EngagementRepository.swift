import SwiftData
import Foundation

@MainActor
final class EngagementRepository {
    private let context: ModelContext

    init(stack: PersistenceStack) throws {
        guard let context = stack.context else {
            throw DataLayerError.addFailed(NSError(domain: "EngagementRepository", code: 0))
        }
        self.context = context
    }

    func recordView(productId: String) throws {
        let e = try findOrCreate(productId: productId)
        e.viewCount += 1
        try context.save()
    }

    func recordCartAdd(productId: String) throws {
        let e = try findOrCreate(productId: productId)
        e.cartAddCount += 1
        try context.save()
    }

    func fetchAll() throws -> [ProductEngagement] {
        try context.fetch(FetchDescriptor<ProductEngagement>())
    }

    private func findOrCreate(productId: String) throws -> ProductEngagement {
        let descriptor = FetchDescriptor<ProductEngagement>(
            predicate: #Predicate { $0.productId == productId }
        )
        if let existing = try context.fetch(descriptor).first {
            return existing
        }
        let engagement = ProductEngagement(productId: productId)
        context.insert(engagement)
        return engagement
    }
}
