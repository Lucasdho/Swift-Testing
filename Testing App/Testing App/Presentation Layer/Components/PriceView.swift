import SwiftUI

struct PriceView: View {
    let price: Decimal
    var salePrice: Decimal? = nil

    var size: CGFloat = 13
    var originalSize: CGFloat? = nil
    var regularWeight: Font.Weight = .regular
    var saleWeight: Font.Weight = .bold

    var body: some View {
        if let salePrice {
            HStack(spacing: 4) {
                Text(price, format: .currency(code: currencyCode))
                    .font(.system(size: originalSize ?? size - 1, weight: regularWeight))
                    .foregroundStyle(.secondary)
                    .strikethrough()

                Text(salePrice, format: .currency(code: currencyCode))
                    .font(.system(size: size + 1, weight: saleWeight))
                    .foregroundStyle(.red)
            }
        } else {
            Text(price, format: .currency(code: currencyCode))
                .font(.system(size: size, weight: regularWeight))
                .foregroundStyle(.secondary)
        }
    }

    private var currencyCode: String {
        Locale.current.currency?.identifier ?? "BRL"
    }
}
