import SwiftData

/// Repository for ``Painting`` models; inherits all CRUD operations from ``StoreRepository``.
@MainActor
final class PaintingRepository: StoreRepository<Painting> {}
