import 'package:flutter/widgets.dart' show Color, immutable;
import 'package:weeksalive/core/styles/app_theme_id.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_background_mode.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_grid_tokens.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_grid_type.dart';

/// User-tunable configuration for the auto-generated wallpaper.
///
/// Colors are stored as nullable ARGB ints: `null` means "fall back to the
/// active theme token", so a config created before any customization still
/// renders sensibly. Kept free of `BuildContext` so it can be persisted and
/// passed to the off-screen renderer / native side.
@immutable
class WallpaperConfig {
  const WallpaperConfig({
    this.enabled = false,
    this.gridType = WallpaperGridType.life,
    this.backgroundMode = WallpaperBackgroundMode.solid,
    this.gridColorArgb,
    this.gridThemeId = wallpaperDefaultThemeId,
    this.backgroundColorArgb,
    this.backgroundColorSecondaryArgb,
    this.backgroundImagePath,
    this.backgroundImageOpacity = 1.0,
    this.backgroundBlur = 0.0,
    this.gridOpacity = 1.0,
    this.gridScale = 1.0,
    this.gridVerticalOffset = 0.0,
    this.dark = true,
    this.installedAtIso,
  });

  /// Whether the user has set up and installed a wallpaper at least once.
  final bool enabled;

  final WallpaperGridType gridType;
  final WallpaperBackgroundMode backgroundMode;

  /// Override for the grid dots color. Null = active theme `content`.
  final int? gridColorArgb;

  /// Theme applied to the grid and solid background. Null/`system` resolve to [wallpaperDefaultThemeId].
  final AppThemeId? gridThemeId;

  /// Override for the (primary) background color. Null = active theme `bg`.
  final int? backgroundColorArgb;

  /// Second gradient stop, used only in [WallpaperBackgroundMode.gradient].
  /// Null = active theme `bgSoft`.
  final int? backgroundColorSecondaryArgb;

  /// File name of a user-picked background image in the app documents directory
  /// (when [backgroundMode] is [WallpaperBackgroundMode.image]). Legacy configs
  /// may still store an absolute path; resolve via [WallpaperBackgroundImageStorage].
  final String? backgroundImagePath;

  /// Dimming applied to [backgroundImagePath] over the black backdrop, in [0, 1].
  /// Lower values darken the image to improve grid legibility.
  final double backgroundImageOpacity;

  /// Gaussian blur sigma applied to the background image, in pixels.
  final double backgroundBlur;

  /// Opacity of the grid layer, in [0, 1].
  final double gridOpacity;

  /// Multiplier applied on top of the auto-fit scale. [gridScaleMin]–[gridScaleMax].
  final double gridScale;

  /// Vertical shift as a fraction of the canvas height. Negative moves the grid up.
  final double gridVerticalOffset;

  /// Whether the wallpaper should render with the dark palette of the theme.
  /// (Wallpapers are static images, so a single brightness must be committed.)
  final bool dark;

  /// ISO-8601 timestamp of the last successful install, for display.
  final String? installedAtIso;

  static const gridScaleMin = 0.5;
  static const gridScaleMax = 1.5;
  static const gridVerticalOffsetMin = -0.15;
  static const gridVerticalOffsetMax = 0.15;

  Color? get gridColor => gridColorArgb != null ? Color(gridColorArgb!) : null;

  Color? get backgroundColor => backgroundColorArgb != null ? Color(backgroundColorArgb!) : null;

  Color? get backgroundColorSecondary =>
      backgroundColorSecondaryArgb != null ? Color(backgroundColorSecondaryArgb!) : null;

