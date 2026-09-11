import MapKit
import SwiftUI

private struct AddressMapPin: Identifiable {
    let id = "pin"
    let coordinate: CLLocationCoordinate2D
}

struct AddressMapPreview: View {
    /// Accepts either a plain address string or a Google Maps URL
    /// (e.g. "https://maps.google.com/?q=...", "https://maps.app.goo.gl/...",
    /// or a URL containing "@lat,lng" coordinates).
    let address: String

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.3349, longitude: -122.0090),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var pin: AddressMapPin?
    @State private var didFindLocation = false
    @State private var lookupFailed = false

    var body: some View {
        Group {
            if didFindLocation, let pin {
                Map(coordinateRegion: $region, annotationItems: [pin]) { item in
                    MapMarker(coordinate: item.coordinate)
                }
                .frame(height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .allowsHitTesting(false)
            } else if lookupFailed {
                Text("Couldn't place this address on the map yet. You can still open it in Google Maps.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .frame(height: 80)
            }
        }
        .task(id: address) {
            await resolveAndGeocode()
        }
    }

    private func resolveAndGeocode() async {
        didFindLocation = false
        lookupFailed = false
        pin = nil

        let trimmed = address.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            lookupFailed = true
            return
        }

        try? await Task.sleep(nanoseconds: 400_000_000)
        guard !Task.isCancelled else { return }

        // If it's a URL, first try to pull out coordinates or a search query.
        if let url = URL(string: trimmed), let scheme = url.scheme, scheme.hasPrefix("http") {
            let resolvedURL = await expandIfShortLink(url)

            if let coordinate = extractCoordinate(from: resolvedURL) {
                await place(coordinate: coordinate)
                return
            }

            if let query = extractQuery(from: resolvedURL) {
                await geocode(text: query)
                return
            }

            // Fall back to geocoding the raw URL string itself (rarely works, but harmless).
            await geocode(text: trimmed)
            return
        }

        // Not a URL — treat as a plain address string.
        await geocode(text: trimmed)
    }

    /// Expands shortened Google Maps links (maps.app.goo.gl, goo.gl/maps) by following the redirect.
    private func expandIfShortLink(_ url: URL) async -> URL {
        let host = url.host?.lowercased() ?? ""
        guard host.contains("goo.gl") || host.contains("app.goo.gl") else {
            return url
        }

        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let finalURL = response.url {
                return finalURL
            }
        } catch {
            // If expansion fails, just fall back to the original URL.
        }
        return url
    }

    /// Extracts a "@lat,lng" style coordinate from common Google Maps URL formats.
    private func extractCoordinate(from url: URL) -> CLLocationCoordinate2D? {
        let fullString = url.absoluteString

        // Pattern: .../@37.3349,-122.0090,15z or ?ll=37.3349,-122.0090
        let patterns = [
            #"@(-?\d+\.\d+),(-?\d+\.\d+)"#,
            #"[?&]ll=(-?\d+\.\d+),(-?\d+\.\d+)"#,
            #"[?&]q=(-?\d+\.\d+),(-?\d+\.\d+)"#
        ]

        for pattern in patterns {
            guard let regex = try? NSRegularExpression(pattern: pattern) else { continue }
            let range = NSRange(fullString.startIndex..., in: fullString)
            if let match = regex.firstMatch(in: fullString, range: range),
               let latRange = Range(match.range(at: 1), in: fullString),
               let lngRange = Range(match.range(at: 2), in: fullString),
               let lat = Double(fullString[latRange]),
               let lng = Double(fullString[lngRange]) {
                return CLLocationCoordinate2D(latitude: lat, longitude: lng)
            }
        }
        return nil
    }

    /// Extracts a searchable address/place string from a Google Maps URL's query params.
    private func extractQuery(from url: URL) -> String? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }

        if let q = components.queryItems?.first(where: { $0.name == "q" })?.value,
           !q.isEmpty {
            return q.replacingOccurrences(of: "+", with: " ")
        }

        // Pattern: /maps/place/Some+Place+Name/@...
        let path = url.path
        if let range = path.range(of: "/place/") {
            let afterPlace = path[range.upperBound...]
            let namePart = afterPlace.split(separator: "/").first ?? ""
            let decoded = namePart
                .replacingOccurrences(of: "+", with: " ")
                .removingPercentEncoding ?? String(namePart)
            if !decoded.isEmpty {
                return decoded
            }
        }

        return nil
    }

    private func place(coordinate: CLLocationCoordinate2D) async {
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        pin = AddressMapPin(coordinate: coordinate)
        didFindLocation = true
    }

    private func geocode(text: String) async {
        let geocoder = CLGeocoder()
        do {
            let placemarks: [CLPlacemark] = try await withCheckedThrowingContinuation { continuation in
                geocoder.geocodeAddressString(text) { marks, error in
                    if let error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(returning: marks ?? [])
                    }
                }
            }
            guard let location = placemarks.first?.location else {
                lookupFailed = true
                return
            }
            await place(coordinate: location.coordinate)
        } catch {
            lookupFailed = true
        }
    }
}
