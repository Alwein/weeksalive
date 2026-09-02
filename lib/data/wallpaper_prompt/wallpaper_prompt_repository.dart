import 'package:shared_preferences/shared_preferences.dart';
import 'package:weeksalive/data/wallpaper_prompt/wallpaper_prompt_store.dart';

class WallpaperPromptRepository implements WallpaperPromptStore {
  WallpaperPromptRepository({required SharedPreferences preferences}) : _preferences = preferences;

  final SharedPreferences _preferences;

  static const String _launchCountKey = 'wallpaper_prompt_launch_count';
  static const String _shownKey = 'wallpaper_prompt_shown';

  /// The launch on which the nudge becomes eligible (the second one).
  static const int triggerAtLaunch = 2;

  @override
  int get launchCount => _preferences.getInt(_launchCountKey) ?? 0;

  @override
  bool get hasBeenShown => _preferences.getBool(_shownKey) ?? false;

  @override
  Future<int> incrementLaunchCount() async {
    final next = launchCount + 1;
    await _preferences.setInt(_launchCountKey, next);
    return next;
  }

  @override
  Future<void> markShown() async {
    await _preferences.setBool(_shownKey, true);
  }
}
