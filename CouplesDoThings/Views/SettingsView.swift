import CoreTransferable
import PhotosUI
import SwiftUI
import UIKit
import UniformTypeIdentifiers
import WidgetKit

struct SettingsView: View {
    @EnvironmentObject private var auth: AuthService
    @EnvironmentObject private var session: SessionStore
    @State private var photoItem: PhotosPickerItem?
    @State private var hasWidgetPhoto = WidgetDataStore.loadPersonalBackgroundImageData() != nil
    @State private var showLeaveConfirm = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Couple") {
                    if let code = session.couple?.inviteCode {
                        HStack {
                            Text("Invite code")
                            Spacer()
                            Text(code)
                                .font(.body.monospaced())
                                .textSelection(.enabled)
                        }
                        Button("Copy invite code") {
                            UIPasteboard.general.string = code
                        }
                    }
                    LabeledContent("Partner", value: session.partnerName ?? "Waiting for partner")
                }

                Section("Home screen widget") {
                    PhotosPicker(selection: $photoItem, matching: .images) {
                        Label(hasWidgetPhoto ? "Change widget photo" : "Choose widget photo", systemImage: "photo")
                    }
                    if hasWidgetPhoto {
                        Button("Remove widget photo", role: .destructive) {
                            removePhoto()
                        }
                    }
                    if session.partnerName != nil {
                        Toggle(isOn: Binding(
                            get: { session.isSharingPhoto },
                            set: { newValue in
                                Task { await session.setPhotoSharing(enabled: newValue) }
                            }
                        )) {
                            Text("Share this photo with your partner")
                        }
                        .disabled(!hasWidgetPhoto && !session.isSharingPhoto)

                        Text(shareStatusText)
                            .font(.footnote)
                            .foregroundStyle(AppTheme.muted)
                    } else {
                        Text("This photo stays on this iPhone. Your partner can pick their own.")
                            .font(.footnote)
                            .foregroundStyle(AppTheme.muted)
                    }
                }

                Section {
                    Button("Leave couple space", role: .destructive) {
                        showLeaveConfirm = true
                    }
                    Button("Sign out", role: .destructive) {
                        try? auth.signOut()
                        session.stop()
                    }
                }

                if let message = session.errorMessage {
                    Section {
                        Text(message).foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Settings")
            .scrollContentBackground(.hidden)
            .background(AppTheme.cream)
            .confirmationDialog("Leave this couple space?", isPresented: $showLeaveConfirm, titleVisibility: .visible) {
                Button("Leave", role: .destructive) {
                    Task { await session.leaveCouple() }
                }
            }
            .onChange(of: photoItem) { item in
                Task { await savePhoto(item) }
            }
        }
    }

    private var shareStatusText: String {
        guard let couple = session.couple else {
            return "Turn this on and your partner can too, to show the same photo on both widgets."
        }
        if couple.isPhotoSharedByBoth {
            return "Shared — both of your widgets show this photo."
        }
        if session.isSharingPhoto {
            return "Waiting for your partner to also turn this on."
        }
        return "Turn this on and your partner can too, to show the same photo on both widgets."
    }

    private func savePhoto(_ item: PhotosPickerItem?) async {
        guard let item else { return }

        var data: Data?
        if let picked = try? await item.loadTransferable(type: PickedImageData.self) {
            data = picked.data
        } else if let raw = try? await item.loadTransferable(type: Data.self) {
            data = raw
        }

        guard let data, let jpeg = Self.jpegData(from: data) else { return }

        WidgetDataStore.savePersonalBackgroundImageData(jpeg)
        await MainActor.run {
            hasWidgetPhoto = WidgetDataStore.loadPersonalBackgroundImageData() != nil
        }

        if session.isSharingPhoto {
            await session.setPhotoSharing(enabled: true)
        } else {
            WidgetDataStore.saveBackgroundImageData(jpeg)
            session.refreshWidgetPhoto()
        }
    }

    private func removePhoto() {
        WidgetDataStore.savePersonalBackgroundImageData(nil)
        hasWidgetPhoto = false
        if session.isSharingPhoto {
            Task { await session.setPhotoSharing(enabled: false) }
        } else {
            WidgetDataStore.saveBackgroundImageData(nil)
            session.refreshWidgetPhoto()
        }
    }

    private static func jpegData(from data: Data, maxDimension: CGFloat = 400) -> Data? {
        guard let image = UIImage(data: data) else { return nil }
        let longest = max(image.size.width, image.size.height)
        let scale = longest > maxDimension ? maxDimension / longest : 1
        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let renderer = UIGraphicsImageRenderer(size: size)
        let rendered = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
        return rendered.jpegData(compressionQuality: 0.6)
    }
}

private struct PickedImageData: Transferable {
    let data: Data

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            PickedImageData(data: data)
        }
        DataRepresentation(importedContentType: .jpeg) { data in
            PickedImageData(data: data)
        }
        DataRepresentation(importedContentType: .png) { data in
            PickedImageData(data: data)
        }
        DataRepresentation(importedContentType: .heic) { data in
            PickedImageData(data: data)
        }
    }
}
