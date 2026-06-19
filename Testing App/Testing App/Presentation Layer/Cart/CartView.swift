import SwiftUI
import SwiftData

struct CartView: View {
    @State private var viewModel: CartViewModel
    @Query private var items: [CartItem]

    init(repository: CartRepository) {
        _viewModel = State(wrappedValue: CartViewModel(repository: repository))
    }

    var body: some View {
        Group {
            if items.isEmpty {
                CartEmptyState()
            } else {
                cartList
            }
        }
        .navigationTitle("Cart")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - List + sticky bottom

    private var cartList: some View {
        ZStack(alignment: .bottom) {
            List {
                ForEach(items) { item in
                    CartItemRow(
                        item: item,
                        onDecrement: { viewModel.decrement(item) },
                        onIncrement: { viewModel.increment(item) }
                    )
                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    .listRowSeparatorTint(Color(.separator))
                }
                .onDelete { offsets in
                    viewModel.delete(at: offsets, in: items)
                }

                Color.clear
                    .frame(height: 200)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)

            orderSummaryBar
        }
        .ignoresSafeArea(edges: .bottom)
    }

    // MARK: - Order summary bar

    private var orderSummaryBar: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color(.separator).opacity(0.5))
                .frame(height: 0.5)

            VStack(spacing: 14) {
                summaryRow(
                    label: "Subtotal",
                    value: Text(viewModel.totalPrice(for: items), format: .currency(code: currencyCode))
                )

                summaryRow(
                    label: "Shipping",
                    value: Text("Free").foregroundStyle(.green)
                )

                Divider()

                HStack {
                    Text("Total")
                        .font(.system(size: 17, weight: .bold))
                    Spacer()
                    Text(viewModel.totalPrice(for: items), format: .currency(code: currencyCode))
                        .font(.system(size: 17, weight: .bold))
                }

                checkoutButton
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 32)
            .background(.background)
        }
    }

    // MARK: - Summary row builder

    @ViewBuilder
    private func summaryRow(label: String, value: some View) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(.secondary)
            Spacer()
            value
                .font(.system(size: 15, weight: .regular))
        }
    }

    // MARK: - Checkout button

    private var checkoutButton: some View {
        Button {
            // TODO: navigate to checkout flow
        } label: {
            Text("Checkout")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(Color(.label))
                .clipShape(.capsule)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Helpers

    private var currencyCode: String {
        Locale.current.currency?.identifier ?? "BRL"
    }
}

// MARK: - Previews

#Preview("With items") {
    let stack = try? PersistenceStack(modelTypes: DIContainer.allModelTypes, isMemoryOnly: true)
    let repo = stack.flatMap { try? CartRepository(stack: $0) }
    let _ = {
        guard let ctx = stack?.context else { return }
        CartItem.mockCart.forEach { ctx.insert($0) }
        try? ctx.save()
    }()

    if let stack, let repo, let container = stack.container {
        NavigationStack {
            CartView(repository: repo)
        }
        .modelContainer(container)
    } else {
        ContentUnavailableView(
            "Preview unavailable",
            systemImage: "exclamationmark.triangle"
        )
    }
}

#Preview("Empty cart") {
    let stack = try? PersistenceStack(modelTypes: DIContainer.allModelTypes, isMemoryOnly: true)
    let repo = stack.flatMap { try? CartRepository(stack: $0) }

    if let stack, let repo, let container = stack.container {
        NavigationStack {
            CartView(repository: repo)
        }
        .modelContainer(container)
    } else {
        ContentUnavailableView(
            "Preview unavailable",
            systemImage: "exclamationmark.triangle"
        )
    }
}
