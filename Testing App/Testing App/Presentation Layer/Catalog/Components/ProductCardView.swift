import SwiftUI

struct ProductCardView: View {
    let product: any ProductDisplayable

    @State private var imageData: Data?
    @State private var imageLoaded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topLeading) {
                imageArea

                if product.status != .none {
                    Text(product.status == .new ? "New" : "Sale")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(product.status == .new ? Color.blue : Color.red)
                        .clipShape(.rect(cornerRadius: 12))
                        .padding(8)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                PriceView(product: product, size: 13, weight: .medium)
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
            // load failed — show category icon at placeholder ratio
            ZStack {
                Color(.secondarySystemBackground)
                Image(systemName: categoryIcon)
                    .font(.system(size: 32))
                    .foregroundStyle(.tertiary)
            }
            .aspectRatio(placeholderRatio, contentMode: .fit)
        } else {
            ShimmerView()
                .aspectRatio(placeholderRatio, contentMode: .fit)
                .frame(maxWidth: .infinity)
        }
    }

    // Deterministic pseudo-random ratio per product for visual variety (0.75 – 1.35)
    private var placeholderRatio: CGFloat {
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
}
