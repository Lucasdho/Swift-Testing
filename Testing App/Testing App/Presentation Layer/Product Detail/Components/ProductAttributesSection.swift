import SwiftUI

struct ProductAttributesSection: View {
    let attributes: [(label: String, value: String)]

    var body: some View {
        if !attributes.isEmpty {
            VStack(spacing: 0) {
                ForEach(Array(attributes.enumerated()), id: \.offset) { index, attr in
                    HStack {
                        Text(attr.label)
                            .font(.system(size: 15, weight: .regular))
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(attr.value)
                            .font(.system(size: 15, weight: .regular))
                            .foregroundStyle(.primary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)

                    if index < attributes.count - 1 {
                        Divider().padding(.leading, 16)
                    }
                }
            }
            .background(Color(.secondarySystemBackground))
            .clipShape(.rect(cornerRadius: 10))
        }
    }
}

#Preview {
    ProductAttributesSection(attributes: [
        (label: "Condition", value: "New"),
        (label: "Material", value: "Oil on canvas"),
        (label: "Year", value: "2024")
    ])
    .padding()
}
