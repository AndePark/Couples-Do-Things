//
//  GoogleMapsLinkResolver.swift
//  CouplesDoThings
//
//  Created by Andrew Park on 2026-09-11.
//

import Foundation
import CoreLocation
import Contacts

/// Shared logic for turning a pasted Google Maps URL (or plain address) into
/// a clean, human-readable address string.
enum GoogleMapsLinkResolver {

    /// Returns a resolved, human-readable address if `input` is a Google Maps
    /// URL (short or long). Returns nil if `input` isn't a URL at all -
    /// callers should treat that as "already a plain address, nothing to do."
    static func resolvedAddress(from input: String) async -> String? {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let url = URL(string: trimmed), let scheme = url.scheme, scheme.hasPrefix("http") else {
            return nil
        }

        let resolvedURL = await expandIfShortLink(url)

        if let coordinate = extractCoordinate(from: resolvedURL) {
            if let formatted = await reverseGeocode(coordinate) {
                return formatted
            }
            // Fallback: at least give something usable rather than a raw URL.
            return String(format: "%.6f, %.6f", coordinate.latitude, coordinate.longitude)
        }

        if let query = extractQuery(from: resolvedURL) {
            return query
        }

        return nil
    }

    // MARK: - Short link expansion

    static func expandIfShortLink(_ url: URL) async -> URL {
        let host = url.host?.lowercased() ?? ""
        guard host.contains("goo.gl") else { return url }

        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let finalURL = response.url {
                return finalURL
            }
        } catch {
            // Fall back to the original URL if expansion fails.
        }
        return url
    }

    // MARK: - Coordinate / query extraction

    static func extractCoordinate(from url: URL) -> CLLocationCoordinate2D? {
        let fullString = url.absoluteString
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

    static func extractQuery(from url: URL) -> String? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }

        if let q = components.queryItems?.first(where: { $0.name == "q" })?.value, !q.isEmpty {
            return q.replacingOccurrences(of: "+", with: " ")
        }

        let path = url.path
        if let range = path.range(of: "/place/") {
            let afterPlace = path[range.upperBound...]
            let namePart = afterPlace.split(separator: "/").first ?? ""
            let decoded = namePart
                .replacingOccurrences(of: "+", with: " ")
                .removingPercentEncoding ?? String(namePart)

            return decoded.isEmpty ? nil : decoded
        }

        return nil
    }

    // MARK: - Reverse geocoding

    static func reverseGeocode(_ coordinate: CLLocationCoordinate2D) async -> String? {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        do {
            let placemarks = try await CLGeocoder().reverseGeocodeLocation(location)
            guard let placemark = placemarks.first else { return nil }

            if let postalAddress = placemark.postalAddress {
                return CNPostalAddressFormatter.string(from: postalAddress, style: .mailingAddress)
                    .replacingOccurrences(of: "\n", with: ", ")
            }

            return [
                placemark.name,
                placemark.locality,
                placemark.administrativeArea,
                placemark.country
            ]
            .compactMap { $0 }
            .joined(separator: ", ")
        } catch {
            return nil
        }
    }
}
