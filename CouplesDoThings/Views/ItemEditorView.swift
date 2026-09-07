import SwiftUI
import UIKit

struct ItemEditorView: View {
    @EnvironmentObject private var session: SessionStore
    @Environment(\.dismiss) private var dismiss

    let item: CoupleItem?

    @State private var title = ""
    @State private var address = ""
    @State private var priceText = ""
    @State private var includeDates = false
    @State private var useRange = false
    @State private var dateStart = Date()
    @State private var dateEnd = Date()

    var body: some View {
        NavigationStack {
            Form {
                Section("What do you want to do?") {
                    TextField("Title", text: $title)
                }
                Section("Optional details") {
                    TextField("Address", text: $address)
                    TextField("Price", text: $priceText)
                    Toggle("Add dates", isOn: $includeDates)
                    if includeDates {
                        Toggle("Date range", isOn: $useRange)
                        DatePicker(useRange ? "Starts" : "Date", selection: $dateStart, displayedComponents: .date)
                        if useRange {
                            DatePicker("Ends", selection: $dateEnd, in: dateStart..., displayedComponents: .date)
                        }
                    }
                }
                if let address = sanitizedAddress {
                    Section {
                        Button("Open in Maps") {
                            openMaps(address: address)
                        }
                    }
                }
            }
            .navigationTitle(item == nil ? "Add" : "Edit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { Task { await save() } }
                        .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onAppear { hydrate() }
        }
    }

    private var sanitizedAddress: String? {
        let value = address.trimmingCharacters(in: .whitespacesAndNewlines)
        return value.isEmpty ? nil : value
    }

    private func hydrate() {
        guard let item else { return }
        title = item.title
        address = item.address ?? ""
        priceText = item.priceText ?? ""
        if let start = item.dateStart {
            includeDates = true
            dateStart = start
            if let end = item.dateEnd, item.usesDateRange {
                useRange = true
                dateEnd = end
            } else {
                dateEnd = start
            }
        }
    }

    private func save() async {
        guard let uid = session.uid else { return }
        var next = item ?? CoupleItem(title: title, createdBy: uid)
        next.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        next.address = sanitizedAddress
        let price = priceText.trimmingCharacters(in: .whitespacesAndNewlines)
        next.priceText = price.isEmpty ? nil : price
        if includeDates {
            next.dateStart = Calendar.current.startOfDay(for: dateStart)
            next.dateEnd = useRange ? Calendar.current.startOfDay(for: dateEnd) : nil
        } else {
            next.dateStart = nil
            next.dateEnd = nil
        }
        await session.save(item: next)
        dismiss()
    }

    private func openMaps(address: String) {
        var components = URLComponents(string: "http://maps.apple.com/")
        components?.queryItems = [URLQueryItem(name: "q", value: address)]
        if let url = components?.url {
            UIApplication.shared.open(url)
        }
    }
}
