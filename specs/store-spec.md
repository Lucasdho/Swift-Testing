# Swift Testing — Store App
**Working spec · v1.0 · project annex**

This document captures the architectural and product decisions for the store app living inside the Swift Testing repository. It complements `Context.md` (stack, commands, conventions) and `AGENTS.md` (skill gates). Everything here is settled unless marked *open*.

---

## 1. Purpose

The store is a **feature vehicle** — realistic enough to stress the existing architecture (SwiftData, `ImageCaching`, MVVM, `NavigationStack`) without being a shipping product. It is not a commerce backend; there is no payment, auth, or order fulfillment. Its value is the architectural surface it exposes.

**Products sold:** paintings, ceramics, other art forms, used clothes — three natural categories with different attribute shapes, which is what makes the data model interesting.

---

## 2. Screens

| Screen | Entry point | Notes |
|---|---|---|
| Catalog | App root | 2-column grid, category chip filter |
| Product Detail | Tap any product in grid | Pushed via `NavigationStack` |
| Cart | Toolbar cart icon | Presented as `.sheet` |

**Declined:** order history (implies auth, out of scope for v1); per-category tabs (redundant with chip filter, conflicts with navigation decision §4).

---

## 3. Product Data Model

### Base class

```swift
@Model
class Product {
    var name: String
    var price: Decimal
    var productDescription: String
    var imageURLs: [String]
    var category: Category        // enum — drives chip filter and routing
    var createdAt: Date

    func displayAttributes() -> [(label: String, value: String)] { [] }
}

enum Category: String, CaseIterable, Codable {
    case painting
    case art
    case clothing
}
```

### Subclasses

```swift
@Model final class Painting: Product {
    var medium: String            // "Acrylic", "Watercolor", "Ceramic"
    var dimensions: String
    var artist: String
    override func displayAttributes() -> [(label: String, value: String)] { ... }
}

@Model final class ArtPiece: Product {
    var artType: String           // "Sculpture", "Print", "Mixed media"
    var artist: String
    override func displayAttributes() -> [(label: String, value: String)] { ... }
}

@Model final class Garment: Product {
    var clothingSize: String
    var condition: Condition      // enum: new / good / fair
    var brand: String?
    override func displayAttributes() -> [(label: String, value: String)] { ... }
}

enum Condition: String, CaseIterable, Codable {
    case new, good, fair
}
```

**Why subclasses over a flat model:** the three product types have genuinely different flat fields that benefit from compiler enforcement and polymorphic `displayAttributes()` override. A single model with nullable fields was declined because it trades type safety for false simplicity.

**Why subclasses over a dict/JSON attributes field:** strong typing on fields like `Condition` is the point of the exercise; a `[String: String]` bag loses that.

**[TECHNICAL RISK — verify before implementing] SwiftData class inheritance:** fetching `Product` by base type may not return subclass instances on all iOS 17.x targets. Fetch descriptors for each subclass type must be tested explicitly. See `AGENTS.md` → `swiftdata-pro` gate.

---

## 4. Navigation

```
ContentView
└── NavigationStack
    ├── CatalogView (root)          ← LazyVGrid + category chips
    │   └── ProductDetailView       ← pushed on tap
    └── CartView                    ← .sheet from toolbar icon
```

**Why sheet for cart:** exercises `@Environment` / observable state flowing into a modal context — a real architectural test. Cart-as-tab was declined (adds a layer that implies more content than we're building).

---

## 5. Cart

**Persistence:** SwiftData `CartItem` — cart survives app relaunches.

```swift
@Model final class CartItem {
    var product: Product          // relationship to base type
    var quantity: Int
    var addedAt: Date
}
```

**In-memory `@Observable` cart was declined** in favour of SwiftData because this repo exists to exercise persistence patterns. The added complexity is the point.

**[TECHNICAL RISK — specify before implementing] `CartItem → Product` relationship:** `product` references the base `Product` type while actual instances are subclasses. Correct fetch and relationship resolution across SwiftData inheritance must be verified with `swiftdata-pro` before writing this model. This is the highest-risk seam in the data layer.

---

## 6. Catalog View

- **Layout:** `LazyVGrid`, 2 columns, `adaptive` sizing.
- **Filter:** horizontal `ScrollView` of chip buttons — `All`, `Paintings & Ceramics`, `Art`, `Clothes`. Selection drives a `@Query` predicate on `Product.category`.
- **Why predicate-based `@Query` over in-memory filter:** exercises SwiftData fetch predicates directly; avoids loading all products then filtering in memory.

---

## 7. Images

- **Field:** `imageURLs: [String]` on `Product` base class.
- **Display layer:** existing `actor ImageCaching` (L1 `NSCache` + L2 SwiftData `ImageModel`). No new image infrastructure.
- **Seed data:** URL-based strings; real or placeholder URLs acceptable for a testbed.
- **Storing image `Data` in `Product` was declined** — bloats the store and defeats the existing cache layer.

---

## 8. Deliberate exclusions

| Excluded | Reason | If needed later |
|---|---|---|
| Auth / user accounts | Implies backend; out of scope for a testbed | Add as a separate phase |
| Checkout / payment | Same | Add as a separate phase |
| Order history | Requires auth to own the history | Phase 2 |
| Search | Nice-to-have; category filter covers discovery for now | Add `#Predicate` on name/description |
| Reviews / ratings | Product complexity with no architectural payoff | Skip |

---

## 9. Open / next

- **[OPEN] Seed data strategy:** how many products, who creates them, what image URLs to use. Decide before first build.
- **[OPEN] `displayAttributes()` exact fields per subclass:** which label/value pairs each subclass returns. Decide at implementation time.
- **[TECHNICAL RISK] SwiftData inheritance fetch** (§3, §5): must be validated with `swiftdata-pro` before any `@Query` or relationship code is written.
- **Next session:** implement the data layer — `Product` hierarchy + `CartItem` + `PersistenceStack` registration + seed data.
