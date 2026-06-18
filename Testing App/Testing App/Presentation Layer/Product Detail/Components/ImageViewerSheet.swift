import SwiftUI

struct ImageViewerSheet: View {
    let images: [Data]
    @Environment(\.dismiss) private var dismiss
    @State private var currentPage = 0

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()

            TabView(selection: $currentPage) {
                ForEach(images.indices, id: \.self) { index in
                    if let uiImage = UIImage(data: images[index]) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .tag(index)
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: images.count > 1 ? .always : .never))

            Button { dismiss() } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 28))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color.white, Color.black.opacity(0.5))
                    .padding(16)
            }
        }
    }
}
