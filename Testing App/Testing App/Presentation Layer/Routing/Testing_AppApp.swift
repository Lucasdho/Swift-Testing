import SwiftUI
import SwiftData

@main
@MainActor
struct Testing_AppApp: App {
    @State private var di = DIContainer()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(di.modelContainer!)
                .environment(di)
                .onAppear {
                    guard let context = di.stack.context else { return }
                    // Seed only when the store is truly empty — handles fresh install and store recovery.
                    let count = (try? context.fetchCount(FetchDescriptor<Painting>())) ?? 0
                    if count == 0 { SeedData.insert(into: context) }
                }
        }
    }
}
