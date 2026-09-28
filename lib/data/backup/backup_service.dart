import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weeksalive/data/day/app_database.dart';
import 'package:weeksalive/domain/backup/backup_manifest.dart';

/// A backup ready to be written somewhere: the two JSON documents plus the
/// day photos, which stay where they are so iCloud can copy only new ones.
class BackupSnapshot {
  final BackupManifest manifest;
  final Map<String, dynamic> data;
  final List<File> images;

  const BackupSnapshot({
    required this.manifest,
    required this.data,
    required this.images,
  });

  /// Writes `manifest.json` and `backup.json` into [directory].
  Future<void> writeDocuments(Directory directory) async {
    await directory.create(recursive: true);
    await File(
      p.join(directory.path, BackupService.manifestFileName),
    ).writeAsString(jsonEncode(manifest.toJson()));
    await File(
      p.join(directory.path, BackupService.dataFileName),
    ).writeAsString(jsonEncode(data));
  }
}

/// Builds and restores the one backup format shared by iCloud and the manual
/// export: `manifest.json`, `backup.json` (days and preferences) and an
/// `images/` folder.
///
/// Days are written as JSON rather than as a copy of the SQLite file so a
/// backup stays readable across schema versions.
class BackupService {
  static const manifestFileName = 'manifest.json';
  static const dataFileName = 'backup.json';
  static const imagesDirectoryName = 'images';

  /// What a user would miss after a reinstall. Device-bound settings (app
  /// icon, wallpaper, counters, install id) are deliberately left out.
  static const backedUpPreferenceKeys = [
    'user_key',
    'weekly_intents_list',
    'weekly_intents_selected',
    'weekly_intents_week',
    'weekly_summary_last_completed_week_key',
    'unlocked_rewards_v1',
    'app_theme',
    'theme_mode',
    'grid_motif_v1',
    'notification_slots',
  ];

  final AppDatabase _db;
  final SharedPreferences _preferences;
  final Future<Directory> Function() _documentsDirectory;
  final Future<Directory> Function() _temporaryDirectory;

  BackupService({
    required AppDatabase database,
    required SharedPreferences preferences,
    Future<Directory> Function()? documentsDirectory,
    Future<Directory> Function()? temporaryDirectory,
  }) : _db = database,
       _preferences = preferences,
       _documentsDirectory =
           documentsDirectory ?? getApplicationDocumentsDirectory,
       _temporaryDirectory = temporaryDirectory ?? getTemporaryDirectory;

  Future<BackupSnapshot> createSnapshot({DateTime? now}) async {
    final documents = await _documentsDirectory();
    final rows = await _db.select(_db.days).get();

    final images = <File>[];
    final days = <Map<String, dynamic>>[];
    for (final row in rows) {
      final fileNames = _decodeStringList(
        row.leaveATraceImagePaths,
      ).map(p.basename).toList();
      for (final name in fileNames) {
        final file = File(p.join(documents.path, name));
        if (await file.exists()) images.add(file);
      }
      days.add(_dayToJson(row, fileNames));
    }

    final manifest = BackupManifest(
      formatVersion: BackupManifest.currentFormatVersion,
      createdAt: now ?? DateTime.now(),
      dayCount: days.length,
      imageCount: images.length,
    );

    return BackupSnapshot(
      manifest: manifest,
      data: {
        'formatVersion': BackupManifest.currentFormatVersion,
        'days': days,
        'preferences': _readPreferences(),
      },
      images: images,
    );
  }

  /// Returns the manifest in [directory], or null when it holds no backup.
  Future<BackupManifest?> readManifest(Directory directory) async {
    final file = File(p.join(directory.path, manifestFileName));
    if (!await file.exists()) return null;
    try {
      return BackupManifest.fromJson(
        jsonDecode(await file.readAsString()) as Map<String, dynamic>,
      );
    } on Object {
      return null;
    }
  }

  /// Restores the backup found in [directory].
  ///
  /// Days are merged: a day that exists on this device is kept as is, every
  /// other day comes from the backup, so restoring never loses what was
  /// recorded since. Backed-up preferences replace the local ones.
  Future<BackupManifest> restore(Directory directory) async {
    final manifest = await readManifest(directory);
    final dataFile = File(p.join(directory.path, dataFileName));
    if (manifest == null || !await dataFile.exists()) {
      throw const BackupException(BackupError.invalidBackup);
    }
    if (!manifest.isSupported) {
      throw const BackupException(BackupError.unsupportedVersion);
    }

    final Map<String, dynamic> data;
    final List<DaysCompanion> days;
    try {
      data = jsonDecode(await dataFile.readAsString()) as Map<String, dynamic>;
      days = (data['days'] as List<dynamic>)
          .map((e) => _dayFromJson(e as Map<String, dynamic>))
          .toList();
    } on Object {
      throw const BackupException(BackupError.invalidBackup);
    }

    await _restoreImages(
      Directory(p.join(directory.path, imagesDirectoryName)),
    );

    await _db.transaction(() async {
      for (final day in days) {
        await _db.into(_db.days).insert(day, mode: InsertMode.insertOrIgnore);
      }
    });

    await _writePreferences(
      data['preferences'] as Map<String, dynamic>? ?? const {},
    );

    return manifest;
  }

