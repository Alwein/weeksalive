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
      expect(persisted.single.reRender, isFalse);
    });

    test('does not trigger wallpaper reRender while editing', () {
      final controller = createController(initialConfig: const WallpaperConfig(enabled: true));

      controller.setGridScale(1.2);
      controller.setGridVerticalOffset(-0.05);

      expect(persisted, hasLength(2));
      expect(persisted.every((entry) => entry.reRender == false), isTrue);
    });

    test('syncFromStore replaces config and clears dirty state', () {
      const initial = WallpaperConfig(enabled: true, gridType: WallpaperGridType.year);
      final controller = createController(initialConfig: initial);
      controller.setGridScale(1.2);

      controller.syncFromStore(const WallpaperConfig(enabled: false, gridType: WallpaperGridType.life));

      expect(controller.config.enabled, isFalse);
      expect(controller.config.gridType, WallpaperGridType.life);
      expect(controller.config.gridScale, 1.0);
      expect(controller.hasUnsavedChanges, isFalse);
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

    test('persists grid layout adjustments', () {
      final controller = createController();

      controller.setGridScale(1.3);
      controller.setGridVerticalOffset(-0.08);

      expect(controller.config.gridScale, 1.3);
      expect(controller.config.gridVerticalOffset, -0.08);
      expect(persisted, hasLength(2));
    });

    test('clamps grid layout values to allowed range', () {
      final controller = createController();

      controller.setGridScale(2.0);
      controller.setGridVerticalOffset(-1.0);

      expect(controller.config.gridScale, WallpaperConfig.gridScaleMax);
      expect(controller.config.gridVerticalOffset, WallpaperConfig.gridVerticalOffsetMin);
    });
  });
}
