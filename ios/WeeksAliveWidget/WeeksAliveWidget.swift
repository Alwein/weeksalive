import WidgetKit
import SwiftUI

// MARK: - Shared

private let appGroupId = "group.com.weeksalive"

/// The subset of theme color tokens the widgets draw with, decoded from the hex
/// strings the Flutter side resolves for the active theme.
private struct WidgetPalette: Decodable {
    let content: String
    let contentSoft: String
    let bg: String
    let bgSoft: String
    let strokeColor: String
    let accentOrange: String
}

private struct LifeGridPayload: Decodable {
    let totalYears: Int
    let livedYears: Int
    let totalWeeks: Int
    let livedWeeks: Int
    let light: WidgetPalette
    let dark: WidgetPalette
}

private struct YearGridPayload: Decodable {
    let year: Int
    let totalDays: Int
    let livedDays: Int
    /// Comma-separated per-day encoding (`-3` today, `-2` past, `-1` future,
    /// `0...4` recorded size level).
    let fillSizes: String
    let light: WidgetPalette
    let dark: WidgetPalette

    var sizes: [Int] {
        fillSizes.split(separator: ",").compactMap { Int($0) }
    }
}

/// Reads the JSON blob `home_widget` stored for [key] in the shared App Group
/// defaults and decodes it. Values are saved under the key prefixed with
/// `flutter.`.
private func decodePayload<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
    guard let defaults = UserDefaults(suiteName: appGroupId) else { return nil }
    let raw = defaults.string(forKey: "flutter.\(key)") ?? defaults.string(forKey: key)
    guard let raw, let data = raw.data(using: .utf8) else { return nil }
    return try? JSONDecoder().decode(type, from: data)
}

