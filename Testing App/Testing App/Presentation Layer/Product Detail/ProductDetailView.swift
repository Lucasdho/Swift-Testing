import SwiftUI

struct ProductDetailView: View {
    let product: any ProductDisplayable

    @Environment(DIContainer.self) private var di
    @State private var imageData: Data?
    @State private var addedToCart = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                heroImage

                VStack(alignment: .leading, spacing: 24) {
                    headerSection
                    attributesSection
                    addToCartButton
                }
                .padding(.horizontal, 16)
                .padding(.top, 24)
                .padding(.bottom, 32)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            guard let urlString = product.imageURLs.first,
                  let url = URL(string: urlString) else { return }
            imageData = await ImageCaching.shared.getImage(url: url)
        }
    }

    private var heroImage: some View {
        ZStack {
            Color(.secondarySystemBackground)
            if let data = imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "photo")
                    .font(.system(size: 48))
                    .foregroundStyle(.tertiary)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 280)
        .clipped()
    }

    private var headerSection: some View {
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

    @ViewBuilder
    private var attributesSection: some View {
        let attrs = product.displayAttributes()
        if !attrs.isEmpty {
            VStack(spacing: 0) {
                ForEach(Array(attrs.enumerated()), id: \.offset) { index, attr in
                    HStack {
                        Text(attr.label)
                            .font(.system(size: 15, weight: .regular))
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(attr.value)
                            .font(.system(size: 15, weight: .regular))
                            .foregroundStyle(.primary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)

                    if index < attrs.count - 1 {
                        Divider().padding(.leading, 16)
                    }
                }
            }
            .background(Color(.secondarySystemBackground))
            .clipShape(.rect(cornerRadius: 10))
        }
    }

    private var addToCartButton: some View {
        Button {
            addToCart()
        } label: {
            Label(
                addedToCart ? "Added to Cart" : "Add to Cart",
                systemImage: addedToCart ? "checkmark" : "cart.badge.plus"
            )
            .font(.system(size: 15, weight: .medium))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(addedToCart ? Color(.systemGreen).opacity(0.15) : Color.primary)
            .foregroundStyle(addedToCart ? Color(.systemGreen) : Color(.systemBackground))
            .clipShape(.rect(cornerRadius: 10))
        }
        .animation(.easeInOut(duration: 0.2), value: addedToCart)
    }

    private func addToCart() {
        try? di.cart.addOrIncrement(product)
        addedToCart = true
    }
}
