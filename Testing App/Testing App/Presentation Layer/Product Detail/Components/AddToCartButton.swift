import SwiftUI

struct AddToCartButton: View {
    let isAdded: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(
                isAdded ? "Added to Cart" : "Add to Cart",
                systemImage: isAdded ? "checkmark" : "cart.badge.plus"
            )
            .font(.system(size: 15, weight: .medium))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(isAdded ? Color(.systemGreen).opacity(0.15) : Color.primary)
            .foregroundStyle(isAdded ? Color(.systemGreen) : Color(.systemBackground))
            .clipShape(.rect(cornerRadius: 16))
        }
        .animation(.easeInOut(duration: 0.2), value: isAdded)
    }
}

#Preview {
    VStack(spacing: 16) {
        AddToCartButton(isAdded: false, action: {})
        AddToCartButton(isAdded: true, action: {})
    }
    .padding()
}
