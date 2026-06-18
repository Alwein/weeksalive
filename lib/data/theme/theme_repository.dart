import 'package:shared_preferences/shared_preferences.dart';
import 'package:weeksalive/core/styles/app_theme_id.dart';

class ThemeRepository {
  final SharedPreferences _preferences;

  ThemeRepository({required SharedPreferences preferences}) : _preferences = preferences;

  static const String _appThemeKey = 'app_theme';
  static const String _themeModeKey = 'theme_mode';

  Future<AppThemeId> getSelectedTheme() async {
    final value = _preferences.getString(_appThemeKey);
    if (value != null) {
      return _parseThemeId(value) ?? AppThemeId.system;
    }

    return _migrateLegacyThemeMode();
  }

  Future<void> setSelectedTheme(AppThemeId themeId) async {
    await _preferences.setString(_appThemeKey, themeId.storageKey);
  }

  Future<AppThemeId> _migrateLegacyThemeMode() async {
    final legacy = _preferences.getString(_themeModeKey);
    final migrated = switch (legacy) {
      'light' => AppThemeId.light,
      'dark' => AppThemeId.dark,
      _ => AppThemeId.system,
    };
    await setSelectedTheme(migrated);
    return migrated;
  }

  AppThemeId? _parseThemeId(String value) {
    for (final id in AppThemeId.all) {
      if (id.storageKey == value) return id;
    }
    return null;
  }
}
