import Testing
import SwiftData
import Foundation
@testable import Testing_App

private let allModelTypes: [any PersistentModel.Type] = [
    Painting.self, Sculpture.self, Ceramic.self, Jewelry.self, Cloth.self, CartItem.self, ImageModel.self
]

// MARK: — displayAttributes

struct PaintingDisplayAttributesTests {
    let sut = Painting(name: "Test", price: 100, medium: "Oil", dimensions: "40x50", artist: "A. Artist")

    @Test func returnsCorrectLabels() {
        #expect(sut.displayAttributes().map(\.label) == ["Medium", "Dimensions", "Artist"])
    }

    @Test func returnsCorrectValues() {
        let attrs = sut.displayAttributes()
        #expect(attrs[0].value == "Oil")
        #expect(attrs[1].value == "40x50")
        #expect(attrs[2].value == "A. Artist")
    }
}

struct SculptureDisplayAttributesTests {
    let sut = Sculpture(name: "Test", price: 200, material: "Bronze", dimensions: "H 30 cm", artist: "B. Artist")

    @Test func returnsCorrectLabels() {
        #expect(sut.displayAttributes().map(\.label) == ["Material", "Dimensions", "Artist"])
    }

    @Test func returnsCorrectValues() {
        let attrs = sut.displayAttributes()
        #expect(attrs[0].value == "Bronze")
        #expect(attrs[1].value == "H 30 cm")
        #expect(attrs[2].value == "B. Artist")
    }
}

struct CeramicDisplayAttributesTests {
    let sut = Ceramic(name: "Bowl", price: 150, technique: "Wheel-thrown", glaze: "Celadon", artist: "C. Artist")

    @Test func returnsCorrectLabels() {
        #expect(sut.displayAttributes().map(\.label) == ["Technique", "Glaze", "Artist"])
    }
}

struct JewelryDisplayAttributesTests {
    let sut = Jewelry(name: "Ring", price: 80, material: "Silver", jewelryType: "Ring", artist: "D. Artist")

    @Test func returnsCorrectLabels() {
        #expect(sut.displayAttributes().map(\.label) == ["Type", "Material", "Artist"])
    }
}

struct ClothDisplayAttributesTests {
    let sut = Cloth(name: "Jacket", price: 80, clothingSize: "L", condition: .good, brand: "Brand X")

    @Test func returnsCorrectLabels() {
        #expect(sut.displayAttributes().map(\.label) == ["Size", "Condition", "Brand"])
    }

    @Test func noBrandSkipsBrandRow() {
        let cloth = Cloth(name: "Shirt", price: 40, clothingSize: "M", condition: .new, brand: "")
        #expect(cloth.displayAttributes().map(\.label) == ["Size", "Condition"])
    }
}

// MARK: — Repository

@MainActor
struct PaintingRepositoryTests {
    let stack: PersistenceStack
    let repo: PaintingRepository

    init() throws {
        stack = try PersistenceStack(modelTypes: allModelTypes, isMemoryOnly: true)
        repo = try PaintingRepository(stack: stack)
    }

    @Test func fetchAllReturnsInsertedPaintings() throws {
        let painting = Painting(name: "Blue", price: 100, medium: "Acrylic", dimensions: "50x60", artist: "X")
        try repo.add(painting)
        let results = try repo.fetchAll()
        #expect(results.count == 1)
        let first = try #require(results.first)
        #expect(first.name == "Blue")
    }
}

// MARK: — CartRepository

@MainActor
struct CartRepositoryTests {
    let stack: PersistenceStack
    let cartRepo: CartRepository

    init() throws {
        stack = try PersistenceStack(modelTypes: allModelTypes, isMemoryOnly: true)
        cartRepo = try CartRepository(stack: stack)
    }

    @Test func addOrIncrementCreatesNewItemWithQuantityOne() throws {
        let painting = Painting(name: "X", price: 50, medium: "Oil", dimensions: "10x10", artist: "Y")
        stack.context?.insert(painting)
        try stack.context?.save()

        try cartRepo.addOrIncrement(painting)

        let items = try cartRepo.fetchAll()
        let item = try #require(items.first)
        #expect(items.count == 1)
        #expect(item.quantity == 1)
    }

    @Test func addOrIncrementIncrementsExistingItem() throws {
        let painting = Painting(name: "X", price: 50, medium: "Oil", dimensions: "10x10", artist: "Y")
        stack.context?.insert(painting)
        try stack.context?.save()

        try cartRepo.addOrIncrement(painting)
        try cartRepo.addOrIncrement(painting)

        let items = try cartRepo.fetchAll()
        let item = try #require(items.first)
        #expect(items.count == 1)
        #expect(item.quantity == 2)
    }

    @Test func totalPriceIsCorrect() throws {
        let p1 = Painting(name: "A", price: 100, medium: "Oil", dimensions: "10x10", artist: "X")
        let cl = Cloth(name: "B", price: 50, clothingSize: "M", condition: .new)
        stack.context?.insert(p1)
        stack.context?.insert(cl)
        try stack.context?.save()

        try cartRepo.addOrIncrement(p1)
        try cartRepo.addOrIncrement(cl)
        try cartRepo.addOrIncrement(p1) // quantity 2

        let total = try cartRepo.totalPrice()
        #expect(total == 250) // 100*2 + 50*1
    }

    @Test func cartItemProductReturnsNonNilOptional() throws {
        let sculpture = Sculpture(name: "X", price: 50, material: "Bronze", dimensions: "H 10 cm", artist: "Y")
        stack.context?.insert(sculpture)
        try stack.context?.save()

        try cartRepo.addOrIncrement(sculpture)
        let item = try #require(try cartRepo.fetchAll().first)
        #expect(item.product != nil)
        #expect(item.product?.name == "X")
    }
}

// MARK: — ProductStatus

struct ProductStatusTests {
    @Test func effectivePriceReturnsSalePriceWhenOnSale() {
        let p = Painting(
            name: "X", price: 100, salePrice: 75, status: .onSale,
            medium: "Oil", dimensions: "10x10", artist: "Y"
        )
        #expect(p.effectivePrice == 75)
    }

    @Test func effectivePriceReturnsPriceWhenNotOnSale() {
        let p = Painting(name: "X", price: 100, medium: "Oil", dimensions: "10x10", artist: "Y")
        #expect(p.effectivePrice == 100)
    }

    @Test func isOnSaleTrueWhenStatusOnSaleAndSalePriceSet() {
        let p = Painting(
            name: "X", price: 100, salePrice: 75, status: .onSale,
            medium: "Oil", dimensions: "10x10", artist: "Y"
        )
        #expect(p.isOnSale == true)
    }

    @Test func isOnSaleFalseWhenStatusIsNone() {
        let p = Painting(name: "X", price: 100, medium: "Oil", dimensions: "10x10", artist: "Y")
        #expect(p.isOnSale == false)
    }
}
