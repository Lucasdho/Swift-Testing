import SwiftUI

struct ProductHeroImage: View {
    let imageData: Data?

    var body: some View {
        ZStack {
            Color(.secondarySystemBackground)
            if let data = imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "photo")
                    .font(.system(size: 48))
                    .foregroundStyle(.tertiary)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 280)
        .clipped()
    }
}

#Preview {
    ProductHeroImage(imageData: nil)
}
