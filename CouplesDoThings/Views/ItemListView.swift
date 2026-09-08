import SwiftUI

struct ItemListView: View {
    @EnvironmentObject private var session: SessionStore
    @Binding var highlightedItemID: String?
    @State private var editorItem: CoupleItem?
    @State private var isAdding = false

    var body: some View {
        NavigationStack {
            Group {
                if session.activeItems.isEmpty {
                    AppEmptyState(
                        title: "Nothing on the list yet",
                        systemImage: "heart",
                        message: "Add a movie night, a dinner, or a weekend trip."
                    )
                } else {
                    List {
                        if !session.upcomingItems.isEmpty {
                            Section("Upcoming") {
                                ForEach(session.upcomingItems) { item in
                                    itemRow(item)
                                }
                            }
                        }
                        if !session.otherActiveItems.isEmpty {
                            Section("Recently added") {
                                ForEach(session.otherActiveItems) { item in
                                    itemRow(item)
                                }
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .background(AppTheme.cream)
            .navigationTitle("To-do together")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isAdding = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAdding) {
                ItemEditorView(item: nil)
            }
            .sheet(item: $editorItem) { item in
                ItemEditorView(item: item)
            }
            .onChange(of: highlightedItemID) { id in
                if let id, let match = session.items.first(where: { $0.id == id && !$0.isCompleted }) {
                    editorItem = match
                    highlightedItemID = nil
                }
            }
        }
    }

    @ViewBuilder
    private func itemRow(_ item: CoupleItem) -> some View {
        ItemRowView(item: item)
            .contentShape(Rectangle())
            .onTapGesture { editorItem = item }
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button("Done") {
                    Task { await session.complete(item: item) }
                }
                .tint(.green)
                Button("Delete", role: .destructive) {
                    Task { await session.delete(item: item) }
                }
            }
            .contextMenu {
                Button("Edit") { editorItem = item }
                if let address = item.address, !address.isEmpty {
                    Button("Open in Google Maps") { GoogleMaps.open(address: address) }
                }
                Button("Mark done") { Task { await session.complete(item: item) } }
                Button("Delete", role: .destructive) { Task { await session.delete(item: item) } }
            }
    }
}

struct ItemRowView: View {
    let item: CoupleItem

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(item.title)
                .font(.headline)
                .foregroundStyle(AppTheme.ink)
            HStack(spacing: 8) {
                if let label = item.snapshot().dateLabel {
                    Label(label, systemImage: "calendar")
                }
                if let price = item.priceText, !price.isEmpty {
                    Label(price, systemImage: "tag")
                }
            }
            .font(.caption)
            .foregroundStyle(AppTheme.muted)
            if let address = item.address, !address.isEmpty {
                Label(address, systemImage: "mappin.and.ellipse")
                    .font(.caption)
                    .foregroundStyle(Color.accentColor)
                    .highPriorityGesture(
                        TapGesture().onEnded {
                            GoogleMaps.open(address: address)
                        }
                    )
            }
        }
        .padding(.vertical, 4)
    }
}
