import Foundation

enum WidgetDataStore {
    private static var containerURL: URL? {
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: AppConstants.appGroupID)
        print("🔍 WidgetDataStore containerURL: \(url?.path ?? "NIL — App Group container not accessible")")
        return url
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
        prepareContainer()
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(snapshot) else { return }
        try? data.write(to: snapshotURL, options: .atomic)
    }

    static func loadBackgroundImageData() -> Data? {
        guard let backgroundURL else {
            print("🔍 loadBackgroundImageData: backgroundURL is NIL")
            return nil
        }
        print("🔍 loadBackgroundImageData: checking path \(backgroundURL.path)")
        let exists = FileManager.default.fileExists(atPath: backgroundURL.path)
        print("🔍 loadBackgroundImageData: file exists = \(exists)")
        let data = try? Data(contentsOf: backgroundURL)
        print("🔍 loadBackgroundImageData: data bytes = \(data?.count ?? -1)")
        return data
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
        guard let backgroundURL else {
            print("🔍 saveBackgroundImageData: backgroundURL is NIL — cannot save")
            return
        }
        prepareContainer()
        if let data {
            do {
                try data.write(to: backgroundURL, options: .atomic)
                print("🔍 saveBackgroundImageData: wrote \(data.count) bytes to \(backgroundURL.path)")
            } catch {
                print("🔍 saveBackgroundImageData: WRITE FAILED: \(error)")
            }
        } else {
            try? FileManager.default.removeItem(at: backgroundURL)
        }
    }

    private static func prepareContainer() {
        guard let containerURL else { return }
        try? FileManager.default.createDirectory(at: containerURL, withIntermediateDirectories: true)
    }
}
