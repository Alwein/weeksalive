import 'package:weeksalive/domain/wallpaper/wallpaper_config.dart';

class WallpaperState {
  const WallpaperState({
    this.config = const WallpaperConfig(),
    this.installing = false,
    this.installSucceeded,
    this.promptPending = false,
  });

  final WallpaperConfig config;
  final bool installing;

  /// Set when an [InstallWallpaperAction] finishes; `null` while idle or in progress.
  final bool? installSucceeded;

  /// True while the second-launch wallpaper setup nudge is waiting to be shown
  /// by the home screen listener.
  final bool promptPending;

  WallpaperState copyWith({
    WallpaperConfig? config,
    bool? installing,
    bool? Function()? installSucceeded,
    bool? promptPending,
  }) {
    return WallpaperState(
      config: config ?? this.config,
      installing: installing ?? this.installing,
      installSucceeded: installSucceeded != null ? installSucceeded() : this.installSucceeded,
      promptPending: promptPending ?? this.promptPending,
    );
  }
}
