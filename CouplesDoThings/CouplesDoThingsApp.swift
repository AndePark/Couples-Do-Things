import FirebaseCore
import SwiftUI

@main
struct CouplesDoThingsApp: App {
    @StateObject private var auth = AuthService()
    @StateObject private var session = SessionStore()

    init() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(auth)
                .environmentObject(session)
                .tint(AppTheme.rose)
        }
    }
}
