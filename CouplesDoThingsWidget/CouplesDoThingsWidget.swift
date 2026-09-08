import SwiftUI
import UIKit
import WidgetKit

struct CouplesWidgetEntry: TimelineEntry {
    let date: Date
    let snapshot: WidgetSnapshot
    let imageRevision: Int
}

struct CouplesWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> CouplesWidgetEntry {
        CouplesWidgetEntry(date: .now, snapshot: .empty, imageRevision: WidgetDataStore.backgroundImageRevision())
    }

    func getSnapshot(in context: Context, completion: @escaping (CouplesWidgetEntry) -> Void) {
        completion(
            CouplesWidgetEntry(
                date: .now,
                snapshot: WidgetDataStore.loadSnapshot(),
                imageRevision: WidgetDataStore.backgroundImageRevision()
            )
        )
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CouplesWidgetEntry>) -> Void) {
        let entry = CouplesWidgetEntry(
            date: .now,
            snapshot: WidgetDataStore.loadSnapshot(),
            imageRevision: WidgetDataStore.backgroundImageRevision()
        )
        let next = Calendar.current.date(byAdding: .hour, value: 1, to: .now) ?? .now.addingTimeInterval(3600)
        completion(Timeline(entries: [entry], policy: .after(next)))
    }
}

struct CouplesDoThingsWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "CouplesDoThingsWidget", provider: CouplesWidgetProvider()) { entry in
            CouplesWidgetView(entry: entry)
                .widgetBackground(revision: entry.imageRevision)
        }
        .configurationDisplayName("Couples Do Things")
        .description("Upcoming dates and recently added ideas.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

extension View {
    @ViewBuilder
    func widgetBackground(revision: Int) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            containerBackground(for: .widget) {
                WidgetBackground(revision: revision)
            }
        } else {
            background(WidgetBackground(revision: revision))
        }
    }
}

struct WidgetBackground: View {
    let revision: Int

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(red: 0.35, green: 0.18, blue: 0.20)
                if let imageData = WidgetDataStore.loadBackgroundImageData(),
                   let image = UIImage(data: imageData) {
                    if #available(iOSApplicationExtension 18.0, *) {
                        Image(uiImage: image)
                            .resizable()
                            .widgetAccentedRenderingMode(.fullColor)
                            .scaledToFill()
                            .frame(width: geo.size.width, height: geo.size.height)
                            .clipped()
                    } else {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width, height: geo.size.height)
                            .clipped()
                    }
                }
                Color.black.opacity(0.45)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .id(revision)
    }
}

struct CouplesWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: CouplesWidgetEntry

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemLarge:
            ListWidgetView(entry: entry, upcomingLimit: 3, recentLimit: 6)
        default:
            ListWidgetView(entry: entry, upcomingLimit: 2, recentLimit: 3)
        }
    }
}

struct SmallWidgetView: View {
    let entry: CouplesWidgetEntry

    var body: some View {
        let item = entry.snapshot.spotlightItem
        VStack(alignment: .leading, spacing: 6) {
            Text(entry.snapshot.coupleName)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white.opacity(0.85))
            Spacer()
            if let item {
                Text(item.title)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .lineLimit(3)
                if let date = item.dateLabel {
                    Text(date)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.85))
                }
            } else {
                Text("Add something to do together")
                    .font(.subheadline)
                    .foregroundStyle(.white)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .widgetURL(item.map { DeepLink.item(id: $0.id).url } ?? DeepLink.list.url)
    }
}

struct ListWidgetView: View {
    let entry: CouplesWidgetEntry
    let upcomingLimit: Int
    let recentLimit: Int

    private var upcoming: [WidgetItemSnapshot] {
        Array(entry.snapshot.upcomingItems.prefix(upcomingLimit))
    }

    private var recent: [WidgetItemSnapshot] {
        let upcomingIDs = Set(upcoming.map(\.id))
        return Array(entry.snapshot.recentItems.filter { !upcomingIDs.contains($0.id) }.prefix(recentLimit))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(entry.snapshot.coupleName)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white.opacity(0.85))

            if !upcoming.isEmpty {
                Text("Upcoming")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.white.opacity(0.7))
                ForEach(upcoming) { item in
                    Link(destination: DeepLink.item(id: item.id).url) {
                        WidgetItemLine(item: item, showDate: true)
                    }
                }
            }

            if !recent.isEmpty {
                Text("Recently added")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.white.opacity(0.7))
                ForEach(recent) { item in
                    Link(destination: DeepLink.item(id: item.id).url) {
                        WidgetItemLine(item: item, showDate: item.dateLabel != nil)
                    }
                }
            }

            if upcoming.isEmpty && recent.isEmpty {
                Text("Your shared list is empty")
                    .font(.subheadline)
                    .foregroundStyle(.white)
                Spacer()
            } else {
                Spacer(minLength: 0)
            }
        }
        .widgetURL(DeepLink.list.url)
    }
}

struct WidgetItemLine: View {
    let item: WidgetItemSnapshot
    let showDate: Bool

    var body: some View {
        HStack {
            Text(item.title)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.white)
                .lineLimit(1)
            Spacer()
            if showDate, let date = item.dateLabel {
                Text(date)
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.8))
                    .lineLimit(1)
            }
        }
    }
}
