import SwiftData

/// Repository for ``Cloth`` models; inherits all CRUD operations from ``StoreRepository``.
@MainActor
final class ClothRepository: StoreRepository<Cloth> {}
