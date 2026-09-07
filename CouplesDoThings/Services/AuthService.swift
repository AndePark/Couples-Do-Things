import FirebaseAuth
import Foundation

@MainActor
final class AuthService: ObservableObject {
    @Published private(set) var user: User?
    @Published var suggestedDisplayName = "Partner"
    @Published var errorMessage: String?

    private var listener: AuthStateDidChangeListenerHandle?

    init() {
        user = Auth.auth().currentUser
        if let name = user?.displayName, !name.isEmpty {
            suggestedDisplayName = name
        }
        listener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                self?.user = user
                if let name = user?.displayName, !name.isEmpty {
                    self?.suggestedDisplayName = name
                }
            }
        }
    }

    deinit {
        if let listener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }

    func createAccount(email: String, password: String, displayName: String) async {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let name = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
            if !name.isEmpty {
                let request = result.user.createProfileChangeRequest()
                request.displayName = name
                try await request.commitChanges()
                suggestedDisplayName = name
            }
            user = Auth.auth().currentUser
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signIn(email: String, password: String) async {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            user = result.user
            if let name = result.user.displayName, !name.isEmpty {
                suggestedDisplayName = name
            }
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }
}
