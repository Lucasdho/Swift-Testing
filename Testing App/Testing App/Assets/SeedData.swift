import SwiftData
import Foundation

enum SeedData {
    static func insert(into context: ModelContext) {
        context.insert(Painting(
            name: "Blue Horizon",
            price: 350,
            imageURLs: ["https://picsum.photos/seed/painting1/400/400"],
            productDescription: "Acrylic on canvas, 2024.",
            medium: "Acrylic",
            dimensions: "60 × 80 cm",
            artist: "Maria Santos"
        ))
        context.insert(Painting(
            name: "Ceramic Bowl No. 3",
            price: 180,
            imageURLs: ["https://picsum.photos/seed/ceramic1/400/400"],
            productDescription: "Hand-thrown stoneware with celadon glaze.",
            medium: "Ceramic",
            dimensions: "Ø 22 cm",
            artist: "João Alves"
        ))
        context.insert(ArtPiece(
            name: "Fragments",
            price: 520,
            imageURLs: ["https://picsum.photos/seed/art1/400/400"],
            productDescription: "Mixed media collage on board.",
            artType: "Mixed Media",
            artist: "Ana Lima"
        ))
        context.insert(ArtPiece(
            name: "Study in Red",
            price: 290,
            imageURLs: ["https://picsum.photos/seed/art2/400/400"],
            productDescription: "Giclée print, edition 3/10.",
            artType: "Print",
            artist: "Carlos Melo"
        ))
        context.insert(Garment(
            name: "Vintage Denim Jacket",
            price: 120,
            imageURLs: ["https://picsum.photos/seed/garment1/400/400"],
            productDescription: "90s wash, minor wear on cuffs.",
            clothingSize: "M",
            condition: .good,
            brand: "Levi's"
        ))
        context.insert(Garment(
            name: "Linen Shirt",
            price: 65,
            imageURLs: ["https://picsum.photos/seed/garment2/400/400"],
            productDescription: "Worn once, washed cold.",
            clothingSize: "S",
            condition: .new,
            brand: ""
        ))

        try? context.save()
    }
}
