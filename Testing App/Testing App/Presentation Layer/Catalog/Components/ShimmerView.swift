import SwiftUI

struct ShimmerView: View {
    @State private var shimmerBright = false

    var body: some View {
        Color.secondary
            .opacity(shimmerBright ? 0.18 : 0.07)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                    shimmerBright = true
                }
            }
    }
}
