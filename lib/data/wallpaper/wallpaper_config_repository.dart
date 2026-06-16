import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_config.dart';

class WallpaperConfigRepository {
  WallpaperConfigRepository({required SharedPreferences preferences}) : _preferences = preferences;

  final SharedPreferences _preferences;

  static const _configKey = 'wallpaper_config';

  WallpaperConfig getConfig() {
    final raw = _preferences.getString(_configKey);
    if (raw == null) return const WallpaperConfig();
    try {
      return WallpaperConfig.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return const WallpaperConfig();
    }
  }

  Future<void> setConfig(WallpaperConfig config) async {
    await _preferences.setString(_configKey, jsonEncode(config.toJson()));
  }
}
