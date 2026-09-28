import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weeksalive/data/backup/backup_service.dart';
import 'package:weeksalive/data/backup/icloud_backup_client.dart';
import 'package:weeksalive/domain/backup/backup_manifest.dart';

class BackupRepository {
  static const String _lastICloudBackupKey = 'backup_last_icloud_at';
  static const String _lastExportKey = 'backup_last_export_at';

  final BackupService _service;
  final ICloudBackupClient _iCloud;
  final SharedPreferences _preferences;
  final Future<Directory> Function() _temporaryDirectory;

  BackupRepository({
    required BackupService service,
    required SharedPreferences preferences,
    ICloudBackupClient iCloud = const ICloudBackupClient(),
    Future<Directory> Function()? temporaryDirectory,
  }) : _service = service,
       _iCloud = iCloud,
       _preferences = preferences,
       _temporaryDirectory = temporaryDirectory ?? getTemporaryDirectory;

  DateTime? get lastICloudBackupAt => _readDate(_lastICloudBackupKey);

  DateTime? get lastExportAt => _readDate(_lastExportKey);

  Future<bool> isICloudAvailable() => _iCloud.isAvailable();

  Future<BackupManifest> backupToICloud() async {
    if (!await _iCloud.isAvailable()) {
      throw const BackupException(BackupError.iCloudUnavailable);
    }
    final snapshot = await _service.createSnapshot();
    final staging = await _stagingDirectory('icloud_upload');
    try {
      await snapshot.writeDocuments(staging);
      await _iCloud.upload(
        documentsDirectory: staging.path,
        imagePaths: snapshot.images.map((file) => file.path).toList(),
      );
    } finally {
      await _delete(staging);
    }
    await _writeDate(_lastICloudBackupKey, snapshot.manifest.createdAt);
    return snapshot.manifest;
  }

  /// The manifest of the iCloud backup, or null when there is none or iCloud
  /// is unavailable.
  Future<BackupManifest?> findICloudBackup() async {
    if (!await _iCloud.isAvailable()) return null;
    final staging = await _stagingDirectory('icloud_manifest');
    try {
      if (!await _iCloud.downloadManifest(staging.path)) return null;
      return await _service.readManifest(staging);
    } on Object {
      return null;
    } finally {
      await _delete(staging);
    }
  }

  Future<BackupManifest> restoreFromICloud() async {
    if (!await _iCloud.isAvailable()) {
      throw const BackupException(BackupError.iCloudUnavailable);
    }
    final staging = await _stagingDirectory('icloud_download');
    try {
      if (!await _iCloud.downloadBackup(staging.path)) {
        throw const BackupException(BackupError.noICloudBackup);
      }
      final manifest = await _service.restore(staging);
      // The iCloud copy now matches this device; no need to push it back.
      await _writeDate(_lastICloudBackupKey, manifest.createdAt);
      return manifest;
    } finally {
      await _delete(staging);
    }
  }

  Future<File> exportArchive() => _service.exportArchive();

  Future<void> markExported() => _writeDate(_lastExportKey, DateTime.now());

  Future<BackupManifest> importArchive(File archive) =>
      _service.importArchive(archive);

  Future<Directory> _stagingDirectory(String name) async {
    final temporary = await _temporaryDirectory();
    final directory = Directory(p.join(temporary.path, name));
    await _delete(directory);
    await directory.create(recursive: true);
    return directory;
  }

  Future<void> _delete(Directory directory) async {
    if (await directory.exists()) await directory.delete(recursive: true);
  }

  DateTime? _readDate(String key) {
    final millis = _preferences.getInt(key);
    return millis == null ? null : DateTime.fromMillisecondsSinceEpoch(millis);
  }

  Future<void> _writeDate(String key, DateTime date) =>
      _preferences.setInt(key, date.millisecondsSinceEpoch);
}
