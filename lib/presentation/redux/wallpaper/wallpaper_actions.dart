import 'package:weeksalive/domain/wallpaper/wallpaper_config.dart';

class WallpaperConfigLoadedAction {
  const WallpaperConfigLoadedAction(this.config);

  final WallpaperConfig config;
}

class SaveWallpaperConfigAction {
  const SaveWallpaperConfigAction(this.config, {this.reRender = false});

  final WallpaperConfig config;

  /// When true the middleware re-renders the PNG after persisting.
  final bool reRender;
}

class InstallWallpaperAction {
  const InstallWallpaperAction();
}

class DisableWallpaperAction {
  const DisableWallpaperAction();
}

class RefreshWallpaperAction {
  const RefreshWallpaperAction();
}

class WallpaperInstallingAction {
  const WallpaperInstallingAction(this.installing);

  final bool installing;
}

class WallpaperInstallCompletedAction {
  const WallpaperInstallCompletedAction({required this.success});

  final bool success;
}
