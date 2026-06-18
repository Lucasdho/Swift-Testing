import SwiftUI

struct FilterSheet: View {
    @Binding var selectedStatuses: Set<ProductStatus>
    @Environment(\.dismiss) private var dismiss

    @State private var draft: Set<ProductStatus>

    init(selectedStatuses: Binding<Set<ProductStatus>>) {
        self._selectedStatuses = selectedStatuses
        self._draft = State(initialValue: selectedStatuses.wrappedValue)
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Status") {
                    StatusRow(title: "New", status: .new, draft: $draft)
                    StatusRow(title: "On Sale", status: .onSale, draft: $draft)
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Clear") { draft = [] }
                        .disabled(draft.isEmpty)
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    selectedStatuses = draft
                    dismiss()
                } label: {
                    Text("Show Results")
                        .font(.system(size: 17, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(draft.isEmpty ? Color(.secondarySystemBackground) : Color.primary)
                        .foregroundStyle(draft.isEmpty ? Color.secondary : Color(.systemBackground))
                        .clipShape(.rect(cornerRadius: 14))
                }
                .disabled(draft.isEmpty)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
    }
}

private struct StatusRow: View {
    let title: String
    let status: ProductStatus
    @Binding var draft: Set<ProductStatus>

    var body: some View {
        Button {
            if draft.contains(status) { draft.remove(status) } else { draft.insert(status) }
        } label: {
            HStack {
                Text(title).foregroundStyle(.primary)
                Spacer()
                Image(systemName: draft.contains(status) ? "checkmark.square.fill" : "square")
                    .foregroundStyle(draft.contains(status) ? .primary : .secondary)
            }
        }
        .buttonStyle(.plain)
    }
}
