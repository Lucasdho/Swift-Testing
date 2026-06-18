import SwiftUI

struct ProductCardView: View {
    let product: any ProductDisplayable

    @State private var imageData: Data?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topLeading) {
                ZStack {
                    Color(.secondarySystemBackground)
                    if let data = imageData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                    } else {
                        Image(systemName: categoryIcon)
                            .font(.system(size: 32))
                            .foregroundStyle(.tertiary)
                    }
                }
                .aspectRatio(4/3, contentMode: .fit)
                .clipped()

                if product.status != .none {
                    Text(product.status == .new ? "New" : "Sale")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(product.status == .new ? Color.blue : Color.red)
                        .clipShape(.rect(cornerRadius: 6))
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
        .clipShape(.rect(cornerRadius: 10))
        .task {
            guard let urlString = product.imageURLs.first,
                  let url = URL(string: urlString) else { return }
            imageData = await ImageCaching.shared.getImage(url: url)
        }
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
