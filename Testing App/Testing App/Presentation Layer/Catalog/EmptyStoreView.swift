import SwiftUI

struct EmptyStoreView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "storefront")
                .font(.system(size: 48))
                .foregroundStyle(.tertiary)
            Text("No products yet")
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(.primary)
            Text("Check back soon for new arrivals.")
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    EmptyStoreView()
}
