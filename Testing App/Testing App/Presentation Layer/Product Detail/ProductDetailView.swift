import SwiftUI

struct ProductDetailView: View {
    let product: any ProductDisplayable

    @Environment(DIContainer.self) private var di
    @State private var imageDatas: [Data] = []
    @State private var addedToCart = false
    @State private var showImageViewer = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ProductHeroImage(imageData: imageDatas.first)
                    .onTapGesture { if !imageDatas.isEmpty { showImageViewer = true } }
                    .overlay(alignment: .bottomTrailing) {
                        if !imageDatas.isEmpty {
                            Image(systemName: "arrow.up.left.and.arrow.down.right")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(.white)
                                .padding(6)
                                .background(Color.black.opacity(0.45))
                                .clipShape(.rect(cornerRadius: 6))
                                .padding(10)
                        }
                    }

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
        .sheet(isPresented: $showImageViewer) {
            ImageViewerSheet(images: imageDatas)
        }
        .task {
            var datas: [Data] = []
            for urlString in product.imageURLs {
                guard let url = URL(string: urlString) else { continue }
                if let data = await ImageCaching.shared.getImage(url: url) {
                    datas.append(data)
                }
            }
            imageDatas = datas
            try? di.engagement.recordView(productId: product.id)
        }
    }

    private func addToCart() {
        try? di.cart.addOrIncrement(product)
        try? di.engagement.recordCartAdd(productId: product.id)
        addedToCart = true
    }
}
