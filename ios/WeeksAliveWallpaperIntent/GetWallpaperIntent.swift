import AppIntents
import Foundation
import UniformTypeIdentifiers

/// App Group shared with the main app and the widget extension.
private let appGroupId = "group.com.weeksalive"

/// Must match `WallpaperRenderer.wallpaperFileName` on the Flutter side.
private let wallpaperFileName = "weeksalive_wallpaper.png"

/// Returns the latest wallpaper PNG that the app rendered into the shared App
/// Group container.
///
/// Implemented in this lightweight extension (not the Flutter Runner) so
/// Shortcuts automations can run while the host app is suspended or terminated.
struct GetWallpaperIntent: AppIntent {
    static var title: LocalizedStringResource = "Get Wallpaper"

    static var description = IntentDescription(
        "Returns the latest WeeksAlive wallpaper image so you can set it as your wallpaper."
    )

    static var openAppWhenRun: Bool = false

    func perform() async throws -> some IntentResult & ReturnsValue<IntentFile> {
        guard
            let container = FileManager.default.containerURL(
                forSecurityApplicationGroupIdentifier: appGroupId
            )
        else {
            throw GetWallpaperError.appGroupUnavailable
        }

        let fileURL = container.appendingPathComponent(wallpaperFileName)
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            throw GetWallpaperError.notRenderedYet
        }

        // Pass the file URL directly — avoids loading the full PNG into memory
        // and keeps the intent fast enough for background Shortcuts automations.
        let file = IntentFile(
            fileURL: fileURL,
            filename: wallpaperFileName,
            type: UTType.png
        )
        return .result(value: file)
    }
}

enum GetWallpaperError: Error, CustomLocalizedStringResourceConvertible {
    case appGroupUnavailable
    case notRenderedYet

    var localizedStringResource: LocalizedStringResource {
        switch self {
        case .appGroupUnavailable:
            return "WeeksAlive could not access its shared storage."
        case .notRenderedYet:
            return "No wallpaper has been generated yet. Open WeeksAlive and set up your wallpaper first."
        }
    }
}
