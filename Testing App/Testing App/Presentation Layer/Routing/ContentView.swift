import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var isCartPresented = false

    var body: some View {
        NavigationStack {
            CatalogView()
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        CartToolbarButton(isPresented: $isCartPresented)
                    }
                }
        }
        .sheet(isPresented: $isCartPresented) {
            CartView()
        }
    }
}

private struct CartToolbarButton: View {
    @Binding var isPresented: Bool
    @Query private var cartItems: [CartItem]

    var body: some View {
        Button("Cart", systemImage: "cart") {
            isPresented = true
        }
        .overlay(alignment: .topTrailing) {
            if !cartItems.isEmpty {
                Text("\(cartItems.count)")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(Color(.systemBackground))
                    .padding(4)
                    .background(Color.primary)
                    .clipShape(Circle())
                    .offset(x: 8, y: -8)
            }
        }
    }
}
