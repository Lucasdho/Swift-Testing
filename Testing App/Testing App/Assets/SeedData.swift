import SwiftData
import Foundation

enum SeedData {
    static func insert(into context: ModelContext) {
        context.insert(Painting(
            id: "painting-001",
            name: "Blue Horizon",
            price: 350,
            status: .new,
            imageURLs: ["https://picsum.photos/seed/painting1/400/400"],
            productDescription: "Acrylic on canvas, 2024.",
            medium: "Acrylic",
            dimensions: "60 × 80 cm",
            artist: "Maria Santos"
        ))
        context.insert(Painting(
            id: "painting-002",
            name: "Golden Field",
            price: 480,
            imageURLs: ["https://picsum.photos/seed/painting2/400/400"],
            productDescription: "Oil on linen, warm palette.",
            medium: "Oil",
            dimensions: "50 × 70 cm",
            artist: "João Alves"
        ))
        context.insert(Sculpture(
            id: "sculpture-001",
            name: "Twisted Form",
            price: 1200,
            salePrice: 960,
            status: .onSale,
            imageURLs: ["https://picsum.photos/seed/sculpture1/400/400"],
            productDescription: "Abstract bronze casting, limited edition.",
            material: "Bronze",
            dimensions: "H 40 cm",
            artist: "Ana Lima"
        ))
        context.insert(Sculpture(
            id: "sculpture-002",
            name: "Marble Study",
            price: 900,
            imageURLs: ["https://picsum.photos/seed/sculpture2/400/400"],
            productDescription: "Carved Carrara marble, 2023.",
            material: "Marble",
            dimensions: "H 28 cm",
            artist: "Carlos Melo"
        ))
        context.insert(Ceramic(
            id: "ceramic-001",
            name: "Celadon Bowl",
            price: 180,
            imageURLs: ["https://picsum.photos/seed/ceramic1/400/400"],
            productDescription: "Hand-thrown stoneware with celadon glaze.",
            technique: "Wheel-thrown",
            glaze: "Celadon",
            artist: "João Alves"
        ))
        context.insert(Ceramic(
            id: "ceramic-002",
            name: "Raku Vessel",
            price: 240,
            imageURLs: ["https://picsum.photos/seed/ceramic2/400/400"],
            productDescription: "Raku-fired with crackle finish.",
            technique: "Raku",
            glaze: "Crackle",
            artist: "Maria Santos"
        ))
        context.insert(Jewelry(
            id: "jewelry-001",
            name: "Silver Crescent",
            price: 320,
            status: .new,
            imageURLs: ["https://picsum.photos/seed/jewelry1/400/400"],
            productDescription: "Oxidised sterling silver, handmade.",
            material: "Sterling Silver",
            jewelryType: "Necklace",
            artist: "Ana Lima"
        ))
        context.insert(Jewelry(
            id: "jewelry-002",
            name: "Resin Ring Set",
            price: 95,
            imageURLs: ["https://picsum.photos/seed/jewelry2/400/400"],
            productDescription: "Set of three botanical resin rings.",
            material: "Resin",
            jewelryType: "Ring",
            artist: "Beatriz Costa"
        ))
        context.insert(Cloth(
            id: "cloth-001",
            name: "Vintage Denim Jacket",
            price: 120,
            salePrice: 96,
            status: .onSale,
            imageURLs: ["https://picsum.photos/seed/cloth1/400/400"],
            productDescription: "90s wash, minor wear on cuffs.",
            clothingSize: "M",
            condition: .good,
            brand: "Levi's"
        ))
        context.insert(Cloth(
            id: "cloth-002",
            name: "Linen Shirt",
            price: 65,
            imageURLs: ["https://picsum.photos/seed/cloth2/400/400"],
            productDescription: "Worn once, washed cold.",
            clothingSize: "S",
            condition: .new,
            brand: ""
        ))

        try? context.save()
    }
}
