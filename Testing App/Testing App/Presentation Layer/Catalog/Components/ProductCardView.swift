import SwiftUI

struct ProductCardView: View {
    let product: any ProductDisplayable

    @State private var imageData: Data?
    @State private var imageLoaded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topLeading) {
                imageArea

                // Horizontal row of status badges — one per tag.
                if !tags.isEmpty {
                    HStack(spacing: 4) {
                        ForEach(tags, id: \.label) { tag in
                            Text(tag.label)
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(tag.color)
                                .clipShape(.rect(cornerRadius: 12))
                        }
                    }
                    .padding(8)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                PriceView(price: product.price, salePrice: product.salePrice, size: 13, regularWeight: .medium)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
        }
        .background(Color(.secondarySystemBackground))
        .clipShape(.rect(cornerRadius: 12))
        .task {
            defer { imageLoaded = true }
            guard let urlString = product.imageURLs.first,
                  let url = URL(string: urlString) else { return }
            imageData = await ImageCaching.shared.getImage(url: url)
        }
    }

    @ViewBuilder
    private var imageArea: some View {
        if let data = imageData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .transition(.opacity)
        } else if imageLoaded {
            ZStack {
                Color(.secondarySystemBackground)
                Image(systemName: categoryIcon)
                    .font(.system(size: 32))
                    .foregroundStyle(.tertiary)
            }
            .aspectRatio(displayRatio, contentMode: .fit)
        } else {
            ShimmerView()
                .aspectRatio(displayRatio, contentMode: .fit)
                .frame(maxWidth: .infinity)
        }
    }

    private var displayRatio: CGFloat {
        if let ratio = product.imageAspectRatio {
            return CGFloat(ratio)
        }
        let hash = abs(product.id.hashValue % 100)
        return 0.75 + CGFloat(hash) / 100.0 * 0.6
    }

    private var categoryIcon: String {
        switch product.category {
        case .painting:  "paintbrush"
        case .sculpture: "cube"
        case .ceramic:   "cup.and.saucer"
        case .jewelry:   "sparkles"
        case .clothing:  "tshirt"
        }
    }

    // Maps the current single `status` to a badge list.
    // When the domain model evolves to support multiple statuses,
    // update only this property — the HStack layout above needs no changes.
    private var tags: [Tag] {
        switch product.status {
        case .none:   []
        case .new:    [Tag(label: "NEW",  color: .blue)]
        case .onSale: [Tag(label: "SALE", color: .red)]
        }
    }

    private struct Tag {
        let label: String
        let color: Color
    }
}
