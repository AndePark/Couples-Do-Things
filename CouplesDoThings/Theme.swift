import SwiftUI

enum AppTheme {
    static let rose = Color(red: 0.72, green: 0.33, blue: 0.38)
    static let cream = Color(red: 0.98, green: 0.95, blue: 0.91)
    static let ink = Color(red: 0.22, green: 0.16, blue: 0.16)
    static let muted = Color(red: 0.45, green: 0.36, blue: 0.36)
}

struct AppEmptyState: View {
    let title: String
    let systemImage: String
    let message: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 44))
                .foregroundStyle(AppTheme.muted)
            Text(title)
                .font(.title3.weight(.semibold))
                .foregroundStyle(AppTheme.ink)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(AppTheme.muted)
                .multilineTextAlignment(.center)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
