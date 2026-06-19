#if DEBUG
extension DIContainer {
    /// Shared in-memory `DIContainer` for SwiftUI Previews and unit tests.
    ///
    /// Pre-seeded with the full `SeedData` catalogue (all paintings, sculptures,
    /// ceramics, jewelry and clothing). Never touches disk.
    @MainActor
    static let preview: DIContainer = {
        do {
            let stack = try PersistenceStack(
                modelTypes: DIContainer.allModelTypes,
                isMemoryOnly: true
            )
            let di = try DIContainer(stack: stack)
            if let context = stack.context {
                SeedData.insert(into: context)
            }
            return di
        } catch {
            preconditionFailure("DIContainer.preview setup failed — \(error)")
        }
    }()
}
#endif
