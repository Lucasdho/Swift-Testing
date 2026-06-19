import SwiftUI
import SwiftData

struct CartItemRow: View {
    let item: CartItem
    let onDecrement: () -> Void
    let onIncrement: () -> Void

    @State private var imageData: Data?
    @State private var imageLoaded = false
    
    var product: any ProductDisplayable { item.product }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            thumbnailView
                .frame(width: 80, height: 80)
                .clipShape(.rect(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 5) {
                Text(product.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                
                HStack(spacing: 8) {
                    if let subtitle = product.displayAttributes().first {
                        Text(subtitle.value)
                            .font(.system(size: 13, weight: .regular))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                        
                        Text("•")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundStyle(Color(.tertiaryLabel))
                    }
                    
                    Text(product.categoryDisplayName)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(Color(.tertiaryLabel))
                }

                HStack {
                    PriceView(
                        price: product.price,
                        salePrice: product.salePrice,
                        size: 13,
                        regularWeight: .semibold
                    )

                    Spacer()

                    quantityStepper
                }
                .padding(.top, 6)
            }
        }
        .padding(.vertical, 12)
        .task {
            defer { imageLoaded = true }
            guard let urlString = product.imageURLs.first,
                  let url = URL(string: urlString) else { return }
            imageData = await ImageCaching.shared.getImage(url: url)
        }
    }

    // MARK: - Thumbnail

    @ViewBuilder
    private var thumbnailView: some View {
        if let data = imageData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
        } else if imageLoaded {
            ZStack {
                Color(.secondarySystemBackground)
                Image(systemName: categoryIcon)
                    .font(.system(size: 28))
                    .foregroundStyle(.tertiary)
            }
        } else {
            ShimmerView()
        }
    }

    // MARK: - Quantity stepper

    private var quantityStepper: some View {
        HStack(spacing: 6) {
            Button(action: onDecrement) {
                Image(systemName: "minus")
                    .font(.system(size: 11, weight: .regular))
                    .frame(width: 24, height: 24)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(.circle)
            }
            .buttonStyle(.plain)
            .disabled(item.quantity <= 1)

            Text("\(item.quantity)")
                .font(.system(size: 14, weight: .medium))
                .frame(minWidth: 20, alignment: .center)

            Button(action: onIncrement) {
                Image(systemName: "plus")
                    .font(.system(size: 11, weight: .regular))
                    .frame(width: 24, height: 24)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(.circle)
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Helpers

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

// MARK: - Preview

#Preview {
    List {
        CartItemRow(item: .mockJewelrySale, onDecrement: {}, onIncrement: {})
            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
    }
    .listStyle(.plain)
}

