import SwiftUI

struct CreateJoinView: View {
    @EnvironmentObject private var session: SessionStore
    @State private var joinCode = ""
    @State private var isWorking = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text("Create a couple space and share the invite code, or join with your partner’s code.")
                        .foregroundStyle(AppTheme.muted)
                }

                Section("Create") {
                    Button("Create couple space") {
                        Task {
                            isWorking = true
                            await session.createCouple()
                            isWorking = false
                        }
                    }
                    .disabled(isWorking)
                }

                Section("Join") {
                    TextField("Invite code", text: $joinCode)
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()
                    Button("Join with code") {
                        Task {
                            isWorking = true
                            await session.joinCouple(code: joinCode)
                            isWorking = false
                        }
                    }
                    .disabled(joinCode.trimmingCharacters(in: .whitespacesAndNewlines).count < 6 || isWorking)
                }

                if let message = session.errorMessage {
                    Section {
                        Text(message).foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Your couple")
            .scrollContentBackground(.hidden)
            .background(AppTheme.cream)
        }
    }
}
