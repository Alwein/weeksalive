import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeRepository {
  final SharedPreferences _preferences;

  ThemeRepository({required SharedPreferences preferences}) : _preferences = preferences;

  static const String _themeModeKey = 'theme_mode';

  Future<ThemeMode> getThemeMode() async {
    final value = _preferences.getString(_themeModeKey);
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    final value = switch (themeMode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await _preferences.setString(_themeModeKey, value);
  }
}
