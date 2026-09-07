import AuthenticationServices
import SwiftUI

struct SignInView: View {
    @EnvironmentObject private var auth: AuthService

    var body: some View {
        ZStack {
            AppTheme.cream.ignoresSafeArea()
            VStack(spacing: 24) {
                Spacer()
                Text("Couples Do Things")
                    .font(.largeTitle.bold())
                    .foregroundStyle(AppTheme.ink)
                    .multilineTextAlignment(.center)
                Text("One shared list for dates, movies, trips, and everything in between.")
                    .font(.body)
                    .foregroundStyle(AppTheme.muted)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                Spacer()
                SignInWithAppleButton(.signIn) { request in
                    auth.appleRequestHandler(request)
                } onCompletion: { result in
                    Task { await auth.handleAppleCompletion(result) }
                }
                .signInWithAppleButtonStyle(.black)
                .frame(height: 52)
                .padding(.horizontal, 32)

                if let message = auth.errorMessage {
                    Text(message)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .padding(.horizontal)
                }
                Spacer().frame(height: 32)
            }
        }
    }
}
