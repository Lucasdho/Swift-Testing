import SwiftUI
import SwiftData

struct CartView: View {
    @Query private var items: [CartItem]
    @Environment(DIContainer.self) private var di
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Group {
                if items.isEmpty {
                    emptyState
                } else {
                    cartList
                }
            }
            .navigationTitle("Cart")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "cart")
                .font(.system(size: 48))
                .foregroundStyle(.tertiary)
            Text("Your cart is empty")
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var cartList: some View {
        List {
            ForEach(items) { item in
                if let product = item.product {
                    CartItemRow(item: item, product: product)
                }
            }
            .onDelete(perform: deleteItems)

            Section {
                HStack {
                    Text("Total")
                        .font(.system(size: 15, weight: .medium))
                    Spacer()
                    Text(totalPrice, format: .currency(code: Locale.current.currency?.identifier ?? "BRL"))
                        .font(.system(size: 15, weight: .medium))
                }
            }
        }
    }

    private var totalPrice: Decimal {
        items.reduce(Decimal.zero) { sum, item in
            guard let product = item.product else { return sum }
            return sum + product.price * Decimal(item.quantity)
        }
    }

    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            try? di.cart.delete(items[index])
        }
    }
}

private struct CartItemRow: View {
    let item: CartItem
    let product: any ProductDisplayable
    @Environment(DIContainer.self) private var di

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.system(size: 15, weight: .regular))
                Text(product.price, format: .currency(code: Locale.current.currency?.identifier ?? "BRL"))
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(.secondary)
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
