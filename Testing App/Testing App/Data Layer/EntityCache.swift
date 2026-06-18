import Foundation

/// Thread-safe in-memory cache with a 10-minute TTL, implemented as an actor for safe concurrent access.
actor EntityCache<T: Sendable> {
    private struct CacheEntry {
        let value: T
        let timestamp: Date
    }

    private var storage: [String: CacheEntry] = [:]
    private let expirationInterval: TimeInterval = 600 // 10 minutes

    /// Returns the cached value for `id`, or `nil` if absent or expired.
    func get(_ id: String) -> T? {
        guard let entry = storage[id] else {
            print("❌ [EntityCache<\(String(describing: T.self))>] MISS for id: \(id)")
            return nil
        }

        let elapsed = Date().timeIntervalSince(entry.timestamp)
        if elapsed > expirationInterval {
            storage.removeValue(forKey: id)
            print("⏰ [EntityCache<\(String(describing: T.self))>] EXPIRED for id: \(id)")
            return nil
        }

        print("✅ [EntityCache<\(String(describing: T.self))>] HIT for id: \(id)")
        return entry.value
    }

    /// Stores `value` under `id`, resetting its TTL.
    func set(_ value: T, for id: String) {
        print("💾 [EntityCache<\(String(describing: T.self))>] SET for id: \(id) (TTL: 10m)")
        storage[id] = CacheEntry(value: value, timestamp: Date())
    }

    /// Removes the cached entry for `id`.
    func remove(_ id: String) {
        print("🗑️ [EntityCache<\(String(describing: T.self))>] REMOVE for id: \(id)")
        storage.removeValue(forKey: id)
    }

    /// Clears all entries from the cache.
    func clear() {
        print("🧹 [EntityCache<\(String(describing: T.self))>] CLEARED")
        storage.removeAll()
    }
}
