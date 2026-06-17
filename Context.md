# Context.md — How this project works

> The first thing an agent reads. Keep it current; stale context is worse than none.

## Stack
Swift · SwiftUI · **iOS 17.6+, iPhone only** (`TARGETED_DEVICE_FAMILY = 1`, no Catalyst) · SwiftData (persistence + image cache L2) · no third-party SPM packages. Image layer uses UIKit/AppKit (`#if canImport`). Xcode project: `Testing App/Testing App.xcodeproj`, scheme `Testing App`.

## Commands
Path and scheme both contain a space — quote them every time.
- Install: none — no external deps; open `Testing App/Testing App.xcodeproj` in Xcode.
- Run / dev: Xcode ⌘R, or `swift-dev`→ios-debugger-agent (XcodeBuildMCP).
- Test: `xcodebuild test -project "Testing App/Testing App.xcodeproj" -scheme "Testing App" -destination 'platform=iOS Simulator,name=iPhone 16'`
- Lint / format: none configured.
- Build: `xcodebuild build -project "Testing App/Testing App.xcodeproj" -scheme "Testing App" -destination 'generic/platform=iOS Simulator'`

## Architecture
MVVM (pre-ViewModel stage — add ViewModels as views grow). Entry point: `Testing App/Presentation Layer/Routing/Testing_AppApp.swift` (`@main`) → `ContentView`. Two layers: **Presentation Layer/** (SwiftUI routing, currently App + ContentView) and **Data Layer/** (generic SwiftData repository — `SwiftDataRepository` protocol, `PersistenceStack`, `Repository+CRUD`, `EntityCache`, `DataLayerError`). **Image Caching/** is an `actor ImageCaching` singleton: L1 `NSCache` (~100 MB) over L2 SwiftData-backed `ImageRepository` (`ImageModel`), with in-flight `Task` deduplication per URL.

## Conventions
- Layered folders: `Presentation Layer/` vs `Data Layer/`
- SwiftData access is `@MainActor`; the repository layer is `public`
- `///` doc comments on protocols and types
- Unit tests use **Swift Testing** (`@Test` / `#expect`); UI tests use XCTest — do not mix

## Gotchas
- **Stale headers**: several files carry `//  MixtapeApp` / `//  theordeal` file headers — ignore for provenance
- `PersistenceStack.container`/`context` are **Optional** and left `nil` on init failure (error is caught and dropped) — callers must handle `nil`
- `isMemoryOnly` flag exists on `PersistenceStack` — always use it in tests; never point tests at the on-disk store
- **Deployment target lives on the app target (17.6)** — `Testing AppTests`/`UITests` targets carry Xcode's default (26.x, universal); never read min OS or device family from test targets
