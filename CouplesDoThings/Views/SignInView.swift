import SwiftUI

struct SignInView: View {
    @EnvironmentObject private var auth: AuthService
    @State private var isCreatingAccount = true
    @State private var displayName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isWorking = false

    var body: some View {
        ZStack {
            AppTheme.cream.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    Spacer().frame(height: 48)
                    Text("Couples Do Things")
                        .font(.largeTitle.bold())
                        .foregroundStyle(AppTheme.ink)
                        .multilineTextAlignment(.center)
                    Text("One shared list for the two of you. No App Store account required.")
                        .font(.body)
                        .foregroundStyle(AppTheme.muted)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)

                    Picker("Mode", selection: $isCreatingAccount) {
                        Text("Create account").tag(true)
                        Text("Sign in").tag(false)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 32)

                    VStack(spacing: 12) {
                        if isCreatingAccount {
                            TextField("Your name", text: $displayName)
                                .textContentType(.name)
                                .padding()
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        TextField("Email", text: $email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .padding()
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        SecureField("Password (6+ characters)", text: $password)
                            .textContentType(isCreatingAccount ? .newPassword : .password)
                            .padding()
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal, 32)

                    Button {
                        Task { await submit() }
                    } label: {
                        Text(isCreatingAccount ? "Create account" : "Sign in")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppTheme.rose)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(!canSubmit || isWorking)
                    .padding(.horizontal, 32)

                    if let message = auth.errorMessage {
                        Text(message)
                            .font(.footnote)
                            .foregroundStyle(.red)
                            .padding(.horizontal)
                    }

                    Text("You and your partner each make your own account, then one of you creates a couple space and shares the invite code.")
                        .font(.footnote)
                        .foregroundStyle(AppTheme.muted)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)

                    Spacer().frame(height: 32)
                }
            }
        }
    }

    private var canSubmit: Bool {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let hasPassword = password.count >= 6
        if isCreatingAccount {
            return !displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                && trimmedEmail.contains("@")
                && hasPassword
        }
        return trimmedEmail.contains("@") && hasPassword
    }

    private func submit() async {
        isWorking = true
        auth.suggestedDisplayName = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        if isCreatingAccount {
            await auth.createAccount(email: email.trimmingCharacters(in: .whitespacesAndNewlines), password: password, displayName: displayName)
        } else {
            await auth.signIn(email: email.trimmingCharacters(in: .whitespacesAndNewlines), password: password)
        }
        isWorking = false
    }
}
