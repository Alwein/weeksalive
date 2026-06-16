import 'package:flutter/widgets.dart' show Brightness;
import 'package:weeksalive/core/styles/app_color_tokens.dart';
import 'package:weeksalive/core/styles/app_theme_id.dart';
import 'package:weeksalive/core/styles/themes/app_theme.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_config.dart';

/// Default wallpaper theme when none is stored (or when legacy `system` is stored).
const wallpaperDefaultThemeId = AppThemeId.dark;

/// Resolves the wallpaper theme id from [WallpaperConfig], falling back to [wallpaperDefaultThemeId].
AppThemeId resolveWallpaperThemeId(WallpaperConfig config) {
  return switch (config.gridThemeId) {
    null || AppThemeId.system => wallpaperDefaultThemeId,
    final id => id,
  };
}

/// Resolves the color tokens used to paint the wallpaper grid and solid background.
AppColorTokens resolveWallpaperGridTokens(WallpaperConfig config) {
  final themeId = resolveWallpaperThemeId(config);
  final brightness = switch (themeId) {
    AppThemeId.dark => Brightness.dark,
    AppThemeId.light => Brightness.light,
    _ => config.dark ? Brightness.dark : Brightness.light,
  };
  return AppThemes.resolveTokens(themeId, brightness);
}
