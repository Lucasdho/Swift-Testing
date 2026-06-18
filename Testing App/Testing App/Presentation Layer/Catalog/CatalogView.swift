import SwiftUI
import SwiftData

struct CatalogView: View {
    @Query private var paintings: [Painting]
    @Query private var sculptures: [Sculpture]
    @Query private var ceramics: [Ceramic]
    @Query private var jewelry: [Jewelry]
    @Query private var cloths: [Cloth]
    @Query private var engagements: [ProductEngagement]

    @State private var selectedCategories: Set<Category> = []
    @State private var sortOption: SortOption = .none
    @State private var activeSheet: ActiveSheet?

    private var allProducts: [any ProductDisplayable] {
        paintings + sculptures + ceramics + jewelry + cloths
    }

    private var engagementMap: [String: Int] {
        Dictionary(uniqueKeysWithValues: engagements.map { ($0.productId, $0.popularityScore) })
    }

    private var filteredAndSortedProducts: [any ProductDisplayable] {
        var result: [any ProductDisplayable]
        if selectedCategories.isEmpty {
            result = allProducts
        } else {
            result = allProducts.filter { selectedCategories.contains($0.category) }
        }

        switch sortOption {
        case .none:
            break
        case .popularity:
            result = result.sorted { (engagementMap[$0.id] ?? 0) > (engagementMap[$1.id] ?? 0) }
        case .recent:
            result = result.sorted { $0.createdAt > $1.createdAt }
        case .priceAscending:
            result = result.sorted { $0.effectivePrice < $1.effectivePrice }
        case .priceDescending:
            result = result.sorted { $0.effectivePrice > $1.effectivePrice }
        }

        return result
    }

    var body: some View {
        Group {
            if allProducts.isEmpty {
                EmptyStoreView()
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        chipRow.padding(.top, 12)

                        if filteredAndSortedProducts.isEmpty {
                            EmptyCategoryView()
                        } else {
                            LazyVGrid(
                                columns: [GridItem(.adaptive(minimum: 160), spacing: 12)],
                                spacing: 12
                            ) {
                                ForEach(filteredAndSortedProducts, id: \.id) { product in
                                    Button {
                                        activeSheet = .product(product)
                                    } label: {
                                        ProductCardView(product: product)
                                    }
                                    .buttonStyle(.plain)
                                    .contentShape(Rectangle())
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
        .sheet(isPresented: Binding(
            get: { activeSheet != nil },
            set: { if !$0 { activeSheet = nil } }
        )) {
            switch activeSheet {
            case .product(let p):
                ProductDetailView(product: p)
            case .sort:
                SortSheet(selected: $sortOption)
                    .presentationDetents([.height(280)])
            case nil:
                EmptyView()
            }
        }
    }

    private var chipRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(
                    title: sortOption == .none ? "Sort" : sortOption.rawValue,
                    isSelected: sortOption != .none,
                    trailingIcon: "chevron.down"
                ) {
                    activeSheet = .sort
                }

                ForEach(Category.allCases, id: \.rawValue) { category in
                    FilterChip(
                        title: category.categoryDisplayName,
                        isSelected: selectedCategories.contains(category)
                    ) {
                        if selectedCategories.contains(category) {
                            selectedCategories.remove(category)
                        } else {
                            selectedCategories.insert(category)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

private enum ActiveSheet {
    case product(any ProductDisplayable)
    case sort
}
