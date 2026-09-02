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

/// Dispatched from the home screen to let the middleware decide whether the
/// second-launch wallpaper setup nudge should be shown.
class CheckWallpaperPromptAction {
  const CheckWallpaperPromptAction();
}

/// The middleware decided the nudge should be shown; the home listener reacts.
class WallpaperPromptRequestedAction {
  const WallpaperPromptRequestedAction();
}

/// The nudge was closed. [accepted] is true when the user tapped the CTA that
/// opens the wallpaper editor, false when they dismissed it.
class WallpaperPromptResolvedAction {
  const WallpaperPromptResolvedAction({required this.accepted});

  final bool accepted;
}
