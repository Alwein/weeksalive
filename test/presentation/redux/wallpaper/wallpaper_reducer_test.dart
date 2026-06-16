import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_config.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_grid_type.dart';
import 'package:weeksalive/presentation/redux/wallpaper/wallpaper_actions.dart';
import 'package:weeksalive/presentation/redux/wallpaper/wallpaper_reducer.dart';
import 'package:weeksalive/presentation/redux/wallpaper/wallpaper_state.dart';

void main() {
  const initial = WallpaperState();

  test('WallpaperConfigLoadedAction updates config', () {
    const config = WallpaperConfig(enabled: true, gridType: WallpaperGridType.year);
    final next = wallpaperReducer(initial, const WallpaperConfigLoadedAction(config));
    expect(next.config, config);
  });

  test('SaveWallpaperConfigAction updates config', () {
    const config = WallpaperConfig(enabled: true);
    final next = wallpaperReducer(initial, const SaveWallpaperConfigAction(config));
    expect(next.config.enabled, true);
  });

  test('WallpaperInstallingAction toggles installing flag', () {
    final next = wallpaperReducer(initial, const WallpaperInstallingAction(true));
    expect(next.installing, true);
    expect(next.installSucceeded, isNull);
  });

  test('WallpaperInstallCompletedAction records success', () {
    final next = wallpaperReducer(initial, const WallpaperInstallCompletedAction(success: true));
    expect(next.installSucceeded, true);
  });
}
