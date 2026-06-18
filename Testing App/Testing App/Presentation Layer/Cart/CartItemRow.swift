import SwiftUI
import SwiftData

struct CartItemRow: View {
    let item: CartItem
    let product: any ProductDisplayable
    @Environment(DIContainer.self) private var di

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.system(size: 15, weight: .regular))

                if product.isOnSale, let salePrice = product.salePrice {
                    HStack(spacing: 4) {
                        Text(product.price, format: .currency(code: Locale.current.currency?.identifier ?? "BRL"))
                            .font(.system(size: 11, weight: .regular))
                            .foregroundStyle(.secondary)
                            .strikethrough()
                        Text(salePrice, format: .currency(code: Locale.current.currency?.identifier ?? "BRL"))
                            .font(.system(size: 13, weight: .regular))
                            .foregroundStyle(.red)
                    }
                } else {
                    Text(product.price, format: .currency(code: Locale.current.currency?.identifier ?? "BRL"))
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            HStack(spacing: 12) {
                Button("Remove one", systemImage: "minus") {
                    if item.quantity > 1 {
                        item.quantity -= 1
                        try? di.cart.save()
                    }
                }
                .labelStyle(.iconOnly)
                .buttonStyle(.bordered)

                Text("\(item.quantity)")
                    .font(.system(size: 15, weight: .medium))
                    .frame(minWidth: 24)

                Button("Add one", systemImage: "plus") {
                    item.quantity += 1
                    try? di.cart.save()
                }
                .labelStyle(.iconOnly)
                .buttonStyle(.bordered)
            }
        }
        .padding(.vertical, 4)
    }
}
