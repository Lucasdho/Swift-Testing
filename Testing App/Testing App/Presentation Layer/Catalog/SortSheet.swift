import SwiftUI

struct SortSheet: View {
    @Binding var selected: SortOption
    @Environment(\.dismiss) private var dismiss

    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(spacing: 24) {
            Text("Sort by")
                .font(.system(size: 17, weight: .semibold))
                .padding(.top, 20)

            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(SortOption.allCases, id: \.rawValue) { option in
                    Button {
                        selected = option
                        dismiss()
                    } label: {
                        VStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(selected == option ? Color.primary : Color(.secondarySystemBackground))
                                    .frame(width: 64, height: 64)
                                Image(systemName: option.icon)
                                    .font(.system(size: 22))
                                    .foregroundStyle(
                                        selected == option ? Color(.systemBackground) : Color.primary
                                    )
                            }
                            Text(option.rawValue)
                                .font(.system(size: 12))
                                .foregroundStyle(selected == option ? .primary : .secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 24)

            Spacer()
        }
    }
}
