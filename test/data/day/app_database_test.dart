import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:weeksalive/data/day/app_database.dart';

void main() {
  // The migration test opens the same file twice, one database at a time.
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('dayKey', () {
    test('is the midnight in UTC of the calendar day', () {
      expect(dayKey(DateTime(2026, 10, 27, 23, 30)), DateTime.utc(2026, 10, 27));
    });

    test('round-trips to the local midnight of the same day', () {
      expect(dayFromKey(dayKey(DateTime(2026, 10, 25))), DateTime(2026, 10, 25));
    });
  });

  group('migration from schema 1', () {
    late Directory sandbox;
    late File file;

    setUp(() async {
      sandbox = await Directory.systemTemp.createTemp('app_database_test');
      file = File(p.join(sandbox.path, 'weeksalive.sqlite'));
    });

    tearDown(() async {
      await sandbox.delete(recursive: true);
    });

    /// Writes rows the way schema 1 did, keyed by a local midnight instant,
    /// then marks the file as schema 1.
    Future<void> givenSchema1Rows(Map<DateTime, String> textByKey) async {
      final database = AppDatabase(NativeDatabase(file));
      for (final MapEntry(:key, :value) in textByKey.entries) {
        await database
            .into(database.days)
            .insert(
              DaysCompanion.insert(
                date: key,
                leaveATraceText: Value(value),
                savedAt: DateTime.utc(2026, 10, 28, 12),
              ),
            );
      }
      await database.customStatement('PRAGMA user_version = 1');
      await database.close();
    }

    Future<Map<DateTime, String>> textByDayAfterUpgrade() async {
      final database = AppDatabase(NativeDatabase(file));
      final rows = await database.select(database.days).get();
      await database.close();
      for (final row in rows) {
        expect(row.date.isAtSameMomentAs(dayKey(row.date.toUtc())), isTrue, reason: '${row.date} is not a UTC midnight');
      }
      return {for (final row in rows) dayFromKey(row.date): row.leaveATraceText};
    }

    test('keeps the day of a row saved in this time zone', () async {
      await givenSchema1Rows({DateTime(2026, 10, 22): 'here'});

      expect(await textByDayAfterUpgrade(), {DateTime(2026, 10, 22): 'here'});
    });

    test('keeps the day of a row saved further east, which reads as the evening before', () async {
      // Tokyo's midnight is the afternoon before in Paris.
      await givenSchema1Rows({DateTime(2026, 10, 27).subtract(const Duration(hours: 8)): 'tokyo'});

      expect(await textByDayAfterUpgrade(), {DateTime(2026, 10, 27): 'tokyo'});
    });

    test('keeps the day of a row saved further west, which reads as the morning', () async {
      await givenSchema1Rows({DateTime(2026, 10, 20).add(const Duration(hours: 7)): 'paris'});

      expect(await textByDayAfterUpgrade(), {DateTime(2026, 10, 20): 'paris'});
    });

    test('keeps the row saved in this time zone when a day was saved twice', () async {
      await givenSchema1Rows({
        DateTime(2026, 10, 23).add(const Duration(hours: 7)): 'saved in another zone',
        DateTime(2026, 10, 23): 'edited here',
      });

      expect(await textByDayAfterUpgrade(), {DateTime(2026, 10, 23): 'edited here'});
    });

    test('keeps every column of the row', () async {
      await givenSchema1Rows({DateTime(2026, 10, 22): 'note'});

      final database = AppDatabase(NativeDatabase(file));
      final row = await database.select(database.days).getSingle();
      await database.close();

      expect(row.leaveATraceText, 'note');
      expect(row.savedAt.isAtSameMomentAs(DateTime.utc(2026, 10, 28, 12)), isTrue);
    });
  });
}