  /// Writes a zip of the current data to the temporary directory, ready to be
  /// shared.
  Future<File> exportArchive({DateTime? now}) async {
    final date = now ?? DateTime.now();
    final snapshot = await createSnapshot(now: date);
    final temporary = await _temporaryDirectory();
    final staging = Directory(p.join(temporary.path, 'backup_export'));
    if (await staging.exists()) await staging.delete(recursive: true);

    await snapshot.writeDocuments(staging);

    final archive = File(p.join(temporary.path, archiveFileName(date)));
    if (await archive.exists()) await archive.delete();
    final encoder = ZipFileEncoder()..create(archive.path);
    await encoder.addFile(File(p.join(staging.path, manifestFileName)));
    await encoder.addFile(File(p.join(staging.path, dataFileName)));
    for (final image in snapshot.images) {
      await encoder.addFile(
        image,
        '$imagesDirectoryName/${p.basename(image.path)}',
      );
    }
    await encoder.close();
    await staging.delete(recursive: true);
    return archive;
  }

  /// Restores a zip produced by [exportArchive].
  Future<BackupManifest> importArchive(File archive) async {
    final temporary = await _temporaryDirectory();
    final staging = Directory(p.join(temporary.path, 'backup_import'));
    if (await staging.exists()) await staging.delete(recursive: true);

    try {
      try {
        await extractFileToDisk(archive.path, staging.path);
      } on Object {
        throw const BackupException(BackupError.invalidBackup);
      }
      return await restore(await _findBackupRoot(staging));
    } finally {
      if (await staging.exists()) await staging.delete(recursive: true);
    }
  }

  static String archiveFileName(DateTime date) {
    final day =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return 'WeeksAlive-backup-$day.zip';
  }

  /// Archives re-zipped by hand (e.g. from the Files app) often nest
  /// everything in a top-level folder.
  Future<Directory> _findBackupRoot(Directory extracted) async {
    // Nothing is extracted from a file that is not a zip.
    if (!await extracted.exists()) return extracted;
    if (await File(p.join(extracted.path, manifestFileName)).exists()) {
      return extracted;
    }
    await for (final entity in extracted.list()) {
      if (entity is Directory &&
          await File(p.join(entity.path, manifestFileName)).exists()) {
        return entity;
      }
    }
    return extracted;
  }

  Future<void> _restoreImages(Directory source) async {
    if (!await source.exists()) return;
    final documents = await _documentsDirectory();
    await for (final entity in source.list()) {
      if (entity is! File) continue;
      final destination = File(p.join(documents.path, p.basename(entity.path)));
      // Photo file names are unique timestamps: an existing file is the same photo.
      if (await destination.exists()) continue;
      await entity.copy(destination.path);
    }
  }

  Map<String, dynamic> _readPreferences() {
    final result = <String, dynamic>{};
    for (final key in backedUpPreferenceKeys) {
      final value = _preferences.get(key);
      if (value == null) continue;
      result[key] = switch (value) {
        final String v => {'type': 'string', 'value': v},
        final bool v => {'type': 'bool', 'value': v},
        final int v => {'type': 'int', 'value': v},
        final double v => {'type': 'double', 'value': v},
        final List<dynamic> v => {
          'type': 'stringList',
          'value': v.cast<String>(),
        },
        _ => null,
      };
    }
    result.removeWhere((_, value) => value == null);
    return result;
  }

  Future<void> _writePreferences(Map<String, dynamic> preferences) async {
    for (final MapEntry(:key, :value) in preferences.entries) {
      if (!backedUpPreferenceKeys.contains(key) ||
          value is! Map<String, dynamic>) {
        continue;
      }
      final raw = value['value'];
      switch (value['type']) {
        case 'string' when raw is String:
          await _preferences.setString(key, raw);
        case 'bool' when raw is bool:
          await _preferences.setBool(key, raw);
        case 'int' when raw is int:
          await _preferences.setInt(key, raw);
        case 'double' when raw is num:
          await _preferences.setDouble(key, raw.toDouble());
        case 'stringList' when raw is List:
          await _preferences.setStringList(key, raw.cast<String>());
      }
    }
  }

  Map<String, dynamic> _dayToJson(Day row, List<String> imageFileNames) => {
    'date': _formatDay(row.date),
    'averageFeeling': row.averageFeeling,
    'meaningScore': row.meaningScore,
    'hasNewExperience': row.hasNewExperience,
    'livingIntentionIds': _decodeStringList(row.livingIntentionIds),
    'leaveATraceText': row.leaveATraceText,
    'leaveATraceImages': imageFileNames,
    'sizeLevel': row.sizeLevel,
    'savedAt': row.savedAt.toUtc().toIso8601String(),
  };

  DaysCompanion _dayFromJson(Map<String, dynamic> json) {
    return DaysCompanion.insert(
      date: _parseDay(json['date'] as String),
      averageFeeling: Value(json['averageFeeling'] as String?),
      meaningScore: Value(json['meaningScore'] as String?),
      hasNewExperience: Value(json['hasNewExperience'] as bool?),
      livingIntentionIds: Value(
        jsonEncode(json['livingIntentionIds'] ?? const []),
      ),
      leaveATraceText: Value(json['leaveATraceText'] as String? ?? ''),
      leaveATraceImagePaths: Value(
        jsonEncode(json['leaveATraceImages'] ?? const []),
      ),
      sizeLevel: Value(json['sizeLevel'] as int? ?? 0),
      savedAt: DateTime.parse(json['savedAt'] as String).toLocal(),
    );
  }

  /// Days are keyed by their local midnight; a calendar date survives a
  /// restore on a device set to another time zone, a timestamp would not.
  static String _formatDay(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  static DateTime _parseDay(String value) {
    final parts = value.split('-').map(int.parse).toList();
    return DateTime(parts[0], parts[1], parts[2]);
  }

  static List<String> _decodeStringList(String raw) {
    try {
      return (jsonDecode(raw) as List<dynamic>).cast<String>();
    } on Object {
      return const [];
    }
  }
}
