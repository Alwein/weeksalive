import 'dart:io';

import 'package:flutter/services.dart';

/// Talks to `ICloudBackupPlugin.swift`, which owns every read and write in the
/// app's iCloud container so they go through `NSFileCoordinator`.
///
/// The container holds `manifest.json`, `backup.json` and `images/`, the
/// layout written by [BackupSnapshot.writeDocuments].
class ICloudBackupClient {
  static const _channel = MethodChannel('com.weeksalive/icloud_backup');

  const ICloudBackupClient();

  /// Whether the user is signed in to iCloud with iCloud Drive enabled for the
  /// app. Always false outside iOS.
  Future<bool> isAvailable() async {
    if (!Platform.isIOS) return false;
    try {
      return await _channel.invokeMethod<bool>('isAvailable') ?? false;
    } on PlatformException {
      return false;
    }
  }

  /// Copies `manifest.json` and `backup.json` from [documentsDirectory] into
  /// iCloud, uploads the [imagePaths] not already there and removes the
  /// photos no longer referenced.
  Future<void> upload({
    required String documentsDirectory,
    required List<String> imagePaths,
  }) {
    return _channel.invokeMethod<void>('upload', {
      'documentsDirectory': documentsDirectory,
      'imagePaths': imagePaths,
    });
  }

  /// Downloads the iCloud `manifest.json` into [destination]. Returns false
  /// when iCloud holds no backup.
  Future<bool> downloadManifest(String destination) async {
    return await _channel.invokeMethod<bool>('downloadManifest', {
          'destination': destination,
        }) ??
        false;
  }

  /// Downloads the whole backup into [destination]. Returns false when iCloud
  /// holds no backup.
  Future<bool> downloadBackup(String destination) async {
    return await _channel.invokeMethod<bool>('downloadBackup', {
          'destination': destination,
        }) ??
        false;
  }
}
