#if DEBUG
import Foundation

// MARK: - Painting

extension Painting {
    /// Lightweight mock instance for SwiftUI Previews. Not inserted into any ModelContext.
    static let mock = Painting(
        id: "preview-painting-001",
        name: "Solstice No. 3",
        price: 4800,
        status: .new,
        imageURLs: ["https://images.unsplash.com/photo-1641002487920-0c3d5ca4573e?w=400"],
        productDescription: "A vibrant abstract composition in terracotta and indigo.",
        medium: "Oil on canvas",
        dimensions: "90 × 120 cm",
        artist: "Elara Voss"
    )

    /// Sale variant — same painting at 25% off.
    static let mockSale = Painting(
        id: "preview-painting-002",
        name: "Solstice No. 3",
        price: 4800,
        salePrice: 3600,
        status: .onSale,
        imageURLs: ["https://images.unsplash.com/photo-1641002487920-0c3d5ca4573e?w=400"],
        productDescription: "A vibrant abstract composition in terracotta and indigo.",
        medium: "Oil on canvas",
        dimensions: "90 × 120 cm",
        artist: "Elara Voss"
    )
}

// MARK: - Sculpture

extension Sculpture {
    /// Lightweight mock instance for SwiftUI Previews. Not inserted into any ModelContext.
    static let mock = Sculpture(
        id: "preview-sculpture-001",
        name: "Twisted Form",
        price: 1200,
        salePrice: 960,
        status: .onSale,
        imageURLs: ["https://images.unsplash.com/photo-1770492727730-05cb5ff3e90a?w=400"],
        productDescription: "Abstract bronze casting, limited edition.",
        material: "Bronze",
        dimensions: "H 40 cm",
        artist: "Ana Lima"
    )

    /// Sale variant — 30% off list price.
    static let mockSale = Sculpture(
        id: "preview-sculpture-002",
        name: "Twisted Form",
        price: 1200,
        salePrice: 840,
        status: .onSale,
        imageURLs: ["https://images.unsplash.com/photo-1770492727730-05cb5ff3e90a?w=400"],
        productDescription: "Abstract bronze casting, limited edition.",
        material: "Bronze",
        dimensions: "H 40 cm",
        artist: "Ana Lima"
    )
}

// MARK: - Ceramic

extension Ceramic {
    /// Lightweight mock instance for SwiftUI Previews. Not inserted into any ModelContext.
    static let mock = Ceramic(
        id: "preview-ceramic-001",
        name: "Celadon Bowl",
        price: 180,
        imageURLs: ["https://images.unsplash.com/photo-1778215251269-dbf83abca50b?w=400"],
        productDescription: "Hand-thrown stoneware with celadon glaze.",
        technique: "Wheel-thrown",
        glaze: "Celadon",
        artist: "João Alves"
    )

    /// Sale variant — 20% off.
    static let mockSale = Ceramic(
        id: "preview-ceramic-002",
        name: "Celadon Bowl",
        price: 180,
        salePrice: 144,
        status: .onSale,
        imageURLs: ["https://images.unsplash.com/photo-1778215251269-dbf83abca50b?w=400"],
        productDescription: "Hand-thrown stoneware with celadon glaze.",
        technique: "Wheel-thrown",
        glaze: "Celadon",
        artist: "João Alves"
    )
}

// MARK: - Jewelry

extension Jewelry {
    /// Lightweight mock instance for SwiftUI Previews. Not inserted into any ModelContext.
    static let mock = Jewelry(
        id: "preview-jewelry-001",
        name: "Silver Crescent",
        price: 320,
        status: .new,
        imageURLs: ["https://images.unsplash.com/photo-1713004539634-a6694a83f3d9?w=400"],
        productDescription: "Oxidised sterling silver, handmade.",
        material: "Sterling Silver",
        jewelryType: "Necklace",
        artist: "Ana Lima"
    )

    /// Sale variant — 15% off.
    static let mockSale = Jewelry(
        id: "preview-jewelry-002",
        name: "Silver Crescent",
        price: 320,
        salePrice: 272,
        status: .onSale,
        imageURLs: ["https://images.unsplash.com/photo-1713004539634-a6694a83f3d9?w=400"],
        productDescription: "Oxidised sterling silver, handmade.",
        material: "Sterling Silver",
        jewelryType: "Necklace",
        artist: "Ana Lima"
    )
}

// MARK: - Cloth

extension Cloth {
    /// Lightweight mock instance for SwiftUI Previews. Not inserted into any ModelContext.
    static let mock = Cloth(
        id: "preview-cloth-001",
        name: "Vintage Denim Jacket",
        price: 120,
        salePrice: 96,
        status: .onSale,
        imageURLs: ["https://images.unsplash.com/photo-1778865576241-6739d4a6aa95?w=400"],
        productDescription: "90s wash, minor wear on cuffs.",
        clothingSize: "M",
        condition: .good,
        brand: "Levi's"
    )

    /// Sale variant — 35% off list price.
    static let mockSale = Cloth(
        id: "preview-cloth-002",
        name: "Vintage Denim Jacket",
        price: 120,
        salePrice: 78,
        status: .onSale,
        imageURLs: ["https://images.unsplash.com/photo-1778865576241-6739d4a6aa95?w=400"],
        productDescription: "90s wash, minor wear on cuffs.",
        clothingSize: "M",
        condition: .good,
        brand: "Levi's"
    )
}

// MARK: - CartItem

extension CartItem {
    /// Cart item wrapping ``Painting.mock``, quantity 2.
    static let mock = CartItem(painting: .mock, quantity: 2)

    /// Cart item wrapping ``Sculpture.mock``, quantity 1.
    static let mockSculpture = CartItem(sculpture: .mock, quantity: 1)

    /// Cart item wrapping ``Ceramic.mock``, quantity 3.
    static let mockCeramic = CartItem(ceramic: .mock, quantity: 3)

    /// Cart item wrapping ``Jewelry.mock``, quantity 1.
    static let mockJewelry = CartItem(jewelry: .mock, quantity: 1)

    /// Cart item wrapping ``Cloth.mock``, quantity 1.
    static let mockCloth = CartItem(cloth: .mock, quantity: 1)

    // MARK: Sale variants

    /// Cart item wrapping ``Painting.mockSale``, quantity 1.
    static let mockPaintingSale = CartItem(painting: .mockSale, quantity: 1)

    /// Cart item wrapping ``Sculpture.mockSale``, quantity 2.
    static let mockSculptureSale = CartItem(sculpture: .mockSale, quantity: 2)

    /// Cart item wrapping ``Ceramic.mockSale``, quantity 1.
    static let mockCeramicSale = CartItem(ceramic: .mockSale, quantity: 1)

    /// Cart item wrapping ``Jewelry.mockSale``, quantity 1.
    static let mockJewelrySale = CartItem(jewelry: .mockSale, quantity: 1)

    /// Cart item wrapping ``Cloth.mockSale``, quantity 1.
    static let mockClothSale = CartItem(cloth: .mockSale, quantity: 1)

    // MARK: Cart arrays

    /// A representative cart with one item per product category.
    /// Useful for list-based previews (e.g. ``CartView``).
    static let mockCart: [CartItem] = [
        .mock,
        .mockSculpture,
        .mockCeramic,
        .mockJewelry,
        .mockCloth
    ]

    /// A cart with sale-priced items across all categories.
    /// Useful for previewing strike-through prices and sale badges.
    static let mockSaleCart: [CartItem] = [
        .mockPaintingSale,
        .mockSculptureSale,
        .mockCeramicSale,
        .mockJewelrySale,
        .mockClothSale
    ]
}
#endif
