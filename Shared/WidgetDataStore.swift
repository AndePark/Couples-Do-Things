import Foundation

enum WidgetDataStore {
    private static var containerURL: URL? {
        if let group = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: AppConstants.appGroupID) {
            return group
        }
        return FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first?
            .appendingPathComponent("CouplesDoThings", isDirectory: true)
    }

    private static var snapshotURL: URL? {
        containerURL?.appendingPathComponent(AppConstants.snapshotFileName)
    }

    private static var backgroundURL: URL? {
        containerURL?.appendingPathComponent(AppConstants.backgroundImageFileName)
    }

    private static var personalBackgroundURL: URL? {
        containerURL?.appendingPathComponent(AppConstants.personalBackgroundImageFileName)
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
        prepareContainer()
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(snapshot) else { return }
        try? data.write(to: snapshotURL, options: .atomic)
    }

    static func loadBackgroundImageData() -> Data? {
        guard let backgroundURL else { return nil }
        return try? Data(contentsOf: backgroundURL)
    }

    static func backgroundImageRevision() -> Int {
        guard let backgroundURL,
              let values = try? backgroundURL.resourceValues(forKeys: [.contentModificationDateKey, .fileSizeKey])
        else {
            return 0
        }
        let stamp = Int((values.contentModificationDate ?? .distantPast).timeIntervalSince1970)
        return stamp ^ (values.fileSize ?? 0)
    }

    static func saveBackgroundImageData(_ data: Data?) {
        guard let backgroundURL else { return }
        prepareContainer()
        if let data {
            try? data.write(to: backgroundURL, options: .atomic)
        } else {
            try? FileManager.default.removeItem(at: backgroundURL)
        }
    }

    static func loadPersonalBackgroundImageData() -> Data? {
        guard let personalBackgroundURL else { return nil }
        return try? Data(contentsOf: personalBackgroundURL)
    }

    static func savePersonalBackgroundImageData(_ data: Data?) {
        guard let personalBackgroundURL else { return }
        prepareContainer()
        if let data {
            try? data.write(to: personalBackgroundURL, options: .atomic)
        } else {
            try? FileManager.default.removeItem(at: personalBackgroundURL)
        }
    }

    private static func prepareContainer() {
        guard let containerURL else { return }
        try? FileManager.default.createDirectory(at: containerURL, withIntermediateDirectories: true)
    }
}
