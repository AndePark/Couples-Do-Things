import Foundation

struct WidgetItemSnapshot: Codable, Identifiable, Hashable {
    var id: String
    var title: String
    var address: String?
    var priceText: String?
    var dateStart: Date?
    var dateEnd: Date?
    var createdAt: Date
    var completedAt: Date?

    var isCompleted: Bool { completedAt != nil }

    var dateLabel: String? {
        guard let dateStart else { return nil }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        if let dateEnd, Calendar.current.startOfDay(for: dateEnd) > Calendar.current.startOfDay(for: dateStart) {
            return "\(formatter.string(from: dateStart)) – \(formatter.string(from: dateEnd))"
        }
        return formatter.string(from: dateStart)
    }
}

struct WidgetSnapshot: Codable, Hashable {
    var coupleName: String
    var items: [WidgetItemSnapshot]
    var updatedAt: Date

    var activeItems: [WidgetItemSnapshot] {
        items.filter { !$0.isCompleted }
    }

    var upcomingItems: [WidgetItemSnapshot] {
        let startOfToday = Calendar.current.startOfDay(for: Date())
        return activeItems
            .filter { item in
                guard let date = item.dateStart else { return false }
                return date >= startOfToday || (item.dateEnd ?? date) >= startOfToday
            }
            .sorted { ($0.dateStart ?? .distantFuture) < ($1.dateStart ?? .distantFuture) }
    }

    var recentItems: [WidgetItemSnapshot] {
        activeItems.sorted { $0.createdAt > $1.createdAt }
    }

    var spotlightItem: WidgetItemSnapshot? {
        upcomingItems.first ?? recentItems.first
    }

    static let empty = WidgetSnapshot(coupleName: "Couples Do Things", items: [], updatedAt: .now)
}
