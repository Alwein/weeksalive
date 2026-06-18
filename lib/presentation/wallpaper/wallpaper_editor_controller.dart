import 'package:flutter/foundation.dart';
import 'package:weeksalive/core/styles/app_theme_id.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_background_mode.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_config.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_grid_tokens.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_grid_type.dart';

typedef WallpaperConfigPersistCallback = void Function(WallpaperConfig config, {bool reRender});

class WallpaperEditorController extends ChangeNotifier {
  WallpaperEditorController({
    required WallpaperConfig initialConfig,
    required WallpaperConfigPersistCallback onPersist,
  }) : _config = initialConfig,
       _savedConfig = initialConfig,
       _onPersist = onPersist;

  final WallpaperConfigPersistCallback _onPersist;

  WallpaperConfig _config;
  WallpaperConfig _savedConfig;
  bool _isDirty = false;

  WallpaperConfig get config => _config;
  bool get hasUnsavedChanges => _isDirty;

  AppThemeId get effectiveGridThemeId => resolveWallpaperThemeId(_config);

  void setGridType(WallpaperGridType gridType) {
    if (_config.gridType == gridType) return;
    _apply(_config.copyWith(gridType: gridType));
  }

  void setGridTheme(AppThemeId themeId) {
    if (_config.gridThemeId == themeId) return;
    _apply(
      _config.copyWith(
        gridThemeId: () => themeId,
        gridColorArgb: () => null,
        dark: switch (themeId) {
          AppThemeId.dark => true,
          AppThemeId.light => false,
          _ => _config.dark,
        },
      ),
    );
  }

  void setBackgroundImage(String fileName) {
    _apply(
      _config.copyWith(
        backgroundMode: WallpaperBackgroundMode.image,
        backgroundImagePath: () => fileName,
      ),
    );
  }

  void removeBackgroundImage() {
    if (_config.backgroundMode == WallpaperBackgroundMode.solid && _config.backgroundImagePath == null) {
      return;
    }
    _apply(
      _config.copyWith(
        backgroundMode: WallpaperBackgroundMode.solid,
        backgroundImagePath: () => null,
      ),
    );
  }

  void setBackgroundImageOpacity(double value) {
    if (_config.backgroundImageOpacity == value) return;
    _apply(_config.copyWith(backgroundImageOpacity: value));
  }

  void setBackgroundBlur(double value) {
    if (_config.backgroundBlur == value) return;
    _apply(_config.copyWith(backgroundBlur: value));
  }

  void setGridOpacity(double value) {
    if (_config.gridOpacity == value) return;
    _apply(_config.copyWith(gridOpacity: value));
  }

  void setGridScale(double value) {
    final clamped = value.clamp(WallpaperConfig.gridScaleMin, WallpaperConfig.gridScaleMax);
    if (_config.gridScale == clamped) return;
    _apply(_config.copyWith(gridScale: clamped));
  }

  void setGridVerticalOffset(double value) {
    final clamped = value.clamp(
      WallpaperConfig.gridVerticalOffsetMin,
      WallpaperConfig.gridVerticalOffsetMax,
    );
    if (_config.gridVerticalOffset == clamped) return;
    _apply(_config.copyWith(gridVerticalOffset: clamped));
  }

  void markSaved() {
    _savedConfig = _config;
    _isDirty = false;
    notifyListeners();
  }

  void syncFromStore(WallpaperConfig config) {
    _config = config;
    _savedConfig = config;
    _isDirty = false;
    notifyListeners();
  }

  void discardChanges() {
    _config = _savedConfig;
    _isDirty = false;
    _onPersist(_savedConfig, reRender: _savedConfig.enabled);
    notifyListeners();
  }

  void _apply(WallpaperConfig next, {bool persist = true}) {
    _config = next;
    _isDirty = true;
    // Preview is live in the editor; defer the heavy PNG render to install/save.
    if (persist) _onPersist(next, reRender: false);
    notifyListeners();
  }
}
