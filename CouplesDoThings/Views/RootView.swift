import SwiftUI

struct RootView: View {
    @EnvironmentObject private var auth: AuthService
    @EnvironmentObject private var session: SessionStore
    @State private var deepLink: DeepLink?

    var body: some View {
        Group {
            if auth.user == nil {
                SignInView()
            } else if session.isLoading {
                ProgressView("Loading your list…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(AppTheme.cream)
            } else if session.couple == nil {
                CreateJoinView()
            } else {
                MainTabView(deepLink: $deepLink)
            }
        }
        .onAppear {
            if let user = auth.user {
                session.start(uid: user.uid, displayName: auth.suggestedDisplayName)
            }
        }
        .onChange(of: auth.user?.uid) { uid in
            if let user = auth.user, let uid {
                session.start(uid: uid, displayName: auth.suggestedDisplayName)
            } else {
                session.stop()
            }
        }
        .onOpenURL { url in
            deepLink = DeepLink(url: url)
        }
    }
}
