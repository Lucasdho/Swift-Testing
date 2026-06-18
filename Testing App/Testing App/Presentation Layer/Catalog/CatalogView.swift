import SwiftUI
import SwiftData

struct CatalogView: View {
    @Query private var paintings: [Painting]
    @Query private var sculptures: [Sculpture]
    @Query private var ceramics: [Ceramic]
    @Query private var jewelry: [Jewelry]
    @Query private var cloths: [Cloth]

    @State private var selectedCategory: Category?
    @State private var selectedProduct: (any ProductDisplayable)?

    private var allProducts: [any ProductDisplayable] {
        paintings + sculptures + ceramics + jewelry + cloths
    }

    private var products: [any ProductDisplayable] {
        guard let category = selectedCategory else { return allProducts }
        return allProducts.filter { $0.category == category }
    }

    var body: some View {
        Group {
            if allProducts.isEmpty {
                EmptyStoreView()
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                FilterChip(title: "All", isSelected: selectedCategory == nil) {
                                    selectedCategory = nil
                                }
                                ForEach(Category.allCases, id: \.rawValue) { category in
                                    FilterChip(
                                        title: category.categoryDisplayName,
                                        isSelected: selectedCategory == category
                                    ) {
                                        selectedCategory = selectedCategory == category ? nil : category
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        .padding(.top, 12)

                        if products.isEmpty {
                            EmptyCategoryView()
                        } else {
                            LazyVGrid(
                                columns: [GridItem(.adaptive(minimum: 160), spacing: 12)],
                                spacing: 12
                            ) {
                                ForEach(products, id: \.id) { product in
                                    Button {
                                        selectedProduct = product
                                    } label: {
                                        ProductCardView(product: product)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                        }
                    }
                }
            }
        }
        .navigationTitle("Store")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: .init(
            get: { selectedProduct != nil },
            set: { if !$0 { selectedProduct = nil } }
        )) {
            if let product = selectedProduct {
                ProductDetailView(product: product)
            }
        }
    }
}
