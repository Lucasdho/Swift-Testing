import SwiftUI

struct CartEmptyState: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "cart")
                .font(.system(size: 56, weight: .thin))
                .foregroundStyle(.tertiary)

            VStack(spacing: 6) {
                Text("Your cart is empty")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.primary)

                Text("Browse the gallery and add pieces\nyou love.")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    CartEmptyState()
}
