import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weeksalive/data/backup/backup_service.dart';
import 'package:weeksalive/data/day/app_database.dart';
import 'package:weeksalive/domain/backup/backup_manifest.dart';

/// One device: a database, preferences and a documents folder.
class _Device {
  _Device(this.root, this.preferences)
    : database = AppDatabase(NativeDatabase.memory());

  final Directory root;
  final SharedPreferences preferences;
  final AppDatabase database;

  Directory get documents => Directory(p.join(root.path, 'documents'));
  Directory get temporary => Directory(p.join(root.path, 'tmp'));

  late final BackupService service = BackupService(
    database: database,
    preferences: preferences,
    documentsDirectory: () async => documents..createSync(recursive: true),
    temporaryDirectory: () async => temporary..createSync(recursive: true),
  );

  Future<void> addDay(
    DateTime date, {
    String text = '',
    List<String> images = const [],
  }) async {
    for (final image in images) {
      await File(p.join(documents.path, image)).create(recursive: true);
      await File(p.join(documents.path, image)).writeAsString('photo $image');
    }
    await database
        .into(database.days)
        .insert(
          DaysCompanion.insert(
            date: date,
            averageFeeling: const Value('good'),
            leaveATraceText: Value(text),
            leaveATraceImagePaths: Value(jsonEncode(images)),
            livingIntentionIds: const Value('["focus"]'),
            sizeLevel: const Value(2),
            savedAt: date.add(const Duration(hours: 20)),
          ),
        );
  }

  Future<List<Day>> days() => (database.select(
    database.days,
  )..orderBy([(t) => OrderingTerm(expression: t.date)])).get();
}

void main() {
  // Each simulated device opens its own in-memory database.
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late Directory sandbox;

  setUp(() async {
    sandbox = await Directory.systemTemp.createTemp('backup_service_test');
  });

  tearDown(() async {
    await sandbox.delete(recursive: true);
  });

  Future<_Device> device(
    String name, [
    Map<String, Object> preferences = const {},
  ]) async {
    SharedPreferences.setMockInitialValues(preferences);
    return _Device(
      Directory(p.join(sandbox.path, name)),
      await SharedPreferences.getInstance(),
    );
  }

  test(
    'an exported archive restores days, photos and preferences on another device',
    () async {
      final source = await device('source', {
        'user_key': '{"name":"Ada"}',
        'weekly_intents_selected': ['calm'],
        'app_icon_v1': 'gold',
      });
      await source.addDay(
        DateTime(2026, 9, 1),
        text: 'first',
        images: ['1.jpeg', '2.jpeg'],
      );
      await source.addDay(DateTime(2026, 9, 2), text: 'second');

      final archive = await source.service.exportArchive(
        now: DateTime(2026, 9, 3),
      );
      expect(p.basename(archive.path), 'WeeksAlive-backup-2026-09-03.zip');

      final target = await device('target');
      final manifest = await target.service.importArchive(archive);

      expect(manifest.dayCount, 2);
      expect(manifest.imageCount, 2);

      final days = await target.days();
      expect(days.map((d) => d.date), [
        DateTime(2026, 9, 1),
        DateTime(2026, 9, 2),
      ]);
      expect(days.first.leaveATraceText, 'first');
      expect(days.first.averageFeeling, 'good');
      expect(days.first.livingIntentionIds, '["focus"]');
      expect(days.first.sizeLevel, 2);
      expect(days.first.savedAt, DateTime(2026, 9, 1, 20));
      expect(jsonDecode(days.first.leaveATraceImagePaths), [
        '1.jpeg',
        '2.jpeg',
      ]);
      expect(
        await File(p.join(target.documents.path, '1.jpeg')).readAsString(),
        'photo 1.jpeg',
      );

      expect(target.preferences.getString('user_key'), '{"name":"Ada"}');
      expect(target.preferences.getStringList('weekly_intents_selected'), [
        'calm',
      ]);
      // Device-bound settings are not part of a backup.
      expect(target.preferences.getString('app_icon_v1'), isNull);
    },
  );

  test('restoring keeps the days already recorded on the device', () async {
    final source = await device('source');
    await source.addDay(DateTime(2026, 9, 1), text: 'from backup');
    await source.addDay(DateTime(2026, 9, 2), text: 'from backup');
    final archive = await source.service.exportArchive();

    final target = await device('target');
    await target.addDay(DateTime(2026, 9, 2), text: 'recorded here');
    await target.addDay(DateTime(2026, 9, 5), text: 'recorded here');
    await target.service.importArchive(archive);

    final days = await target.days();
    expect(days.map((d) => (d.date.day, d.leaveATraceText)), [
      (1, 'from backup'),
      (2, 'recorded here'),
      (5, 'recorded here'),
    ]);
  });

  test('legacy absolute photo paths are backed up by file name', () async {
    final source = await device('source');
    await File(
      p.join(source.documents.path, 'old.jpeg'),
    ).create(recursive: true);
    await source.database
        .into(source.database.days)
        .insert(
          DaysCompanion.insert(
            date: DateTime(2026, 1, 1),
            leaveATraceImagePaths: Value(
              jsonEncode(['/var/mobile/Containers/Data/X/Documents/old.jpeg']),
            ),
            savedAt: DateTime(2026, 1, 1),
          ),
        );

    final snapshot = await source.service.createSnapshot();

    expect(snapshot.images.map((f) => p.basename(f.path)), ['old.jpeg']);
    final day = (snapshot.data['days'] as List).single as Map<String, dynamic>;
    expect(day['leaveATraceImages'], ['old.jpeg']);
  });

  test('a file that is not a backup is rejected', () async {
    final target = await device('target');
    final notAnArchive = File(p.join(sandbox.path, 'photo.zip'))
      ..writeAsStringSync('not a zip');

    await expectLater(
      target.service.importArchive(notAnArchive),
      throwsA(
        isA<BackupException>().having(
          (e) => e.error,
          'error',
          BackupError.invalidBackup,
        ),
      ),
    );
  });

  test('a backup from a newer format is rejected', () async {
    final target = await device('target');
    final folder = Directory(p.join(sandbox.path, 'future'))..createSync();
    File(p.join(folder.path, BackupService.manifestFileName)).writeAsStringSync(
      jsonEncode(
        BackupManifest(
          formatVersion: BackupManifest.currentFormatVersion + 1,
          createdAt: DateTime(2030),
          dayCount: 1,
          imageCount: 0,
        ).toJson(),
      ),
    );
    File(
      p.join(folder.path, BackupService.dataFileName),
    ).writeAsStringSync('{"days":[]}');

    await expectLater(
      target.service.restore(folder),
      throwsA(
        isA<BackupException>().having(
          (e) => e.error,
          'error',
          BackupError.unsupportedVersion,
        ),
      ),
    );
  });
}
