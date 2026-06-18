import SwiftUI

struct ProductDetailView: View {
    let product: any ProductDisplayable

    @Environment(DIContainer.self) private var di
    @State private var imageData: Data?
    @State private var addedToCart = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ProductHeroImage(imageData: imageData)

                VStack(alignment: .leading, spacing: 24) {
                    ProductHeaderSection(product: product)
                    ProductAttributesSection(attributes: product.displayAttributes())
                    AddToCartButton(isAdded: addedToCart, action: addToCart)
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
            try? di.engagement.recordView(productId: product.id)
        }
    }

    private func addToCart() {
        try? di.cart.addOrIncrement(product)
        try? di.engagement.recordCartAdd(productId: product.id)
        addedToCart = true
    }
}
