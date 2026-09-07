import Foundation

enum WidgetDataStore {
    private static var containerURL: URL? {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: AppConstants.appGroupID)
    }

    private static var snapshotURL: URL? {
        containerURL?.appendingPathComponent(AppConstants.snapshotFileName)
    }

    private static var backgroundURL: URL? {
        containerURL?.appendingPathComponent(AppConstants.backgroundImageFileName)
    }

    static func loadSnapshot() -> WidgetSnapshot {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        guard let snapshotURL,
              let data = try? Data(contentsOf: snapshotURL),
              let snapshot = try? decoder.decode(WidgetSnapshot.self, from: data)
        else {
            return .empty
        }
        return snapshot
    }

    static func saveSnapshot(_ snapshot: WidgetSnapshot) {
        guard let snapshotURL else { return }
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(snapshot) else { return }
        try? data.write(to: snapshotURL, options: .atomic)
    }

    static func loadBackgroundImageData() -> Data? {
        guard let backgroundURL else { return nil }
        return try? Data(contentsOf: backgroundURL)
    }

    static func saveBackgroundImageData(_ data: Data?) {
        guard let backgroundURL else { return }
        if let data {
            try? data.write(to: backgroundURL, options: .atomic)
        } else {
            try? FileManager.default.removeItem(at: backgroundURL)
        }
    }
}
