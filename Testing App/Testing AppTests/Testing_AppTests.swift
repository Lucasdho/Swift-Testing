import Testing
import SwiftData
import Foundation
@testable import Testing_App

// MARK: — displayAttributes

struct PaintingDisplayAttributesTests {
    let sut = Painting(name: "Test", price: 100, medium: "Oil", dimensions: "40x50", artist: "A. Artist")

    @Test func returnsCorrectLabels() {
        let attrs = sut.displayAttributes()
        #expect(attrs.map(\.label) == ["Medium", "Dimensions", "Artist"])
    }

    @Test func returnsCorrectValues() {
        let attrs = sut.displayAttributes()
        #expect(attrs[0].value == "Oil")
        #expect(attrs[1].value == "40x50")
        #expect(attrs[2].value == "A. Artist")
    }
}

struct ArtPieceDisplayAttributesTests {
    let sut = ArtPiece(name: "Test", price: 200, artType: "Print", artist: "B. Artist")

    @Test func returnsCorrectLabels() {
        let attrs = sut.displayAttributes()
        #expect(attrs.map(\.label) == ["Type", "Artist"])
    }

    @Test func returnsCorrectValues() {
        let attrs = sut.displayAttributes()
        #expect(attrs[0].value == "Print")
        #expect(attrs[1].value == "B. Artist")
    }
}

struct GarmentDisplayAttributesTests {
    let sut = Garment(name: "Jacket", price: 80, clothingSize: "L", condition: .good, brand: "Brand X")

    @Test func returnsCorrectLabels() {
        let attrs = sut.displayAttributes()
        #expect(attrs.map(\.label) == ["Size", "Condition", "Brand"])
    }

    @Test func noBrandSkipsBrandRow() {
        let garment = Garment(name: "Shirt", price: 40, clothingSize: "M", condition: .new, brand: "")
        let attrs = garment.displayAttributes()
        #expect(attrs.map(\.label) == ["Size", "Condition"])
    }
}

// MARK: — Repository

@MainActor
struct PaintingRepositoryTests {
    let stack: PersistenceStack
    let repo: PaintingRepository

    init() throws {
        stack = try PersistenceStack(
            modelTypes: [Painting.self, ArtPiece.self, Garment.self, CartItem.self, ImageModel.self],
            isMemoryOnly: true
        )
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
        stack = try PersistenceStack(
            modelTypes: [Painting.self, ArtPiece.self, Garment.self, CartItem.self, ImageModel.self],
            isMemoryOnly: true
        )
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
        let g1 = Garment(name: "B", price: 50, clothingSize: "M", condition: .new)
        stack.context?.insert(p1)
        stack.context?.insert(g1)
        try stack.context?.save()

        try cartRepo.addOrIncrement(p1)
        try cartRepo.addOrIncrement(g1)
        try cartRepo.addOrIncrement(p1) // quantity 2

        let total = try cartRepo.totalPrice()
        #expect(total == 250) // 100*2 + 50*1
    }

    @Test func cartItemProductReturnsNonNilOptional() throws {
        let painting = Painting(name: "X", price: 50, medium: "Oil", dimensions: "10x10", artist: "Y")
        stack.context?.insert(painting)
        try stack.context?.save()

        try cartRepo.addOrIncrement(painting)
        let item = try #require(try cartRepo.fetchAll().first)
        #expect(item.product != nil)
        #expect(item.product?.name == "X")
    }
}
