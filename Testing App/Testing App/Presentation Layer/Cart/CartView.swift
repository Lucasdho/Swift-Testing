import SwiftUI
import SwiftData

struct CartView: View {
    @Query private var items: [CartItem]
    @Environment(DIContainer.self) private var di

    var body: some View {
        Group {
            if items.isEmpty {
                CartEmptyState()
            } else {
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
        }
        .navigationTitle("Cart")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var totalPrice: Decimal {
        items.reduce(Decimal.zero) { sum, item in
            guard let product = item.product else { return sum }
            return sum + product.effectivePrice * Decimal(item.quantity)
        }
    }

    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            try? di.cart.delete(items[index])
        }
    }
}