private extension Color {
    /// Decodes an `#AARRGGBB` (or `#RRGGBB`) hex string. Falls back to clear.
    init(hex: String) {
        var s = hex
        if s.hasPrefix("#") { s.removeFirst() }
        var value: UInt64 = 0
        guard Scanner(string: s).scanHexInt64(&value) else {
            self = .clear
            return
        }
        let a, r, g, b: Double
        if s.count == 8 {
            a = Double((value & 0xFF00_0000) >> 24) / 255
            r = Double((value & 0x00FF_0000) >> 16) / 255
            g = Double((value & 0x0000_FF00) >> 8) / 255
            b = Double(value & 0x0000_00FF) / 255
        } else {
            a = 1
            r = Double((value & 0xFF0000) >> 16) / 255
            g = Double((value & 0x00FF00) >> 8) / 255
            b = Double(value & 0x0000FF) / 255
        }
        self = Color(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
}

// MARK: - Grid math (mirrors the Flutter painters)

private struct GridLayout {
    let dotSize: CGFloat
    let maxRadius: CGFloat
    let gridWidth: CGFloat
    let gridHeight: CGFloat
    let columns: Int
    let spacing: CGFloat

    /// Sizes a [total]-cell grid of [columns] columns so the dots fill the full
    /// [availableWidth]: the dot size is derived from the width, and the grid
    /// spans the entire width regardless of height.
    init(
        availableWidth: CGFloat,
        total: Int,
        columns: Int,
        spacing: CGFloat
    ) {
        self.columns = columns
        self.spacing = spacing
        let cols = CGFloat(max(columns, 1))
        let rows = CGFloat(max(Int(ceil(Double(total) / Double(max(columns, 1)))), 1))

        let size = max((availableWidth - spacing * (cols - 1)) / cols, 0)

        dotSize = size
        maxRadius = size / 2
        gridWidth = cols * size + (cols - 1) * spacing
        gridHeight = rows * size + (rows - 1) * spacing
    }

    func center(index: Int) -> CGPoint {
        let col = index % columns
        let row = index / columns
        let stride = dotSize + spacing
        return CGPoint(
            x: CGFloat(col) * stride + maxRadius,
            y: CGFloat(row) * stride + maxRadius
        )
    }
}

// MARK: - Footer

/// Single-line footer aligned to the grid's edges: a primary [label] on the
/// left and a muted [value] on the right (e.g. `2026` … `165/365` or
/// `Life` … `31.7%`), spaced apart like a `Row` with space-between.
private struct WidgetFooter: View {
    let label: String
    let value: String
    let labelColor: Color
    let valueColor: Color

    var body: some View {
        HStack(spacing: 8) {
            Text(label)
                .foregroundColor(labelColor)
            Spacer(minLength: 8)
            Text(value)
                .foregroundColor(valueColor)
        }
        .font(.system(size: 13, weight: .regular))
        .lineLimit(1)
        .minimumScaleFactor(0.7)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Life Grid drawing

/// A grid of uniform dots: the first [filled] cells use [activeColor], the rest
/// [inactiveColor]. The column count is chosen so the dots fill the entire
/// available width while the rows still fit within the available height.
private struct LifeDotGrid: View {
    let total: Int
    let filled: Int
    let spacing: CGFloat
    let activeColor: Color
    let inactiveColor: Color

    /// Returns the fewest columns (largest dots) whose grid, sized to fill the
    /// full [width], still fits within [height]. The dots always span the width;
    /// adding columns only shrinks them, so we pick the smallest count that fits.
    private func bestColumns(width: CGFloat, height: CGFloat) -> Int {
        guard total > 0, width > 0, height > 0 else { return 1 }
        for columns in 1...total {
            let cols = CGFloat(columns)
            let rows = CGFloat(Int(ceil(Double(total) / Double(columns))))
            let dot = (width - spacing * (cols - 1)) / cols
            let gridHeight = rows * dot + (rows - 1) * spacing
            if gridHeight <= height {
                return columns
            }
        }
        return total
    }

    var body: some View {
        GeometryReader { proxy in
            let columns = bestColumns(width: proxy.size.width, height: proxy.size.height)
            let layout = GridLayout(
                availableWidth: proxy.size.width,
                total: total,
                columns: columns,
                spacing: spacing
            )
            Canvas { context, _ in
                guard total > 0, layout.dotSize > 0 else { return }
                let clampedFilled = max(0, min(filled, total))
                for i in 0..<total {
                    let c = layout.center(index: i)
                    let rect = CGRect(
                        x: c.x - layout.maxRadius,
                        y: c.y - layout.maxRadius,
                        width: layout.dotSize,
                        height: layout.dotSize
                    )
                    let color = i < clampedFilled ? activeColor : inactiveColor
                    context.fill(Path(ellipseIn: rect), with: .color(color))
                }
            }
            .frame(width: layout.gridWidth, height: layout.gridHeight)
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .topLeading)
        }
    }
}

private struct LifeGridWidgetContent: View {
    @Environment(\.widgetFamily) private var family
    @Environment(\.colorScheme) private var colorScheme

    /// Formats a fraction as a percentage with one decimal (e.g. `37.4%`).
    private func percent(_ filled: Int, _ total: Int) -> String {
        guard total > 0 else { return "0%" }
        let value = Double(filled) / Double(total) * 100
        return String(format: "%.1f%%", value)
    }

    var body: some View {
        if let payload = decodePayload(LifeGridPayload.self, forKey: "life_grid_json") {
            let palette = colorScheme == .dark ? payload.dark : payload.light
            let isSmall = family == .systemSmall
            let total = isSmall ? payload.totalYears : payload.totalWeeks
            let filled = isSmall ? payload.livedYears : payload.livedWeeks

            VStack(alignment: .leading, spacing: 8) {
                LifeDotGrid(
                    total: total,
                    filled: filled,
                    spacing: isSmall ? 3 : 1.5,
                    activeColor: Color(hex: palette.content),
                    inactiveColor: Color(hex: palette.bgSoft)
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                WidgetFooter(
                    label: "Life",
                    value: percent(filled, total),
                    labelColor: Color(hex: palette.contentSoft),
                    valueColor: Color(hex: palette.contentSoft)
                )
            }
            .padding(12)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: palette.bg))
        } else {
            Color(UIColor.systemBackground)
        }
    }
}

// MARK: - Year Grid drawing

private struct YearDotGrid: View {
    let totalDays: Int
    let sizes: [Int]
    let spacing: CGFloat
    let fillColor: Color
    let strokeColor: Color
    let pastEmptyColor: Color
    let todayEmptyColor: Color

    private static let minDotDiameter: CGFloat = 4
    private static let strokeWidth: CGFloat = 1

    /// Maps a recorded size level `[0, 4]` to a radius given the max cell radius.
    private func sizeRadius(_ level: Int, _ maxRadius: CGFloat) -> CGFloat {
        let minRadius = Self.minDotDiameter / 2
        if level <= 0 { return minRadius }
        if level >= 4 { return maxRadius }
        return minRadius + (maxRadius - minRadius) * (CGFloat(level) / 4)
    }

    /// Fewest columns (largest dots) whose width-filling grid still fits [height].
    private func bestColumns(width: CGFloat, height: CGFloat) -> Int {
        guard totalDays > 0, width > 0, height > 0 else { return 1 }
        for columns in 1...totalDays {
            let cols = CGFloat(columns)
            let rows = CGFloat(Int(ceil(Double(totalDays) / Double(columns))))
            let dot = (width - spacing * (cols - 1)) / cols
            let gridHeight = rows * dot + (rows - 1) * spacing
            if gridHeight <= height {
                return columns
            }
        }
        return totalDays
    }

    var body: some View {
        GeometryReader { proxy in
            let columns = bestColumns(width: proxy.size.width, height: proxy.size.height)
            let layout = GridLayout(
                availableWidth: proxy.size.width,
                total: totalDays,
                columns: columns,
                spacing: spacing
            )
            Canvas { context, _ in
                guard totalDays > 0, layout.dotSize > 0 else { return }
                let strokeRadius = layout.maxRadius - Self.strokeWidth / 2
                for i in 0..<totalDays {
                    let c = layout.center(index: i)
                    let level = i < sizes.count ? sizes[i] : 4

                    func circle(_ radius: CGFloat) -> Path {
                        Path(ellipseIn: CGRect(
                            x: c.x - radius, y: c.y - radius, width: radius * 2, height: radius * 2
                        ))
                    }

                    switch level {
                    case -1:
                        context.stroke(circle(strokeRadius), with: .color(strokeColor), lineWidth: Self.strokeWidth)
                    case -2:
                        context.fill(circle(layout.maxRadius), with: .color(pastEmptyColor))
                    case -3:
                        context.fill(circle(layout.maxRadius), with: .color(todayEmptyColor))
                    default:
                        let radius = sizeRadius(min(max(level, 0), 4), layout.maxRadius)
                        context.fill(circle(radius), with: .color(fillColor))
                    }
                }
            }
            .frame(width: layout.gridWidth, height: layout.gridHeight)
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .topLeading)
        }
    }
}

private struct YearGridWidgetContent: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        if let payload = decodePayload(YearGridPayload.self, forKey: "year_grid_json") {
            let palette = colorScheme == .dark ? payload.dark : payload.light

