import 'package:weeksalive/domain/wallpaper/wallpaper_config.dart';

class WallpaperState {
  const WallpaperState({
    this.config = const WallpaperConfig(),
    this.installing = false,
    this.installSucceeded,
  });

  final WallpaperConfig config;
  final bool installing;

  /// Set when an [InstallWallpaperAction] finishes; `null` while idle or in progress.
  final bool? installSucceeded;

  WallpaperState copyWith({
    WallpaperConfig? config,
    bool? installing,
    bool? Function()? installSucceeded,
  }) {
    return WallpaperState(
      config: config ?? this.config,
      installing: installing ?? this.installing,
      installSucceeded: installSucceeded != null ? installSucceeded() : this.installSucceeded,
    );
  }
}
