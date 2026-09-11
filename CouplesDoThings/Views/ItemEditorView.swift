import SwiftUI

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
    @State private var isResolvingAddress = false

    var body: some View {
        NavigationStack {
            Form {
                Section("What do you want to do?") {
                    TextField("Title", text: $title)
                }
                Section("Optional details") {
                    HStack {
                        TextField("Address", text: $address)
                        if isResolvingAddress {
                            ProgressView()
                        }
                    }
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
                    Section("Map") {
                        AddressMapPreview(address: address)
                        Button("Open in Google Maps") {
                            Task {
                                self.address = await GoogleMaps.openResolvingAddress(address)
                            }
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
            .task(id: address) {
                await autoResolveIfNeeded()
            }
        }
    }

    private var sanitizedAddress: String? {
        let value = address.trimmingCharacters(in: .whitespacesAndNewlines)
        return value.isEmpty ? nil : value
    }

    /// If the address field currently holds a Google Maps URL, silently
    /// resolve it to a plain address as soon as pasting settles.
    private func autoResolveIfNeeded() async {
        let trimmed = address.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let url = URL(string: trimmed), let scheme = url.scheme, scheme.hasPrefix("http") else {
            return
        }

        try? await Task.sleep(nanoseconds: 300_000_000)
        guard !Task.isCancelled else { return }
        guard address.trimmingCharacters(in: .whitespacesAndNewlines) == trimmed else { return }

        isResolvingAddress = true
        let resolved = await GoogleMapsLinkResolver.resolvedAddress(from: trimmed)
        isResolvingAddress = false

        guard !Task.isCancelled else { return }
        if address.trimmingCharacters(in: .whitespacesAndNewlines) == trimmed, let resolved {
            address = resolved
        }
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
}