  WallpaperConfig copyWith({
    bool? enabled,
    WallpaperGridType? gridType,
    WallpaperBackgroundMode? backgroundMode,
    int? Function()? gridColorArgb,
    AppThemeId? Function()? gridThemeId,
    int? Function()? backgroundColorArgb,
    int? Function()? backgroundColorSecondaryArgb,
    String? Function()? backgroundImagePath,
    double? backgroundImageOpacity,
    double? backgroundBlur,
    double? gridOpacity,
    double? gridScale,
    double? gridVerticalOffset,
    bool? dark,
    String? Function()? installedAtIso,
  }) {
    return WallpaperConfig(
      enabled: enabled ?? this.enabled,
      gridType: gridType ?? this.gridType,
      backgroundMode: backgroundMode ?? this.backgroundMode,
      gridColorArgb: gridColorArgb != null ? gridColorArgb() : this.gridColorArgb,
      gridThemeId: gridThemeId != null ? gridThemeId() : this.gridThemeId,
      backgroundColorArgb: backgroundColorArgb != null ? backgroundColorArgb() : this.backgroundColorArgb,
      backgroundColorSecondaryArgb: backgroundColorSecondaryArgb != null
          ? backgroundColorSecondaryArgb()
          : this.backgroundColorSecondaryArgb,
      backgroundImagePath: backgroundImagePath != null ? backgroundImagePath() : this.backgroundImagePath,
      backgroundImageOpacity: backgroundImageOpacity ?? this.backgroundImageOpacity,
      backgroundBlur: backgroundBlur ?? this.backgroundBlur,
      gridOpacity: gridOpacity ?? this.gridOpacity,
      gridScale: gridScale ?? this.gridScale,
      gridVerticalOffset: gridVerticalOffset ?? this.gridVerticalOffset,
      dark: dark ?? this.dark,
      installedAtIso: installedAtIso != null ? installedAtIso() : this.installedAtIso,
    );
  }

  Map<String, dynamic> toJson() => {
    'enabled': enabled,
    'gridType': gridType.storageKey,
    'backgroundMode': backgroundMode.storageKey,
    'gridColorArgb': gridColorArgb,
    'gridThemeId': gridThemeId?.storageKey,
    'backgroundColorArgb': backgroundColorArgb,
    'backgroundColorSecondaryArgb': backgroundColorSecondaryArgb,
    'backgroundImagePath': backgroundImagePath,
    'backgroundImageOpacity': backgroundImageOpacity,
    'backgroundBlur': backgroundBlur,
    'gridOpacity': gridOpacity,
    'gridScale': gridScale,
    'gridVerticalOffset': gridVerticalOffset,
    'dark': dark,
    'installedAtIso': installedAtIso,
  };

  static AppThemeId? _parseGridThemeId(String? key) {
    if (key == null) return null;
    for (final id in AppThemeId.all) {
      if (id.storageKey == key) return id;
    }
    return null;
  }

  factory WallpaperConfig.fromJson(Map<String, dynamic> json) {
    return WallpaperConfig(
      enabled: json['enabled'] as bool? ?? false,
      gridType: WallpaperGridType.fromStorageKey(json['gridType'] as String?),
      backgroundMode: WallpaperBackgroundMode.fromStorageKey(json['backgroundMode'] as String?),
      gridColorArgb: json['gridColorArgb'] as int?,
      gridThemeId: _parseGridThemeId(json['gridThemeId'] as String?) ?? wallpaperDefaultThemeId,
      backgroundColorArgb: json['backgroundColorArgb'] as int?,
      backgroundColorSecondaryArgb: json['backgroundColorSecondaryArgb'] as int?,
      backgroundImagePath: json['backgroundImagePath'] as String?,
      backgroundImageOpacity: (json['backgroundImageOpacity'] as num?)?.toDouble() ?? 1.0,
      backgroundBlur: (json['backgroundBlur'] as num?)?.toDouble() ?? 0.0,
      gridOpacity: (json['gridOpacity'] as num?)?.toDouble() ?? 1.0,
      gridScale: (json['gridScale'] as num?)?.toDouble() ?? 1.0,
      gridVerticalOffset: (json['gridVerticalOffset'] as num?)?.toDouble() ?? 0.0,
      dark: json['dark'] as bool? ?? false,
      installedAtIso: json['installedAtIso'] as String?,
    );
  }
}
