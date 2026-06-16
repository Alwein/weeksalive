/// Constants for the iOS Shortcuts wallpaper setup flow.
abstract final class WallpaperConstants {
  /// Name of the shortcut the user creates in the Shortcuts app.
  static const shortcutName = 'WeeksAlive Wallpaper';

  /// URL scheme to run the shortcut for the in-app "Test" button.
  static String get runShortcutUrl =>
      'shortcuts://run-shortcut?name=${Uri.encodeComponent(shortcutName)}';
}
