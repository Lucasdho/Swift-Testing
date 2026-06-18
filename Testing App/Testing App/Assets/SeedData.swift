import SwiftData
import Foundation

enum SeedData {
    static func insert(into context: ModelContext) {
        context.insert(Painting(
            id: "painting-001",
            name: "Blue Horizon",
            price: 350,
            status: .new,
            imageURLs: ["https://images.unsplash.com/photo-1641002487920-0c3d5ca4573e?q=80&w=2178&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"],
            productDescription: "Acrylic on canvas, 2024.",
            medium: "Acrylic",
            dimensions: "60 × 80 cm",
            artist: "Maria Santos"
        ))
        context.insert(Painting(
            id: "painting-002",
            name: "Golden Field",
            price: 480,
            imageURLs: ["https://images.unsplash.com/photo-1774015583867-6834d9553faf?q=80&w=2270&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"],
            productDescription: "Oil on linen, warm palette.",
            medium: "Oil",
            dimensions: "50 × 70 cm",
            artist: "João Alves"
        ))
        context.insert(Painting(
            id: "painting-003",
            name: "Open Sea",
            price: 520,
            imageURLs: ["https://images.unsplash.com/photo-1695844918823-8ec54d7d839c?q=80&w=2252&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"],
            productDescription: "Oil on canvas seascape, rolling waves under open sky.",
            medium: "Oil",
            dimensions: "70 × 50 cm",
            artist: "Carlos Melo"
        ))
        context.insert(Painting(
            id: "painting-004",
            name: "Watercolor Set",
            price: 200,
            salePrice: 180,
            status: .new,
            imageURLs: [
                "https://images.unsplash.com/photo-1510832842230-87253f48d74f?q=80&w=1287&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                "https://images.unsplash.com/photo-1510832758362-af875829efcf?q=80&w=2370&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                "https://images.unsplash.com/photo-1510832900031-d36b87d3847c?q=80&w=1287&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                "https://images.unsplash.com/photo-1510832955159-2e2fdffbf291?q=80&w=1287&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
            ],
            productDescription: "Cotton 300g paper + pentel coolors + derwent brushes(3-12) + white godet",
            medium: "Watercolor",
            dimensions: "60 × 60 cm",
            artist: "Studio Santos"
        ))
        context.insert(Sculpture(
            id: "sculpture-001",
            name: "Twisted Form",
            price: 1200,
            salePrice: 960,
            status: .onSale,
            imageURLs: ["https://images.unsplash.com/photo-1770492727730-05cb5ff3e90a?q=80&w=1335&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"],
            productDescription: "Abstract bronze casting, limited edition.",
            material: "Bronze",
            dimensions: "H 40 cm",
            artist: "Ana Lima"
        ))
        context.insert(Sculpture(
            id: "sculpture-002",
            name: "Marble Study",
            price: 900,
            imageURLs: ["https://images.unsplash.com/photo-1655151410079-716df91ed28a?q=80&w=1400&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"],
            productDescription: "Carved Carrara marble, 2023.",
            material: "Marble",
            dimensions: "H 28 cm",
            artist: "Carlos Melo"
        ))
        context.insert(Ceramic(
            id: "ceramic-001",
            name: "Celadon Bowl",
            price: 180,
            imageURLs: ["https://images.unsplash.com/photo-1778215251269-dbf83abca50b?q=80&w=2369&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"],
            productDescription: "Hand-thrown stoneware with celadon glaze.",
            technique: "Wheel-thrown",
            glaze: "Celadon",
            artist: "João Alves"
        ))
        context.insert(Ceramic(
            id: "ceramic-002",
            name: "Raku Vessel",
            price: 240,
            imageURLs: ["https://images.unsplash.com/photo-1693888260918-dd433401e304?q=80&w=1287&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"],
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
            imageURLs: ["https://images.unsplash.com/photo-1713004539634-a6694a83f3d9?q=80&w=1842&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"],
            productDescription: "Oxidised sterling silver, handmade.",
            material: "Sterling Silver",
            jewelryType: "Necklace",
            artist: "Ana Lima"
        ))
        context.insert(Jewelry(
            id: "jewelry-002",
            name: "Resin Ring Set",
            price: 95,
            imageURLs: ["https://images.unsplash.com/photo-1577743871846-50d76f5e3387?q=80&w=1335&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"],
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
            imageURLs: ["https://images.unsplash.com/photo-1778865576241-6739d4a6aa95?q=80&w=918&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"],
            productDescription: "90s wash, minor wear on cuffs.",
            clothingSize: "M",
            condition: .good,
            brand: "Levi's"
        ))
        context.insert(Cloth(
            id: "cloth-002",
            name: "Linen Shirt",
            price: 65,
            imageURLs: ["https://images.unsplash.com/photo-1772583435283-b07bc9950497?q=80&w=1287&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"],
            productDescription: "Worn once, washed cold.",
            clothingSize: "S",
            condition: .new,
            brand: ""
        ))

        try? context.save()
    }
}
