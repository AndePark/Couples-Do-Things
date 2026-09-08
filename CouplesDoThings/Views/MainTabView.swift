import SwiftUI

struct MainTabView: View {
    @Binding var deepLink: DeepLink?
    @State private var selectedTab = 0
    @State private var highlightedItemID: String?

    var body: some View {
        TabView(selection: $selectedTab) {
            ItemListView(highlightedItemID: $highlightedItemID)
                .tabItem { Label("To-do", systemImage: "heart.fill") }
                .tag(0)

            MemoriesView()
                .tabItem { Label("Memories", systemImage: "sparkles") }
                .tag(1)

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape") }
                .tag(2)
        }
        .onChange(of: deepLink) { link in
            guard let link else { return }
            switch link {
            case .list:
                selectedTab = 0
                highlightedItemID = nil
            case .item(let id):
                selectedTab = 0
                highlightedItemID = id
            }
            deepLink = nil
        }
    }
}
