import SwiftUI

struct ProductHeaderSection: View {
    let product: any ProductDisplayable

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(product.categoryDisplayName)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.tertiary)
                .tracking(1.5)
                .textCase(.uppercase)

            Text(product.name)
                .font(.system(size: 24, weight: .light))
                .foregroundStyle(.primary)

            Text(product.price, format: .currency(code: Locale.current.currency?.identifier ?? "BRL"))
                .font(.system(size: 20, weight: .light))
                .foregroundStyle(.secondary)

            if !product.productDescription.isEmpty {
                Text(product.productDescription)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
            }
        }
    }
}
