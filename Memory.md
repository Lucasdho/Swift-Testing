# Memory.md
Durable decisions for this project. Read before relitigating anything below.

---

## ProductCardView — image aspect ratio strategy

**Date:** 2026-06-18
**Files touched:** `ProductCardView.swift`, `ProductDisplayable.swift`, all 5 `@Model` types, `SeedData.swift`

### What was built (and kept)

`imageAspectRatio: Double?` was added to the `ProductDisplayable` protocol and all five SwiftData models (`Painting`, `Sculpture`, `Ceramic`, `Jewelry`, `Cloth`). All seed data entries pass `imageAspectRatio: nil` explicitly. The field is wired and ready for a future backend to populate real values.

### The rejected layout approach

A `Color.clear.aspectRatio(displayRatio, contentMode: .fit).overlay { … }.clipped()` container was implemented. The idea was sound — reserve a deterministic slot before the image arrives, then fill it — and the shimmer/placeholder behaviour was exactly right. **The problem:** once a real image loaded inside the fixed-ratio overlay with `.scaledToFill()`, it was cropped to that pre-determined ratio instead of showing its true dimensions. Every image in the grid ended up the same forced height regardless of what the photo actually looked like.

> The approach produced an interesting uniform-grid aesthetic, but it is not what we want here. Noted as a viable pattern for a grid where uniform card heights are a deliberate design goal.

### The settled approach

Three-branch `@ViewBuilder` — no outer container enforces a ratio on a loaded image:

| Branch | Layout rule |
|---|---|
| Image loaded | `.scaledToFit()` + `.frame(maxWidth: .infinity)` — the image sets its own height |
| Load failed | Error placeholder at `displayRatio` (metadata → hash fallback) |
| Loading | `ShimmerView` at `displayRatio` — reserves approximate space, prevents a cold jump |

`displayRatio` prefers `product.imageAspectRatio` when non-nil; falls back to `0.75 + CGFloat(abs(id.hashValue % 100)) / 100.0 * 0.6`.

### Decision
Do not re-introduce a forced outer aspect ratio on the image branch. If uniform card heights are ever wanted, revisit the overlay approach deliberately as a design choice, not as a layout fix.
