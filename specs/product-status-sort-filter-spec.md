# Swift Testing — Product Status, Sort & Filter
**Working spec · v1.0 · project annex**

Extends the store spec (`specs/store-spec.md`) with product status badges (new / on sale), sale pricing, engagement-driven popularity tracking, and a sort/filter UI. Everything here is settled unless marked *open*.

---

## 1. Purpose

Add merchant-facing state to products (new, on sale, default) and buyer-facing discovery controls (sort by popularity/recency/price, filter by status). Mimics production backend patterns: product models stay clean, engagement is tracked in a separate analytics model.

---

## 2. ProductStatus

### Enum

```swift
enum ProductStatus: String, CaseIterable, Codable {
    case none     // default — no badge
    case new      // recently added — "New" badge
    case onSale   // discounted — "Sale" badge
}
```

### Protocol additions (ProductDisplayable)

```swift
var status: ProductStatus { get set }    // default: .none
var salePrice: Decimal? { get set }      // nil unless status == .onSale
```

### Computed helpers (extension)

```swift
var effectivePrice: Decimal { salePrice ?? price }
var isOnSale: Bool { status == .onSale && salePrice != nil }
```

**`price`** = list/original price (always present, shown struck-through when on sale).
**`salePrice`** = discounted price (non-nil only when `status == .onSale`).
**`effectivePrice`** = what the buyer pays; used for cart total and price-sort.

All 5 product models (Painting, Sculpture, Ceramic, Jewelry, Cloth) gain these fields with defaults `status: .none, salePrice: nil` — no migration needed for existing tests.

---

## 3. ProductEngagement (analytics model)

Mirrors a backend analytics service: product models hold no counters; engagement is tracked separately.

```swift
@Model final class ProductEngagement {
    var productId: String
    var viewCount: Int
    var cartAddCount: Int
    var popularityScore: Int { viewCount + cartAddCount }
}
```

| Event | Trigger | Call |
|---|---|---|
| Product viewed | ProductDetailView `.task` | `di.engagement.recordView(productId:)` |
| Added to cart | AddToCartButton tap | `di.engagement.recordCartAdd(productId:)` |

**EngagementRepository** exposes `recordView`, `recordCartAdd`, `fetchAll`. Uses internal `findOrCreate(productId:)`.

Registered in `DIContainer.allModelTypes`.

---

## 4. Sort options

```swift
enum SortOption: String, CaseIterable {
    case none            // "Default"
    case popularity      // "Popular" — popularityScore desc
    case recent          // "Recent" — createdAt desc
    case priceAscending  // "Price ↑" — effectivePrice asc
    case priceDescending // "Price ↓" — effectivePrice desc
}
```

Applied in-memory after category + status filtering. Popularity sort builds `[productId: score]` dict from `@Query var engagements: [ProductEngagement]`.

---

## 5. UI

### Chip row order
`[Sort chip] [Filter chip] [All] [Paintings] [Sculptures] …`

- **Sort chip** — shows "Sort" (default) or active sort name; filled when sortOption ≠ .none. Tap → sort sheet.
- **Filter chip** — shows "Filter"; filled + dot indicator when selectedStatuses non-empty. Tap → filter sheet.
- Category chips unchanged.

### Sort sheet
- `presentationDetents([.height(280)])`
- Title "Sort by", 3-column `LazyVGrid` of icon circles
- Single selection; selecting dismisses immediately
- Selected: filled circle, inverse icon colour

### Filter sheet
- `presentationDetents([.medium, .large])`
- `NavigationStack`, title "Filters", "Clear" toolbar button (disabled when nothing selected)
- Status section: "New" + "On Sale" rows with checkbox toggle
- Local `draft: Set<ProductStatus>` committed only on "Show Results" tap
- "Show Results" CTA: disabled + grayed when draft empty

### Sheet management
Replace `selectedProduct: (any ProductDisplayable)?` in CatalogView with:
```swift
private enum ActiveSheet {
    case product(any ProductDisplayable)
    case sort
    case filter
}
@State private var activeSheet: ActiveSheet?
```
Single `.sheet(isPresented:)` with switch over `activeSheet`. `presentationDetents` applied inside each case's content view.

---

## 6. ProductCardView changes

- **Status badge:** overlay top-left on image. "New" (blue) for `.new`, "Sale" (red) for `.onSale`, hidden for `.none`.
- **Price:** not on sale → `price` as before. On sale → `price` struck-through (11pt secondary) + `salePrice` in red (13pt medium), side by side.

---

## 7. CartView changes

`totalPrice` uses `product.effectivePrice` so on-sale items charge the discounted rate.

---

## 8. Empty states

| State | What user sees |
|---|---|
| Status filter yields 0 results | Existing `EmptyCategoryView` reused |
| Sort active, results non-empty | Normal grid in new order |

No new empty state views needed.

---

## 9. Seed data distribution

| Status | Products |
|---|---|
| `.new` | 1 Painting, 1 Jewelry |
| `.onSale` | 1 Sculpture (salePrice ~20% below price), 1 Cloth (salePrice ~20% below price) |
| `.none` | remaining 6 |

---

## 10. Deliberate exclusions

| Excluded | Reason |
|---|---|
| Server-side popularity sync | No backend; ProductEngagement is the local mimic |
| Price range slider filter | Out of scope v1 |
| "On Sale" as category tab | Status is orthogonal to category |

---

## 11. Open / next

- **[OPEN]** Popularity sort only meaningful after user interactions — seed data starts all scores at 0. Acceptable for testbed.
- **[OPEN]** Verify `CartItemRow` price display — update to `effectivePrice` if it renders product price.
- Next: implementation per `linear-forging-mango.md`.
