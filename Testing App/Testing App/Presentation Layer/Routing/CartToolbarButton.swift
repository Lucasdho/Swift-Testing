import SwiftUI
import SwiftData

struct CartToolbarButton: View {
    @Query private var cartItems: [CartItem]

    var body: some View {
        NavigationLink {
            CartView()
        } label: {
            Image(systemName: "cart")
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
                .padding(4)
        }
    }
}
