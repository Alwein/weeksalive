/// Persistence for the wallpaper setup nudge shown on the second app launch.
///
/// Split from the concrete repository so tests can supply a fake without
/// touching `SharedPreferences`.
abstract class WallpaperPromptStore {
  /// How many times the app has been launched so far (this launch included).
  int get launchCount;

  /// Whether the nudge has already been shown once (it is a one-time prompt).
  bool get hasBeenShown;

  /// Records the current launch and returns the new count.
  Future<int> incrementLaunchCount();

  /// Marks the nudge as shown so it never appears again.
  Future<void> markShown();
}
