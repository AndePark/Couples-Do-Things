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
        .contentMarginsDisabled()
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
                    Image(uiImage: image)
                        .resizable()
                        .fullColorWidgetRenderingMode()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width, height: geo.size.height)
                        .position(x: geo.size.width / 2, y: geo.size.height / 2)
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                }
                Color.black.opacity(0.45)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .id(revision)
    }
}

private extension Image {
    @ViewBuilder
    func fullColorWidgetRenderingMode() -> some View {
        if #available(iOSApplicationExtension 18.0, *) {
            widgetAccentedRenderingMode(.fullColor)
        } else {
            self
        }
    }
}

// Fixed row/text heights used purely for budgeting how many items can fit.
// These are deliberately generous estimates (not measured at runtime) so the
// math is guaranteed available at layout time, with no dependency on
// GeometryReader's two-pass text measurement quirks.
//
// "Regular" metrics are used for the large widget only, which has enough
// extra height to afford them. "Compact" metrics are used for both small
// and medium widgets, since on iOS those two families share the same
// height — only large is taller.
//
// Header/section-label text is pinned to these heights via explicit
// `.frame(height:)` modifiers so the *budgeted* height used in the `plan`
// math always matches the *rendered* height on screen. Without that, a
// header that renders taller than its budget silently eats into space
// already allocated to rows, which is what caused clipping/overflow.
//
// headerTopPadding adds breathing room above the couple-name header so it
// doesn't crowd the top-left corner mask. It's subtracted from `plan`'s
// budget alongside headerLineHeight, so it can never cause overflow —
// it just leaves slightly less room for rows.
private enum WidgetMetrics {
    static let gap: CGFloat = 8              // "wall gap" — same value used for outer padding and inter-item spacing
    static let headerLineHeight: CGFloat = 16 // couple name line
    static let headerTopPadding: CGFloat = 4  // breathing room above the couple name
    static let sectionLabelHeight: CGFloat = 14 // "Upcoming" / "Recently added" label
    static let rowHeight: CGFloat = 20        // one item row

    static let compactGap: CGFloat = 6
    static let compactHeaderLineHeight: CGFloat = 15
    static let compactHeaderTopPadding: CGFloat = 5 // a touch more in compact, since insets are tighter there
    static let compactSectionLabelHeight: CGFloat = 12
    static let compactRowHeight: CGFloat = 14
}

struct CouplesWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: CouplesWidgetEntry

    var body: some View {
        GeometryReader { geo in
            // Small and medium widgets share the same height on iOS — only
            // large is taller. Compactness must follow height, not the
            // small/medium split, or medium ends up budgeted like small's
            // width but large's row metrics and under-fills.
            let isCompact = family != .systemLarge
            let inset = isCompact ? WidgetMetrics.compactGap : WidgetMetrics.gap
            let contentWidth = geo.size.width - (inset * 2)
            let contentHeight = geo.size.height - (inset * 2)

            ListWidgetView(entry: entry, contentWidth: contentWidth, contentHeight: contentHeight, isCompact: isCompact)
                .frame(width: contentWidth, height: contentHeight, alignment: .topLeading)
                .padding(inset)
        }
        .dynamicTypeSize(.large)
    }
}

/// Shared list view for all widget sizes. Computes exactly how many items
/// can fit in the available height (based on fixed row-height budgeting) so
/// it is mathematically guaranteed to never overflow, on any device or
/// widget size, while showing as many items as will fit.
///
/// `isCompact` switches to smaller fonts and tighter row/gap metrics —
/// used for small and medium widgets, where vertical space is much more
/// constrained than large.
struct ListWidgetView: View {
    let entry: CouplesWidgetEntry
    let contentWidth: CGFloat
    let contentHeight: CGFloat
    let isCompact: Bool

    private var gap: CGFloat { isCompact ? WidgetMetrics.compactGap : WidgetMetrics.gap }
    private var headerLineHeight: CGFloat { isCompact ? WidgetMetrics.compactHeaderLineHeight : WidgetMetrics.headerLineHeight }
    private var headerTopPadding: CGFloat { isCompact ? WidgetMetrics.compactHeaderTopPadding : WidgetMetrics.headerTopPadding }
    private var sectionLabelHeight: CGFloat { isCompact ? WidgetMetrics.compactSectionLabelHeight : WidgetMetrics.sectionLabelHeight }
    private var rowHeight: CGFloat { isCompact ? WidgetMetrics.compactRowHeight : WidgetMetrics.rowHeight }

    private var allUpcoming: [WidgetItemSnapshot] {
        entry.snapshot.upcomingItems
    }

    private var allRecent: [WidgetItemSnapshot] {
        let upcomingIDs = Set(allUpcoming.map(\.id))
        return entry.snapshot.recentItems.filter { !upcomingIDs.contains($0.id) }
    }

