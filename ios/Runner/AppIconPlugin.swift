import Flutter
import UIKit

/// Handles alternate app icon changes over `com.weeksalive/app_icon`.
public class AppIconPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "com.weeksalive/app_icon",
            binaryMessenger: registrar.messenger()
        )
        let instance = AppIconPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "supportsAlternateIcons":
            supportsAlternateIcons(result: result)
        case "setAlternateIconName":
            setAlternateIconName(call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func supportsAlternateIcons(result: @escaping FlutterResult) {
        guard #available(iOS 10.3, *) else {
            result(false)
            return
        }
        result(UIApplication.shared.supportsAlternateIcons)
    }

    private func setAlternateIconName(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard #available(iOS 10.3, *) else {
            result(FlutterError(
                code: "UNAVAILABLE",
                message: "Not supported on iOS versions below 10.3",
                details: nil
            ))
            return
        }

        let arguments = call.arguments as? [String: Any]
        let iconName = arguments?["iconName"] as? String

        DispatchQueue.main.async {
            UIApplication.shared.setAlternateIconName(iconName) { error in
                if let error {
                    result(FlutterError(
                        code: "FAILED",
                        message: error.localizedDescription,
                        details: nil
                    ))
                } else {
                    result(nil)
                }
            }
        }
    }
}
