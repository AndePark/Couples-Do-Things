import MapKit
import SwiftUI

private struct AddressMapPin: Identifiable {
    let id = "pin"
    let coordinate: CLLocationCoordinate2D
}

struct AddressMapPreview: View {
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
            await geocode()
        }
    }

    private func geocode() async {
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

        let geocoder = CLGeocoder()
        do {
            let placemarks: [CLPlacemark] = try await withCheckedThrowingContinuation { continuation in
                geocoder.geocodeAddressString(trimmed) { marks, error in
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
            let coordinate = location.coordinate
            region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
            pin = AddressMapPin(coordinate: coordinate)
            didFindLocation = true
        } catch {
            lookupFailed = true
        }
    }
}