    /// Returns the final (upcoming, recent) item lists, trimmed to fit the
    /// available height, and whether each section header should be shown.
    private var plan: (upcoming: [WidgetItemSnapshot], recent: [WidgetItemSnapshot]) {
        let header = headerLineHeight

        // Height left after the couple-name header line (plus its top
        // padding) and its trailing gap.
        var remaining = contentHeight - header - headerTopPadding - gap

        var upcomingCount = 0
        var recentCount = 0

        let hasUpcoming = !allUpcoming.isEmpty
        let hasRecent = !allRecent.isEmpty

        // Reserve space for section labels up front if that section has any items.
        if hasUpcoming {
            remaining -= sectionLabelHeight + gap
        }
        if hasRecent {
            remaining -= sectionLabelHeight + gap
        }

        // Distribute remaining rows: fill "Upcoming" first, then "Recently added",
        // one row at a time, until we run out of vertical space.
        let rowCost = rowHeight + gap
        var upcomingRemaining = allUpcoming.count
        var recentRemaining = allRecent.count

        while remaining >= rowCost, (upcomingRemaining > 0 || recentRemaining > 0) {
            if upcomingRemaining > 0 {
                upcomingCount += 1
                upcomingRemaining -= 1
            } else if recentRemaining > 0 {
                recentCount += 1
                recentRemaining -= 1
            }
            remaining -= rowCost

            if upcomingCount + recentCount >= allUpcoming.count + allRecent.count {
                break
            }
            // Alternate a second pass check for recent once upcoming is exhausted
            if upcomingRemaining == 0 && recentRemaining > 0 && remaining >= rowCost {
                continue
            }
        }

        // Second pass: fill recent items with any leftover space after upcoming.
        while remaining >= rowCost && recentCount < allRecent.count {
            recentCount += 1
            remaining -= rowCost
        }

        return (Array(allUpcoming.prefix(upcomingCount)), Array(allRecent.prefix(recentCount)))
    }

    var body: some View {
        let result = plan
        let showUpcomingHeader = !result.upcoming.isEmpty
        let showRecentHeader = !result.recent.isEmpty

        VStack(alignment: .center, spacing: gap) {
            Text(entry.snapshot.firstNamesCoupleName.uppercased())
                .font(isCompact ? .system(size: 13, weight: .heavy) : .system(size: 15, weight: .heavy))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .multilineTextAlignment(.center)
                .frame(width: contentWidth, height: headerLineHeight, alignment: .center)
                .padding(.top, headerTopPadding)

            if showUpcomingHeader {
                Text("Upcoming")
                    .font(isCompact ? .system(size: 10, weight: .bold) : .system(size: 11, weight: .bold))
                    .foregroundStyle(.white.opacity(0.9))
                    .lineLimit(1)
                    .multilineTextAlignment(.center)
                    .frame(width: contentWidth, height: sectionLabelHeight, alignment: .center)
                ForEach(result.upcoming) { item in
                    Link(destination: DeepLink.item(id: item.id).url) {
                        WidgetItemLine(item: item, showDate: true, contentWidth: contentWidth, isCompact: isCompact, rowHeight: rowHeight)
                    }
                }
            }

            if showRecentHeader {
                Text("Recently added")
                    .font(isCompact ? .system(size: 10, weight: .bold) : .system(size: 11, weight: .bold))
                    .foregroundStyle(.white.opacity(0.9))
                    .lineLimit(1)
                    .multilineTextAlignment(.center)
                    .frame(width: contentWidth, height: sectionLabelHeight, alignment: .center)
                ForEach(result.recent) { item in
                    Link(destination: DeepLink.item(id: item.id).url) {
                        WidgetItemLine(item: item, showDate: item.dateLabel != nil, contentWidth: contentWidth, isCompact: isCompact, rowHeight: rowHeight)
                    }
                }
            }

            if result.upcoming.isEmpty && result.recent.isEmpty {
                Text("Your shared list is empty")
                    .font(isCompact ? .caption2 : .subheadline)
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)
                    .multilineTextAlignment(.center)
                    .frame(width: contentWidth, alignment: .center)
            }

            Spacer(minLength: 0)
        }
        .frame(width: contentWidth, height: contentHeight, alignment: .top)
        .widgetURL(DeepLink.list.url)
    }
}

struct WidgetItemLine: View {
    let item: WidgetItemSnapshot
    let showDate: Bool
    let contentWidth: CGFloat
    let isCompact: Bool
    let rowHeight: CGFloat

    var body: some View {
        HStack(spacing: isCompact ? 3 : 6) {
            Text(item.title)
                .font(isCompact ? .system(size: 10.5, weight: .medium) : .system(size: 12, weight: .medium))
                .foregroundStyle(.white.opacity(0.86))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .allowsTightening(true)
                .layoutPriority(1)
            if showDate, let date = item.dateLabel {
                Spacer(minLength: 4)
                Text(date)
                    .font(isCompact ? .system(size: 8.5) : .system(size: 10))
                    .foregroundStyle(.white.opacity(0.65))
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
            }
        }
        .frame(width: contentWidth, height: rowHeight, alignment: .leading)
    }
}
