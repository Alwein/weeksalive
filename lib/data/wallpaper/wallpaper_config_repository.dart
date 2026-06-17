import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weeksalive/data/wallpaper/wallpaper_background_image_storage.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_config.dart';

class WallpaperConfigRepository {
  WallpaperConfigRepository({required SharedPreferences preferences}) : _preferences = preferences;

  final SharedPreferences _preferences;

  static const _configKey = 'wallpaper_config';

  WallpaperConfig getConfig() {
    final raw = _preferences.getString(_configKey);
    if (raw == null) return const WallpaperConfig();
    try {
      return _normalizeLoadedConfig(
        WallpaperConfig.fromJson(jsonDecode(raw) as Map<String, dynamic>),
      );
    } catch (_) {
      return const WallpaperConfig();
    }
  }

  WallpaperConfig _normalizeLoadedConfig(WallpaperConfig config) {
    final normalized = WallpaperBackgroundImageStorage.normalizeStoredValue(
      config.backgroundImagePath,
    );
    if (normalized == config.backgroundImagePath) return config;
    return config.copyWith(backgroundImagePath: () => normalized);
  }

  Future<void> setConfig(WallpaperConfig config) async {
    await _preferences.setString(_configKey, jsonEncode(config.toJson()));
  }
}
