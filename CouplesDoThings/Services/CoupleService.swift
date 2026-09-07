import FirebaseFirestore
import Foundation

enum CoupleServiceError: LocalizedError {
    case invalidCode
    case alreadyInCouple
    case missingProfile

    var errorDescription: String? {
        switch self {
        case .invalidCode:
            return "That invite code was not found."
        case .alreadyInCouple:
            return "You are already in a couple space."
        case .missingProfile:
            return "Your profile is not ready yet."
        }
    }
}

struct CoupleService {
    private let db = Firestore.firestore()

    func ensureProfile(uid: String, displayName: String) async throws -> UserProfile {
        let ref = db.collection("users").document(uid)
        let snapshot = try await ref.getDocument()
        if snapshot.exists, let profile = UserProfile(id: uid, data: snapshot.data() ?? [:]) {
            return profile
        }
        let profile = UserProfile(id: uid, displayName: displayName)
        try await ref.setData([
            "displayName": profile.displayName,
            "createdAt": Timestamp(date: profile.createdAt)
        ])
        return profile
    }

    func listenProfile(uid: String, onChange: @escaping (UserProfile?) -> Void) -> ListenerRegistration {
        db.collection("users").document(uid).addSnapshotListener { snapshot, _ in
            guard let snapshot, snapshot.exists, let data = snapshot.data() else {
                onChange(nil)
                return
            }
            onChange(UserProfile(id: uid, data: data))
        }
    }

    func listenCouple(id: String, onChange: @escaping (Couple?) -> Void) -> ListenerRegistration {
        db.collection("couples").document(id).addSnapshotListener { snapshot, _ in
            guard let snapshot, snapshot.exists, let data = snapshot.data() else {
                onChange(nil)
                return
            }
            onChange(Couple(id: id, data: data))
        }
    }

    func createCouple(uid: String) async throws -> Couple {
        let profile = try await ensureProfile(uid: uid, displayName: "Partner")
        if profile.coupleId != nil {
            throw CoupleServiceError.alreadyInCouple
        }

        let inviteCode = try await uniqueInviteCode()
        let coupleRef = db.collection("couples").document()
        let couple = Couple(id: coupleRef.documentID, inviteCode: inviteCode, memberIds: [uid])

        let batch = db.batch()
        batch.setData(couple.firestoreData, forDocument: coupleRef)
        batch.setData(
            [
                "coupleId": couple.id,
                "createdBy": uid
            ],
            forDocument: db.collection("inviteCodes").document(inviteCode)
        )
        batch.setData(
            ["coupleId": couple.id],
            forDocument: db.collection("users").document(uid),
            merge: true
        )
        try await batch.commit()
        return couple
    }

    func joinCouple(uid: String, code: String) async throws {
        let normalized = code.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        guard normalized.count == 6 else { throw CoupleServiceError.invalidCode }

        let profile = try await ensureProfile(uid: uid, displayName: "Partner")
        if profile.coupleId != nil {
            throw CoupleServiceError.alreadyInCouple
        }

        let inviteSnap = try await db.collection("inviteCodes").document(normalized).getDocument()
        guard let coupleId = inviteSnap.data()?["coupleId"] as? String else {
            throw CoupleServiceError.invalidCode
        }

        let coupleRef = db.collection("couples").document(coupleId)
        let coupleDoc = try await coupleRef.getDocument()
        guard coupleDoc.exists else { throw CoupleServiceError.invalidCode }

        try await coupleRef.updateData(["memberIds": FieldValue.arrayUnion([uid])])
        try await db.collection("users").document(uid).setData(["coupleId": coupleId], merge: true)
    }

    func leaveCouple(uid: String, couple: Couple) async throws {
        let coupleRef = db.collection("couples").document(couple.id)
        let remaining = couple.memberIds.filter { $0 != uid }
        let batch = db.batch()
        batch.updateData(["coupleId": FieldValue.delete()], forDocument: db.collection("users").document(uid))

        if remaining.isEmpty {
            batch.deleteDocument(coupleRef)
            batch.deleteDocument(db.collection("inviteCodes").document(couple.inviteCode))
        } else {
            batch.updateData(["memberIds": remaining], forDocument: coupleRef)
        }
        try await batch.commit()
    }

    func partnerName(couple: Couple, excluding uid: String) async -> String? {
        let otherId = couple.memberIds.first { $0 != uid }
        guard let otherId else { return nil }
        let snap = try? await db.collection("users").document(otherId).getDocument()
        return snap?.data()?["displayName"] as? String
    }

    private func uniqueInviteCode() async throws -> String {
        for _ in 0..<12 {
            let code = Self.makeCode()
            let snap = try await db.collection("inviteCodes").document(code).getDocument()
            if !snap.exists { return code }
        }
        throw CoupleServiceError.invalidCode
    }

    private static func makeCode() -> String {
        let chars = Array("ABCDEFGHJKLMNPQRSTUVWXYZ23456789")
        return String((0..<6).map { _ in chars.randomElement()! })
    }
}
