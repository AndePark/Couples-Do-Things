import FirebaseFirestore
import Foundation

struct ItemService {
    private let db = Firestore.firestore()

    func listenItems(coupleId: String, onChange: @escaping ([CoupleItem]) -> Void) -> ListenerRegistration {
        db.collection("couples").document(coupleId).collection("items")
            .addSnapshotListener { snapshot, _ in
                let items = snapshot?.documents.compactMap { CoupleItem(id: $0.documentID, data: $0.data()) } ?? []
                onChange(items)
            }
    }

    func save(_ item: CoupleItem, coupleId: String) async throws {
        try await db.collection("couples").document(coupleId)
            .collection("items").document(item.id)
            .setData(item.firestoreData)
    }

    func complete(itemId: String, coupleId: String) async throws {
        try await db.collection("couples").document(coupleId)
            .collection("items").document(itemId)
            .updateData(["completedAt": Timestamp(date: .now)])
    }

    func delete(itemId: String, coupleId: String) async throws {
        try await db.collection("couples").document(coupleId)
            .collection("items").document(itemId)
            .delete()
    }
}
