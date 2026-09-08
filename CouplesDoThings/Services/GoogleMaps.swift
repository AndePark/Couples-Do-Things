import Foundation
import UIKit

enum GoogleMaps {
    static func open(address: String) {
        let trimmed = address.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        var components = URLComponents(string: "https://www.google.com/maps/search/")
        components?.queryItems = [
            URLQueryItem(name: "api", value: "1"),
            URLQueryItem(name: "query", value: trimmed)
        ]
        guard let url = components?.url else { return }
        UIApplication.shared.open(url)
    }
}
