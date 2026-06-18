import SwiftUI

struct PriceView: View {
    let product: any ProductDisplayable
    var size: CGFloat = 13
    var weight: Font.Weight = .regular
    var originalSize: CGFloat? = nil

    var body: some View {
        if product.isOnSale, let salePrice = product.salePrice {
            HStack(spacing: 4) {
                Text(product.price, format: .currency(code: currencyCode))
                    .font(.system(size: originalSize ?? size - 2, weight: weight))
                    .foregroundStyle(.secondary)
                    .strikethrough()
                Text(salePrice, format: .currency(code: currencyCode))
                    .font(.system(size: size, weight: weight))
                    .foregroundStyle(.red)
            }
        } else {
            Text(product.price, format: .currency(code: currencyCode))
                .font(.system(size: size, weight: weight))
                .foregroundStyle(.secondary)
        }
    }

    private var currencyCode: String {
        Locale.current.currency?.identifier ?? "BRL"
    }
}
