import Flutter
import StoreKit
import UIKit
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { registry in
      GeneratedPluginRegistrant.register(with: registry)
    }

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }

    GeneratedPluginRegistrant.register(with: self)

    // On a first launch the TikTok SDK only starts once onboarding has asked for
    // ATT, and it is the SDK that registers with SKAdNetwork. Registering here
    // keeps installs that quit before that step counted. It is the same call the
    // SDK makes on every start, and registering again has no effect.
    SKAdNetwork.registerAppForAdNetworkAttribution()

    if let controller = window?.rootViewController as? FlutterViewController {
      WallpaperPlugin.register(with: controller.registrar(forPlugin: "WallpaperPlugin")!)
      AppIconPlugin.register(with: controller.registrar(forPlugin: "AppIconPlugin")!)
      ICloudBackupPlugin.register(with: controller.registrar(forPlugin: "ICloudBackupPlugin")!)
      let demoRegistrar = controller.registrar(forPlugin: "DemoShortcutPlayer")!
      demoRegistrar.register(
        DemoShortcutPlayerFactory(messenger: demoRegistrar.messenger(), registrar: demoRegistrar),
        withId: "weeksalive/demo_shortcut_player"
      )
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
