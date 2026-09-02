import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart' show Size;
import 'package:flutter/widgets.dart' show WidgetsBinding;
import 'package:redux/redux.dart';
import 'package:weeksalive/data/wallpaper/wallpaper_config_repository.dart';
import 'package:weeksalive/data/wallpaper/wallpaper_installer.dart';
import 'package:weeksalive/data/wallpaper/wallpaper_renderer.dart';
import 'package:weeksalive/data/wallpaper_prompt/wallpaper_prompt_repository.dart';
import 'package:weeksalive/data/wallpaper_prompt/wallpaper_prompt_store.dart';
import 'package:weeksalive/domain/day/day_entry.dart' as day_entry;
import 'package:weeksalive/domain/wallpaper/wallpaper_grid_data.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_grid_tokens.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_actions.dart';
import 'package:weeksalive/presentation/redux/day/day_actions.dart';
import 'package:weeksalive/presentation/redux/grid_motif/grid_motif_actions.dart';
import 'package:weeksalive/presentation/redux/push_notifications/push_notification_state.dart';
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
    required this.promptStore,
    WallpaperRenderer? renderer,
    WallpaperInstaller? installer,
  }) : renderer = renderer ?? WallpaperRenderer(),
       installer = installer ?? WallpaperInstaller();

  final WallpaperConfigRepository repository;
  final WallpaperPromptStore promptStore;
  final WallpaperRenderer renderer;
  final WallpaperInstaller installer;

  bool _launchCounted = false;

  static const _backgroundRenderDebounce = Duration(milliseconds: 300);

  int _renderGeneration = 0;
  Future<void>? _renderChain;

  @override
  void call(Store<AppState> store, action, NextDispatcher next) {
    next(action);

    if (action is BootstrapAction) {
      _dispatchSafe(store, WallpaperConfigLoadedAction(repository.getConfig()));
      _countLaunch();
      return;
    }

    if (action is CheckWallpaperPromptAction) {
      _maybeRequestPrompt(store);
      return;
    }

    if (action is WallpaperPromptResolvedAction) {
      _markPromptShown();
      return;
    }

    if (action is SaveWallpaperConfigAction) {
      repository.setConfig(action.config);
      if (action.reRender) {
        _enqueueRender(store, install: false);
      }
      return;
    }

    if (action is InstallWallpaperAction) {
      _enqueueRender(store, install: true);
      return;
    }

    if (action is DisableWallpaperAction) {
      _renderGeneration++;
      _disableWallpaper(store);
      return;
    }

    final dataChanged = action is SaveDayAction ||
        action is DeleteDayAction ||
        action is DaysLoadedAction ||
        action is UserLoadedAction;
    final themeChanged = action is AppThemeLoadedAction;
    final gridMotifChanged = action is GridMotifLoadedAction || action is SetGridMotifAction;
    if ((action is RefreshWallpaperAction || dataChanged || themeChanged || gridMotifChanged) &&
        store.state.wallpaperState.config.enabled) {
      _enqueueRender(store, install: false);
    }
  }

  /// Records the current launch, once per process.
  Future<void> _countLaunch() async {
    if (_launchCounted) return;
    _launchCounted = true;
    try {
      await promptStore.incrementLaunchCount();
    } catch (_) {
      // Best-effort; the nudge is not worth crashing over.
    }
  }

  Future<void> _markPromptShown() async {
    try {
      await promptStore.markShown();
    } catch (_) {
      // Best-effort.
    }
  }

  /// Requests the one-time wallpaper setup nudge when, on the second launch or
  /// later, the user still has no wallpaper and no other home sheet is queued.
  void _maybeRequestPrompt(Store<AppState> store) {
    if (promptStore.hasBeenShown) return;
    if (promptStore.launchCount < WallpaperPromptRepository.triggerAtLaunch) return;
    if (store.state.wallpaperState.config.enabled) return;
    if (store.state.wallpaperState.promptPending) return;

    // Yield to the more time-sensitive home sheets so nothing stacks.
    if (store.state.weeklySummaryState.pendingShow) return;
    if (store.state.pushNotificationState.pendingNavigation != PendingNotificationTarget.none) return;
    final recordedDays = store.state.dayState.entries.keys.toSet();
    if (day_entry.isYesterdayGracePeriod(recordedDays: recordedDays, now: DateTime.now())) return;

    _dispatchSafe(store, const WallpaperPromptRequestedAction());
  }

  void _enqueueRender(Store<AppState> store, {required bool install}) {
    final generation = ++_renderGeneration;
    _renderChain = (_renderChain ?? Future<void>.value()).then(
      (_) => _renderAndApply(store, install: install, generation: generation),
    );
  }

  Future<void> _disableWallpaper(Store<AppState> store) async {
    try {
      await installer.cancelSchedule();
      final config = store.state.wallpaperState.config.copyWith(enabled: false);
      await repository.setConfig(config);
      _dispatchSafe(store, SaveWallpaperConfigAction(config));
    } catch (_) {
      // Best-effort; never break the app.
    }
  }

  Future<void> _renderAndApply(
    Store<AppState> store, {
    required bool install,
    required int generation,
  }) async {
    if (!install) {
      await Future<void>.delayed(_backgroundRenderDebounce);
      if (generation != _renderGeneration) return;
    }

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
      final wallpaperTokens = resolveWallpaperGridTokens(config);
      final (size, pixelRatio) = _screenMetrics();

      final rendered = await renderer.render(
        config: config,
        data: data,
        tokens: wallpaperTokens,
        gridTokens: wallpaperTokens,
        gridMotif: store.state.gridMotifState.selectedMotif,
        logicalSize: size,
        pixelRatio: pixelRatio,
      );

      if (!install && generation != _renderGeneration) return;

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
      } else if (config.enabled) {
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
