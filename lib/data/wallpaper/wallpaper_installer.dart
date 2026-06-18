import 'dart:io';

import 'package:flutter/services.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_grid_type.dart';

/// Which surface the wallpaper should be applied to (Android only; iOS sets
/// both via Shortcuts).
enum WallpaperTarget {
  home,
  lock,
  both;

  String get channelValue => name;
}

/// Outcome of a wallpaper install request.
enum WallpaperInstallStatus {
  /// Android: the wallpaper was applied directly.
  applied,

  /// iOS: the PNG was published (App Group). The user must finish the
  /// install via Shortcuts / Settings.
  published,

  /// The platform reported the operation could not be completed.
  failed,
}

/// Bridges to the native side to actually install / publish the rendered
/// wallpaper PNG. On Android it calls `WallpaperManager.setBitmap`; on iOS the
/// PNG is rendered into the shared App Group and surfaced to Shortcuts via the
/// "Get Wallpaper" App Intent (no public API can set the wallpaper directly on
/// iOS).
class WallpaperInstaller {
  WallpaperInstaller({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel('com.weeksalive/wallpaper');

  final MethodChannel _channel;

  /// Applies the PNG at [filePath] as the Android system wallpaper.
  Future<WallpaperInstallStatus> installAndroid({
    required String filePath,
    WallpaperTarget target = WallpaperTarget.both,
    WallpaperGridType? gridType,
  }) async {
    try {
      final ok = await _channel.invokeMethod<bool>('setWallpaper', <String, dynamic>{
        'path': filePath,
        'target': target.channelValue,
        if (gridType != null) 'gridType': gridType.storageKey,
      });
      return ok == true ? WallpaperInstallStatus.applied : WallpaperInstallStatus.failed;
    } on PlatformException {
      return WallpaperInstallStatus.failed;
    }
  }

  /// On iOS the wallpaper PNG is already rendered into the shared App Group
  /// container by [WallpaperRenderer]; the App Intent exposes it to Shortcuts
  /// via the "Get Wallpaper" App Intent. There is no native write to perform
  /// here, so we simply report the image is ready.
  Future<WallpaperInstallStatus> publishForShortcutsIOS({required String filePath}) async {
    final file = File(filePath);
    return file.existsSync() ? WallpaperInstallStatus.published : WallpaperInstallStatus.failed;
  }

  /// Opens the system Shortcuts app (iOS) so the user can create the wallpaper
  /// automation. No-op return value; failures are swallowed.
  Future<void> openShortcutsApp() async {
    try {
      await _channel.invokeMethod<void>('openShortcuts');
    } on PlatformException {
      // best effort
    }
  }

  /// Cancels the periodic WorkManager job that re-applies the wallpaper (Android
  /// only). No-op on other platforms.
  Future<bool> cancelSchedule() async {
    if (!Platform.isAndroid) return true;
    try {
      final ok = await _channel.invokeMethod<bool>('cancelWallpaperSchedule');
      return ok == true;
    } on PlatformException {
      return false;
    }
  }

  /// Platform-aware install: applies directly on Android, publishes on iOS.
  Future<WallpaperInstallStatus> install({
    required String filePath,
    required WallpaperGridType gridType,
    WallpaperTarget target = WallpaperTarget.both,
  }) async {
    if (Platform.isAndroid) {
      return installAndroid(filePath: filePath, target: target, gridType: gridType);
    }
    if (Platform.isIOS) {
      return publishForShortcutsIOS(filePath: filePath);
    }
    return WallpaperInstallStatus.failed;
  }
}
