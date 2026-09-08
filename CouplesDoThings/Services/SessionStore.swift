import FirebaseAuth
import FirebaseFirestore
import Foundation
import WidgetKit

@MainActor
final class SessionStore: ObservableObject {
    @Published var profile: UserProfile?
    @Published var couple: Couple?
    @Published var items: [CoupleItem] = []
    @Published var partnerName: String?
    @Published var isLoading = true
    @Published var errorMessage: String?

    private let coupleService = CoupleService()
    private let itemService = ItemService()
    private var profileListener: ListenerRegistration?
    private var coupleListener: ListenerRegistration?
    private var itemsListener: ListenerRegistration?

    var uid: String? { Auth.auth().currentUser?.uid }

    var isSharingPhoto: Bool {
        guard let uid, let couple else { return false }
        return couple.sharedPhotoParticipantIds.contains(uid)
    }

    var activeItems: [CoupleItem] {
        items.filter { !$0.isCompleted }
    }

    var upcomingItems: [CoupleItem] {
        let startOfToday = Calendar.current.startOfDay(for: Date())
        return activeItems
            .filter { item in
                guard let date = item.dateStart else { return false }
                return date >= startOfToday || (item.dateEnd ?? date) >= startOfToday
            }
            .sorted { ($0.dateStart ?? .distantFuture) < ($1.dateStart ?? .distantFuture) }
    }

    var otherActiveItems: [CoupleItem] {
        let upcomingIDs = Set(upcomingItems.map(\.id))
        return activeItems
            .filter { !upcomingIDs.contains($0.id) }
            .sorted { $0.createdAt > $1.createdAt }
    }

    var memories: [CoupleItem] {
        items.filter(\.isCompleted).sorted { ($0.completedAt ?? .distantPast) > ($1.completedAt ?? .distantPast) }
    }

    func start(uid: String, displayName: String) {
        profileListener?.remove()
        coupleListener?.remove()
        itemsListener?.remove()
        isLoading = true
        Task {
            do {
                _ = try await coupleService.ensureProfile(uid: uid, displayName: displayName)
            } catch {
                errorMessage = error.localizedDescription
            }
            listen(uid: uid)
        }
    }

    func stop() {
        profileListener?.remove()
        coupleListener?.remove()
        itemsListener?.remove()
        profileListener = nil
        coupleListener = nil
        itemsListener = nil
        profile = nil
        couple = nil
        items = []
        partnerName = nil
        isLoading = false
        refreshWidget()
    }

    func createCouple() async {
        guard let uid else { return }
        do {
            _ = try await coupleService.createCouple(uid: uid)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func joinCouple(code: String) async {
        guard let uid else { return }
        do {
            try await coupleService.joinCouple(uid: uid, code: code)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func leaveCouple() async {
        guard let uid, let couple else { return }
        do {
            try await coupleService.leaveCouple(uid: uid, couple: couple)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func save(item: CoupleItem) async {
        guard let couple else { return }
        do {
            try await itemService.save(item, coupleId: couple.id)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func complete(item: CoupleItem) async {
        guard let couple else { return }
        do {
            try await itemService.complete(itemId: item.id, coupleId: couple.id)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func delete(item: CoupleItem) async {
        guard let couple else { return }
        do {
            try await itemService.delete(itemId: item.id, coupleId: couple.id)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func refreshWidgetPhoto() {
        refreshWidget()
    }

    func setPhotoSharing(enabled: Bool) async {
        guard let uid, let couple else { return }
        let personalData = WidgetDataStore.loadPersonalBackgroundImageData()
        do {
            try await coupleService.setPhotoSharing(
                uid: uid,
                coupleId: couple.id,
                enabled: enabled,
                photoData: enabled ? personalData : nil
            )
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func listen(uid: String) {
        profileListener?.remove()
        profileListener = coupleService.listenProfile(uid: uid) { [weak self] profile in
            Task { @MainActor in
                guard let self else { return }
                self.profile = profile
                self.isLoading = false
                self.listenToCouple(profile?.coupleId)
            }
        }
    }

    private func listenToCouple(_ coupleId: String?) {
        coupleListener?.remove()
        itemsListener?.remove()
        coupleListener = nil
        itemsListener = nil

        guard let coupleId else {
            couple = nil
            items = []
            partnerName = nil
            refreshWidget()
            return
        }

        coupleListener = coupleService.listenCouple(id: coupleId) { [weak self] couple in
            Task { @MainActor in
                guard let self else { return }
                self.couple = couple
                if let couple, let uid = self.uid {
                    self.partnerName = await self.coupleService.partnerName(couple: couple, excluding: uid)
                } else {
                    self.partnerName = nil
                }
                self.syncEffectiveWidgetPhoto()
            }
        }

        itemsListener = itemService.listenItems(coupleId: coupleId) { [weak self] items in
            Task { @MainActor in
                self?.items = items
                self?.refreshWidget()
            }
        }
    }

    private func syncEffectiveWidgetPhoto() {
        guard let couple else { return }
        if couple.isPhotoSharedByBoth,
           let base64 = couple.sharedPhotoData,
           let data = Data(base64Encoded: base64) {
            WidgetDataStore.saveBackgroundImageData(data)
        } else {
            WidgetDataStore.saveBackgroundImageData(WidgetDataStore.loadPersonalBackgroundImageData())
        }
        refreshWidget()
    }

    private func refreshWidget() {
        let snapshot = WidgetSnapshot(
            coupleName: partnerName.map { "You & \($0)" } ?? "Couples Do Things",
            items: items.map { $0.snapshot() },
            updatedAt: .now
        )
        WidgetDataStore.saveSnapshot(snapshot)
        WidgetCenter.shared.reloadAllTimelines()
    }
}
