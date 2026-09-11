import FirebaseCore
import SwiftUI

@main
struct CouplesDoThingsApp: App {

    @StateObject private var auth: AuthService
    @StateObject private var session: SessionStore

    init() {
        // Configure Firebase BEFORE creating any objects
        // that access Firebase services.
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }

        _auth = StateObject(
            wrappedValue: AuthService()
        )

        _session = StateObject(
            wrappedValue: SessionStore()
        )
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
