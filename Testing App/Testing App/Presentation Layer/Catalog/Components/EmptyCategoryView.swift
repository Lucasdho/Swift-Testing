import SwiftUI

struct EmptyCategoryView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray")
                .font(.system(size: 40))
                .foregroundStyle(.tertiary)
            Text("Nothing in this category")
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 64)
    }
}

#Preview {
    EmptyCategoryView()
}
