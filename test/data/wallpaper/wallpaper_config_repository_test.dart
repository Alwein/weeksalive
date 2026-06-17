import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weeksalive/data/wallpaper/wallpaper_config_repository.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_background_mode.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_config.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_grid_type.dart';

void main() {
  late SharedPreferences preferences;
  late WallpaperConfigRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    preferences = await SharedPreferences.getInstance();
    repository = WallpaperConfigRepository(preferences: preferences);
  });

  test('returns default config when nothing stored', () {
    expect(repository.getConfig(), const WallpaperConfig());
  });

  test('round-trips config through JSON', () async {
    const config = WallpaperConfig(
      enabled: true,
      gridType: WallpaperGridType.year,
      backgroundMode: WallpaperBackgroundMode.image,
      gridColorArgb: 0xFF112233,
      backgroundImagePath: 'wallpaper_bg_1749200000000.jpeg',
      dark: true,
      installedAtIso: '2026-06-15T08:00:00.000',
    );

    await repository.setConfig(config);
    final loaded = repository.getConfig();

    expect(loaded.enabled, true);
    expect(loaded.gridType, WallpaperGridType.year);
    expect(loaded.backgroundMode, WallpaperBackgroundMode.image);
    expect(loaded.gridColorArgb, 0xFF112233);
    expect(loaded.backgroundImagePath, 'wallpaper_bg_1749200000000.jpeg');
    expect(loaded.dark, true);
    expect(loaded.installedAtIso, '2026-06-15T08:00:00.000');
  });

  test('normalizes legacy absolute image paths to file names on load', () async {
    const config = WallpaperConfig(
      enabled: true,
      backgroundMode: WallpaperBackgroundMode.image,
      backgroundImagePath: '/var/mobile/Documents/wallpaper_bg_123.jpeg',
    );

    await repository.setConfig(config);
    final loaded = repository.getConfig();

    expect(loaded.backgroundImagePath, 'wallpaper_bg_123.jpeg');
  });
}
