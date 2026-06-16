import Flutter
import UIKit

/// Handles the iOS side of the wallpaper feature over the
/// `com.weeksalive/wallpaper` MethodChannel.
///
/// iOS exposes no public API to set the wallpaper. The contract is:
///  - The app renders the wallpaper PNG into the shared App Group container.
///  - App Intents expose a "Get Wallpaper" action that returns that PNG so a
///    user-built Shortcut can chain it into the system `Set Wallpaper` action.
///  - `openShortcuts`: deep-link into the Shortcuts app so the user can build
///    that automation.
public class WallpaperPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "com.weeksalive/wallpaper",
            binaryMessenger: registrar.messenger()
        )
        let instance = WallpaperPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "openShortcuts":
            openShortcuts(result: result)
        case "setWallpaper", "publishToPhotos":
            result(false)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func openShortcuts(result: @escaping FlutterResult) {
        guard let url = URL(string: "shortcuts://") else {
            result(false)
            return
        }
        DispatchQueue.main.async {
            UIApplication.shared.open(url, options: [:]) { success in
                result(success)
            }
        }
    }
}
