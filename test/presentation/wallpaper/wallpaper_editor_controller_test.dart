import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/core/styles/app_theme_id.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_config.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_grid_type.dart';
import 'package:weeksalive/presentation/wallpaper/wallpaper_editor_controller.dart';

void main() {
  group('WallpaperEditorController', () {
    late List<({WallpaperConfig config, bool reRender})> persisted;

    WallpaperEditorController createController({WallpaperConfig? initialConfig}) {
      persisted = [];
      return WallpaperEditorController(
        initialConfig: initialConfig ?? const WallpaperConfig(),
        onPersist: (config, {reRender = false}) => persisted.add((config: config, reRender: reRender)),
      );
    }

    test('starts clean with initial config', () {
      const initial = WallpaperConfig(gridType: WallpaperGridType.year);
      final controller = createController(initialConfig: initial);

      expect(controller.config, initial);
      expect(controller.hasUnsavedChanges, isFalse);
      expect(persisted, isEmpty);
    });

    test('marks dirty and persists on grid type change', () {
      final controller = createController();

      controller.setGridType(WallpaperGridType.year);

      expect(controller.config.gridType, WallpaperGridType.year);
      expect(controller.hasUnsavedChanges, isTrue);
      expect(persisted, hasLength(1));
      expect(persisted.single.config.gridType, WallpaperGridType.year);
    });

    test('markSaved clears dirty state', () {
      final controller = createController();
      controller.setGridType(WallpaperGridType.year);

      controller.markSaved();

      expect(controller.hasUnsavedChanges, isFalse);
    });

    test('discardChanges restores saved config and persists revert', () {
      const initial = WallpaperConfig(gridType: WallpaperGridType.life);
      final controller = createController(initialConfig: initial);
      controller.setGridType(WallpaperGridType.year);
      controller.setGridTheme(AppThemeId.lavande);

      controller.discardChanges();

      expect(controller.config.gridType, WallpaperGridType.life);
      expect(controller.config.gridThemeId, initial.gridThemeId);
      expect(controller.hasUnsavedChanges, isFalse);
      expect(persisted.last.config.gridType, WallpaperGridType.life);
    });
  });
}
