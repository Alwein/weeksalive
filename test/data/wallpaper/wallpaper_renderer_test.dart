import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/core/styles/app_theme_id.dart';
import 'package:weeksalive/core/styles/themes/app_theme.dart';
import 'package:weeksalive/data/wallpaper/wallpaper_renderer.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_config.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_grid_data.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_grid_type.dart';

import '../../fixtures/user_fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (call) async {
        if (call.method == 'getApplicationDocumentsDirectory') {
          return '/tmp';
        }
        return null;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('plugins.flutter.io/path_provider'), null);
  });

  test('render produces non-empty PNG bytes', () async {
    final renderer = WallpaperRenderer();
    final user = userFixture();
    final data = WallpaperGridData.build(
      gridType: WallpaperGridType.life,
      user: user,
      entries: const [],
      at: DateTime(2026, 6, 15),
    );
    final tokens = AppThemes.resolveTokens(
      AppThemeId.system,
      Brightness.light,
    );

    final result = await renderer.render(
      config: const WallpaperConfig(),
      data: data,
      tokens: tokens,
      logicalSize: const Size(390, 844),
      pixelRatio: 2.0,
    );

    expect(result.bytes.length, greaterThan(100));
    expect(result.filePath, endsWith('weeksalive_wallpaper.png'));
  });
}
