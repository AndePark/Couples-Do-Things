import Foundation
import UIKit

enum GoogleMaps {
    /// Opens Google Maps for the given address/query string.
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

    /// Resolves a pasted Google Maps URL (if any) to a clean address, then opens Maps.
    /// Returns the resolved address so the caller can save it back into their address field.
    /// If `address` wasn't a Google Maps URL, returns it unchanged.
    @discardableResult
    static func openResolvingAddress(_ address: String) async -> String {
        let resolved = await GoogleMapsLinkResolver.resolvedAddress(from: address) ?? address
        open(address: resolved)
        return resolved
    }
}
