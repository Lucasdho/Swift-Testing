import SwiftUI

// MARK: - SearchService

@Observable
final class SearchService {
    var searchText = ""
    var isPresented = false
    private(set) var recentSearches: [String]

    private let storageKey = "recentSearches"

    init() {
        recentSearches = UserDefaults.standard.stringArray(forKey: storageKey) ?? []
    }

    func save(_ query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        recentSearches.removeAll { $0 == trimmed }
        recentSearches.insert(trimmed, at: 0)
        recentSearches = Array(recentSearches.prefix(10))
        UserDefaults.standard.set(recentSearches, forKey: storageKey)
    }

    func clearRecent() {
        recentSearches = []
        UserDefaults.standard.removeObject(forKey: storageKey)
    }

    /// Two-stage match: fast exact substring, then word-level Levenshtein for typos.
    func matches(_ query: String, in corpus: String) -> Bool {
        let q = query.lowercased()
        let c = corpus.lowercased()
        if c.contains(q) { return true }
        let qWords = q.split(separator: " ").map(String.init)
        let cWords = c.split(separator: " ").map(String.init)
        return qWords.allSatisfy { qw in
            let threshold = qw.count >= 6 ? 2 : qw.count >= 3 ? 1 : 0
            return cWords.contains { editDistance(qw, $0) <= threshold }
        }
    }

    private func editDistance(_ a: String, _ b: String) -> Int {
        let a = Array(a), b = Array(b)
        guard !a.isEmpty else { return b.count }
        guard !b.isEmpty else { return a.count }
        var dp = Array(0...b.count)
        for i in 1...a.count {
            var prev = dp[0]
            dp[0] = i
            for j in 1...b.count {
                let temp = dp[j]
                dp[j] = a[i - 1] == b[j - 1] ? prev : 1 + min(prev, dp[j], dp[j - 1])
                prev = temp
            }
        }
        return dp[b.count]
    }
}

// MARK: - ViewModifier

private struct ProductSearchModifier: ViewModifier {
    @Bindable var service: SearchService

    func body(content: Content) -> some View {
        content
            .searchable(
                text: $service.searchText,
                isPresented: $service.isPresented,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Search products"
            )
            .searchSuggestions {
                if service.searchText.isEmpty {
                    ForEach(service.recentSearches, id: \.self) { term in
                        Label(term, systemImage: "clock")
                            .searchCompletion(term)
                    }
                    if !service.recentSearches.isEmpty {
                        Button(role: .destructive) {
                            service.clearRecent()
                        } label: {
                            Label("Clear Recent Searches", systemImage: "trash")
                        }
                    }
                }
            }
            .onSubmit(of: .search) {
                service.save(service.searchText)
            }
    }
}
