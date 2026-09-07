import Foundation

enum DeepLink: Equatable {
    case list
    case item(id: String)

    init?(url: URL) {
        guard url.scheme == AppConstants.urlScheme else { return nil }
        let host = url.host?.lowercased() ?? ""
        let path = url.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))

        if host == "list" || (host.isEmpty && path == "list") {
            self = .list
            return
        }

        if host == "item" {
            let id = path.isEmpty ? (url.pathComponents.dropFirst().first ?? "") : path
            guard !id.isEmpty else { return nil }
            self = .item(id: id)
            return
        }

        if path.hasPrefix("item/") {
            let id = String(path.dropFirst("item/".count))
            guard !id.isEmpty else { return nil }
            self = .item(id: id)
            return
        }

        return nil
    }

    var url: URL {
        switch self {
        case .list:
            return URL(string: "\(AppConstants.urlScheme)://list")!
        case .item(let id):
            return URL(string: "\(AppConstants.urlScheme)://item/\(id)")!
        }
    }
}
