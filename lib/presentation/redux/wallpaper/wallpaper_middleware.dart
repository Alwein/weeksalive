import 'dart:ui' as ui;

import 'package:flutter/material.dart' show Brightness, Size;
import 'package:flutter/widgets.dart' show WidgetsBinding;
import 'package:redux/redux.dart';
import 'package:weeksalive/core/styles/app_color_tokens.dart';
import 'package:weeksalive/core/styles/themes/app_theme.dart';
import 'package:weeksalive/data/wallpaper/wallpaper_config_repository.dart';
import 'package:weeksalive/data/wallpaper/wallpaper_installer.dart';
import 'package:weeksalive/data/wallpaper/wallpaper_renderer.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_config.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_grid_data.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_actions.dart';
import 'package:weeksalive/presentation/redux/day/day_actions.dart';
import 'package:weeksalive/presentation/redux/theme/theme_actions.dart';
import 'package:weeksalive/presentation/redux/user/user_actions.dart';
import 'package:weeksalive/presentation/redux/user/user_state.dart';
import 'package:weeksalive/presentation/redux/wallpaper/wallpaper_actions.dart';

/// Owns the wallpaper lifecycle: loads the saved config on bootstrap, persists
/// changes, renders the PNG and applies/publishes it on install, and keeps the
/// image current when the underlying data changes.
class WallpaperMiddleware extends MiddlewareClass<AppState> {
  WallpaperMiddleware({
    required this.repository,
    WallpaperRenderer? renderer,
    WallpaperInstaller? installer,
  }) : renderer = renderer ?? WallpaperRenderer(),
       installer = installer ?? WallpaperInstaller();

  final WallpaperConfigRepository repository;
  final WallpaperRenderer renderer;
  final WallpaperInstaller installer;

  @override
  void call(Store<AppState> store, action, NextDispatcher next) {
    next(action);

    if (action is BootstrapAction) {
      _dispatchSafe(store, WallpaperConfigLoadedAction(repository.getConfig()));
      return;
    }

    if (action is SaveWallpaperConfigAction) {
      repository.setConfig(action.config);
      if (action.reRender) {
        _renderAndApply(store, install: false);
      }
      return;
    }

    if (action is InstallWallpaperAction) {
      _renderAndApply(store, install: true);
      return;
    }

    final dataChanged = action is SaveDayAction ||
        action is DeleteDayAction ||
        action is DaysLoadedAction ||
        action is UserLoadedAction;
    final themeChanged = action is AppThemeLoadedAction;
    if ((action is RefreshWallpaperAction || dataChanged || themeChanged) &&
        store.state.wallpaperState.config.enabled) {
      _renderAndApply(store, install: false);
    }
  }

  Future<void> _renderAndApply(Store<AppState> store, {required bool install}) async {
    final config = store.state.wallpaperState.config;
    var installSuccess = false;
    try {
      if (install) _dispatchSafe(store, const WallpaperInstallingAction(true));

      final data = WallpaperGridData.build(
        gridType: config.gridType,
        user: store.state.userState.userOrNull,
        entries: store.state.dayState.entries.values,
        at: DateTime.now(),
      );
      final tokens = _resolveTokens(store, config);
      final (size, pixelRatio) = _screenMetrics();

      final rendered = await renderer.render(
        config: config,
        data: data,
        tokens: tokens,
        logicalSize: size,
        pixelRatio: pixelRatio,
      );

      if (install) {
        final status = await installer.install(
          filePath: rendered.filePath,
          gridType: config.gridType,
        );
        installSuccess = status != WallpaperInstallStatus.failed;
        if (installSuccess) {
          final updated = config.copyWith(
            enabled: true,
            installedAtIso: () => DateTime.now().toIso8601String(),
          );
          await repository.setConfig(updated);
          _dispatchSafe(store, SaveWallpaperConfigAction(updated));
        }
      } else {
        await installer.install(filePath: rendered.filePath, gridType: config.gridType);
      }
    } catch (_) {
      installSuccess = false;
      // Wallpaper updates are best-effort; never break the app.
    } finally {
      if (install) {
        _dispatchSafe(store, const WallpaperInstallingAction(false));
        _dispatchSafe(store, WallpaperInstallCompletedAction(success: installSuccess));
      }
    }
  }

  AppColorTokens _resolveTokens(Store<AppState> store, WallpaperConfig config) {
    final selected = store.state.themeState.selectedTheme;
    return AppThemes.resolveTokens(selected, config.dark ? Brightness.dark : Brightness.light);
  }

  (Size, double) _screenMetrics() {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final ui.Size physical = view.physicalSize;
    final dpr = view.devicePixelRatio == 0 ? 1.0 : view.devicePixelRatio;
    final logical = physical.isEmpty ? const Size(390, 844) : Size(physical.width / dpr, physical.height / dpr);
    return (logical, dpr);
  }

  void _dispatchSafe(Store<AppState> store, dynamic action) {
    try {
      store.dispatch(action);
    } catch (_) {
      // Store torn down (e.g. in tests) during an async gap.
    }
  }
}
