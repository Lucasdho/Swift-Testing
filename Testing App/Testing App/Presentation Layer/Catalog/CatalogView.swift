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
                emptyStore
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        categoryChips
                            .padding(.top, 12)

                        if products.isEmpty {
                            emptyCategory
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

    private var emptyStore: some View {
        VStack(spacing: 16) {
            Image(systemName: "storefront")
                .font(.system(size: 48))
                .foregroundStyle(.tertiary)
            Text("No products yet")
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(.primary)
            Text("Check back soon for new arrivals.")
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var emptyCategory: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray")
                .font(.system(size: 40))
                .foregroundStyle(.tertiary)
            Text("Nothing in this category")
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 64)
    }

    private var categoryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                chip(title: "All", isSelected: selectedCategory == nil) {
                    selectedCategory = nil
                }
                ForEach(Category.allCases, id: \.rawValue) { category in
                    chip(title: category.categoryDisplayName, isSelected: selectedCategory == category) {
                        selectedCategory = selectedCategory == category ? nil : category
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private func chip(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(isSelected ? Color(.systemBackground) : .primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(isSelected ? Color.primary : Color(.secondarySystemBackground))
                .clipShape(.rect(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }
}
