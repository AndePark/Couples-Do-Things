import PhotosUI
import SwiftUI
import UIKit
import WidgetKit

struct SettingsView: View {
    @EnvironmentObject private var auth: AuthService
    @EnvironmentObject private var session: SessionStore
    @State private var photoItem: PhotosPickerItem?
    @State private var hasWidgetPhoto = WidgetDataStore.loadBackgroundImageData() != nil
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
                            WidgetDataStore.saveBackgroundImageData(nil)
                            hasWidgetPhoto = false
                            WidgetCenter.shared.reloadAllTimelines()
                        }
                    }
                    Text("This photo stays on this iPhone. Your partner can pick their own.")
                        .font(.footnote)
                        .foregroundStyle(AppTheme.muted)
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
            .onChange(of: photoItem) { _, item in
                Task { await savePhoto(item) }
            }
        }
    }

    private func savePhoto(_ item: PhotosPickerItem?) async {
        guard let item else { return }
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        let resized = Self.jpegData(from: data) ?? data
        WidgetDataStore.saveBackgroundImageData(resized)
        hasWidgetPhoto = true
        session.refreshWidgetPhoto()
    }

    private static func jpegData(from data: Data, maxDimension: CGFloat = 1200) -> Data? {
        guard let image = UIImage(data: data) else { return data }
        let longest = max(image.size.width, image.size.height)
        let scale = longest > maxDimension ? maxDimension / longest : 1
        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let renderer = UIGraphicsImageRenderer(size: size)
        let rendered = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
        return rendered.jpegData(compressionQuality: 0.8)
    }
}
