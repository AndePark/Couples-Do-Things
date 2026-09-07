import SwiftUI

struct MemoriesView: View {
    @EnvironmentObject private var session: SessionStore

    var body: some View {
        NavigationStack {
            Group {
                if session.memories.isEmpty {
                    ContentUnavailableView(
                        "No memories yet",
                        systemImage: "sparkles",
                        description: Text("Completed things will land here.")
                    )
                } else {
                    List(session.memories) { item in
                        ItemRowView(item: item)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button("Delete", role: .destructive) {
                                    Task { await session.delete(item: item) }
                                }
                            }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .background(AppTheme.cream)
            .navigationTitle("Memories")
        }
    }
}
