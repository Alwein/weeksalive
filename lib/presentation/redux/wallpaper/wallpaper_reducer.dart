import 'package:weeksalive/presentation/redux/wallpaper/wallpaper_actions.dart';
import 'package:weeksalive/presentation/redux/wallpaper/wallpaper_state.dart';

WallpaperState wallpaperReducer(WallpaperState state, dynamic action) {
  if (action is WallpaperConfigLoadedAction) {
    return state.copyWith(config: action.config);
  }
  if (action is SaveWallpaperConfigAction) {
    return state.copyWith(config: action.config);
  }
  if (action is WallpaperInstallingAction) {
    return state.copyWith(
      installing: action.installing,
      installSucceeded: action.installing ? () => null : null,
    );
  }
  if (action is WallpaperInstallCompletedAction) {
    return state.copyWith(installSucceeded: () => action.success);
  }
  if (action is WallpaperPromptRequestedAction) {
    return state.copyWith(promptPending: true);
  }
  if (action is WallpaperPromptResolvedAction) {
    return state.copyWith(promptPending: false);
  }
  return state;
}
