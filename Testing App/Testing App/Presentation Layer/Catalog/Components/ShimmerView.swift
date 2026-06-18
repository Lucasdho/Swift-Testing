import SwiftUI

struct ShimmerView: View {
    @State private var isAnimating = false

    var body: some View {
        GeometryReader { geo in
            Color(.secondarySystemBackground)
                .overlay {
                    LinearGradient(
                        stops: [
                            .init(color: .clear, location: 0),
                            .init(color: Color(.systemBackground).opacity(0.3), location: 0.5),
                            .init(color: .clear, location: 1),
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geo.size.width * 2)
                    .offset(x: isAnimating ? geo.size.width : -geo.size.width * 2)
                }
                .clipped()
        }
        .onAppear {
            withAnimation(.linear(duration: 1.3).repeatForever(autoreverses: false)) {
                isAnimating = true
            }
        }
    }
}
