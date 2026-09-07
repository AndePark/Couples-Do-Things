import AuthenticationServices
import CryptoKit
import FirebaseAuth
import Foundation

enum AuthError: LocalizedError {
    case missingAppleCredential
    case firebase(String)

    var errorDescription: String? {
        switch self {
        case .missingAppleCredential:
            return "Apple did not return a sign-in credential."
        case .firebase(let message):
            return message
        }
    }
}

@MainActor
final class AuthService: NSObject, ObservableObject {
    @Published private(set) var user: User?
    @Published var suggestedDisplayName = "Partner"
    @Published var errorMessage: String?

    private var listener: AuthStateDidChangeListenerHandle?
    private var currentNonce: String?

    override init() {
        super.init()
        user = Auth.auth().currentUser
        listener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                self?.user = user
            }
        }
    }

    deinit {
        if let listener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }

    var appleRequestHandler: (ASAuthorizationAppleIDRequest) -> Void {
        { [weak self] request in
            let nonce = Self.randomNonce()
            self?.currentNonce = nonce
            request.requestedScopes = [.fullName]
            request.nonce = Self.sha256(nonce)
        }
    }

    func handleAppleCompletion(_ result: Result<ASAuthorization, Error>) async {
        switch result {
        case .failure(let error):
            if (error as NSError).code != ASAuthorizationError.canceled.rawValue {
                errorMessage = error.localizedDescription
            }
        case .success(let authorization):
            do {
                try await signIn(with: authorization)
                errorMessage = nil
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }

    private func signIn(with authorization: ASAuthorization) async throws {
        guard
            let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let tokenData = credential.identityToken,
            let idToken = String(data: tokenData, encoding: .utf8),
            let nonce = currentNonce
        else {
            throw AuthError.missingAppleCredential
        }

        let firebaseCredential = OAuthProvider.appleCredential(
            withIDToken: idToken,
            rawNonce: nonce,
            fullName: credential.fullName
        )
        let result = try await Auth.auth().signIn(with: firebaseCredential)
        user = result.user
        if let fullName = credential.fullName {
            let name = PersonNameComponentsFormatter().string(from: fullName).trimmingCharacters(in: .whitespacesAndNewlines)
            if !name.isEmpty {
                suggestedDisplayName = name
            }
        }
    }

    private static func randomNonce(length: Int = 32) -> String {
        let charset = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remaining = length
        while remaining > 0 {
            var random: UInt8 = 0
            let status = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if status != errSecSuccess {
                random = UInt8.random(in: 0...255)
            }
            if random < charset.count {
                result.append(charset[Int(random)])
                remaining -= 1
            }
        }
        return result
    }

    private static func sha256(_ input: String) -> String {
        let data = Data(input.utf8)
        let hashed = SHA256.hash(data: data)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}