            VStack(alignment: .leading, spacing: 8) {
                YearDotGrid(
                    totalDays: payload.totalDays,
                    sizes: payload.sizes,
                    spacing: 3,
                    fillColor: Color(hex: palette.content),
                    strokeColor: Color(hex: palette.strokeColor),
                    pastEmptyColor: Color(hex: palette.bgSoft),
                    todayEmptyColor: Color(hex: palette.accentOrange)
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                WidgetFooter(
                    label: "\(payload.year)",
                    value: "\(payload.livedDays)/\(payload.totalDays)",
                    labelColor: Color(hex: palette.contentSoft),
                    valueColor: Color(hex: palette.contentSoft)
                )
            }
            .padding(12)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: palette.bg))
        } else {
            Color(UIColor.systemBackground)
        }
    }
}

// MARK: - Timeline

private struct SimpleEntry: TimelineEntry {
    let date: Date
}

private struct WidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        completion(SimpleEntry(date: Date()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        // Refresh roughly daily so the "today" marker advances; the app also
        // pushes reloads on data changes via WidgetCenter.
        let next = Calendar.current.date(byAdding: .hour, value: 6, to: Date()) ?? Date()
        completion(Timeline(entries: [SimpleEntry(date: Date())], policy: .after(next)))
    }
}

// MARK: - Life Grid Widget (small = 1 cell/year, large = 1 cell/week)

struct LifeGridWidget: Widget {
    let kind = "LifeGridWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WidgetProvider()) { _ in
            if #available(iOS 17.0, *) {
                LifeGridWidgetContent().containerBackground(.clear, for: .widget)
            } else {
                LifeGridWidgetContent()
            }
        }
        .configurationDisplayName("Grille de vie")
        .description("Votre vie en un coup d'oeil.")
        .supportedFamilies([.systemSmall, .systemLarge])
        .contentMarginsDisabledIfAvailable()
    }
}

// MARK: - Year Grid Widget (medium & large = current year)

struct YearGridWidget: Widget {
    let kind = "YearGridWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WidgetProvider()) { _ in
            if #available(iOS 17.0, *) {
                YearGridWidgetContent().containerBackground(.clear, for: .widget)
            } else {
                YearGridWidgetContent()
            }
        }
        .configurationDisplayName("Grille année")
        .description("Votre année en cours, jour par jour.")
        .supportedFamilies([.systemMedium, .systemLarge])
        .contentMarginsDisabledIfAvailable()
    }
}

// MARK: - Bundle

/// `contentMargins(.zero)` / `.contentMarginsDisabled()` only exist on iOS 17+.
/// WidgetKit adds a default content margin around the widget on iOS 17+; disable
/// it where available so our grid fills the frame. On iOS 16 this is a no-op.
extension WidgetConfiguration {
    func contentMarginsDisabledIfAvailable() -> some WidgetConfiguration {
        if #available(iOSApplicationExtension 17.0, *) {
            return self.contentMarginsDisabled()
        } else {
            return self
        }
    }
}

@main
struct WeeksAliveWidgetBundle: WidgetBundle {
    var body: some Widget {
        LifeGridWidget()
        YearGridWidget()
    }
}
