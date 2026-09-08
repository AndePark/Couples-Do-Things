import Foundation
import FirebaseFirestore

struct UserProfile: Identifiable, Equatable {
    var id: String
    var displayName: String
    var coupleId: String?
    var createdAt: Date

    init(id: String, displayName: String, coupleId: String? = nil, createdAt: Date = .now) {
        self.id = id
        self.displayName = displayName
        self.coupleId = coupleId
        self.createdAt = createdAt
    }

    init?(id: String, data: [String: Any]) {
        self.id = id
        self.displayName = data["displayName"] as? String ?? "Partner"
        self.coupleId = data["coupleId"] as? String
        self.createdAt = (data["createdAt"] as? Timestamp)?.dateValue() ?? .now
    }

    var firestoreData: [String: Any] {
        var data: [String: Any] = [
            "displayName": displayName,
            "createdAt": Timestamp(date: createdAt)
        ]
        if let coupleId {
            data["coupleId"] = coupleId
        } else {
            data["coupleId"] = FieldValue.delete()
        }
        return data
    }
}

struct Couple: Identifiable, Equatable {
    var id: String
    var inviteCode: String
    var memberIds: [String]
    var createdAt: Date
    var sharedPhotoParticipantIds: [String]
    var sharedPhotoData: String?
    var sharedPhotoUpdatedBy: String?
    var sharedPhotoUpdatedAt: Date?

    init(
        id: String,
        inviteCode: String,
        memberIds: [String],
        createdAt: Date = .now,
        sharedPhotoParticipantIds: [String] = [],
        sharedPhotoData: String? = nil,
        sharedPhotoUpdatedBy: String? = nil,
        sharedPhotoUpdatedAt: Date? = nil
    ) {
        self.id = id
        self.inviteCode = inviteCode
        self.memberIds = memberIds
        self.createdAt = createdAt
        self.sharedPhotoParticipantIds = sharedPhotoParticipantIds
        self.sharedPhotoData = sharedPhotoData
        self.sharedPhotoUpdatedBy = sharedPhotoUpdatedBy
        self.sharedPhotoUpdatedAt = sharedPhotoUpdatedAt
    }

    init?(id: String, data: [String: Any]) {
        guard let inviteCode = data["inviteCode"] as? String else { return nil }
        self.id = id
        self.inviteCode = inviteCode
        self.memberIds = data["memberIds"] as? [String] ?? []
        self.createdAt = (data["createdAt"] as? Timestamp)?.dateValue() ?? .now
        self.sharedPhotoParticipantIds = data["sharedPhotoParticipantIds"] as? [String] ?? []
        self.sharedPhotoData = data["sharedPhotoData"] as? String
        self.sharedPhotoUpdatedBy = data["sharedPhotoUpdatedBy"] as? String
        self.sharedPhotoUpdatedAt = (data["sharedPhotoUpdatedAt"] as? Timestamp)?.dateValue()
    }

    var firestoreData: [String: Any] {
        [
            "inviteCode": inviteCode,
            "memberIds": memberIds,
            "createdAt": Timestamp(date: createdAt),
            "sharedPhotoParticipantIds": sharedPhotoParticipantIds
        ]
    }

    var isPhotoSharedByBoth: Bool {
        !memberIds.isEmpty && memberIds.allSatisfy { sharedPhotoParticipantIds.contains($0) }
    }
}

struct CoupleItem: Identifiable, Equatable, Hashable {
    var id: String
    var title: String
    var address: String?
    var priceText: String?
    var dateStart: Date?
    var dateEnd: Date?
    var createdBy: String
    var createdAt: Date
    var completedAt: Date?

    var isCompleted: Bool { completedAt != nil }

    var usesDateRange: Bool {
        guard let dateStart, let dateEnd else { return false }
        return Calendar.current.startOfDay(for: dateEnd) > Calendar.current.startOfDay(for: dateStart)
    }

    func snapshot() -> WidgetItemSnapshot {
        WidgetItemSnapshot(
            id: id,
            title: title,
            address: address,
            priceText: priceText,
            dateStart: dateStart,
            dateEnd: dateEnd,
            createdAt: createdAt,
            completedAt: completedAt
        )
    }

    init(
        id: String = UUID().uuidString,
        title: String,
        address: String? = nil,
        priceText: String? = nil,
        dateStart: Date? = nil,
        dateEnd: Date? = nil,
        createdBy: String,
        createdAt: Date = .now,
        completedAt: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.address = address
        self.priceText = priceText
        self.dateStart = dateStart
        self.dateEnd = dateEnd
        self.createdBy = createdBy
        self.createdAt = createdAt
        self.completedAt = completedAt
    }

    init?(id: String, data: [String: Any]) {
        guard let title = data["title"] as? String, !title.isEmpty else { return nil }
        self.id = id
        self.title = title
        self.address = data["address"] as? String
        self.priceText = data["priceText"] as? String
        self.dateStart = (data["dateStart"] as? Timestamp)?.dateValue()
        self.dateEnd = (data["dateEnd"] as? Timestamp)?.dateValue()
        self.createdBy = data["createdBy"] as? String ?? ""
        self.createdAt = (data["createdAt"] as? Timestamp)?.dateValue() ?? .now
        self.completedAt = (data["completedAt"] as? Timestamp)?.dateValue()
    }

    var firestoreData: [String: Any] {
        var data: [String: Any] = [
            "title": title,
            "createdBy": createdBy,
            "createdAt": Timestamp(date: createdAt)
        ]
        data["address"] = address.map { $0 as Any } ?? NSNull()
        data["priceText"] = priceText.map { $0 as Any } ?? NSNull()
        data["dateStart"] = dateStart.map { Timestamp(date: $0) as Any } ?? NSNull()
        data["dateEnd"] = dateEnd.map { Timestamp(date: $0) as Any } ?? NSNull()
        data["completedAt"] = completedAt.map { Timestamp(date: $0) as Any } ?? NSNull()
        return data
    }
}
