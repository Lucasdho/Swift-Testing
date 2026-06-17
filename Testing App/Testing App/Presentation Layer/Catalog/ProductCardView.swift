import SwiftUI

struct ProductCardView: View {
    let product: any ProductDisplayable

    @State private var imageData: Data?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
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
            .frame(height: 160)
            .clipped()

            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                Text(product.price, format: .currency(code: Locale.current.currency?.identifier ?? "BRL"))
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.secondary)
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
