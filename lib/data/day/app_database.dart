import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

/// The `days.date` key of calendar [day]: that day's midnight in UTC, so a row
/// names the same day whatever time zone the device reads it in.
DateTime dayKey(DateTime day) => DateTime.utc(day.year, day.month, day.day);

/// The calendar day stored under a `days.date` [key], at local midnight.
DateTime dayFromKey(DateTime key) {
  final utc = key.toUtc();
  return DateTime(utc.year, utc.month, utc.day);
}

///
class Days extends Table {
  /// See [dayKey].
  DateTimeColumn get date => dateTime()();
  TextColumn get averageFeeling => text().nullable()();
  TextColumn get meaningScore => text().nullable()();
  BoolColumn get hasNewExperience => boolean().nullable()();

  TextColumn get livingIntentionIds => text().withDefault(const Constant('[]'))();
  TextColumn get leaveATraceText => text().withDefault(const Constant(''))();

  TextColumn get leaveATraceImagePaths => text().withDefault(const Constant('[]'))();
  IntColumn get sizeLevel => integer().withDefault(const Constant(0))();
  DateTimeColumn get savedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {date};
}

@DriftDatabase(tables: [Days])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) await _keyDaysByCalendarDay();
    },
  );

  /// Schema 1 keyed a day by its local midnight at the time it was saved: once
  /// the device changed time zone, that instant could fall on another day.
  ///
  /// Rounding each key to the nearest local midnight recovers the day the user
  /// saved, as long as the device is now less than 12 hours away from where it
  /// was saved.
  Future<void> _keyDaysByCalendarDay() async {
    final rows = await select(days).get();
    final kept = <DateTime, Day>{};
    for (final row in rows) {
      final local = row.date.toLocal();
      final isLocalMidnight = local.hour == 0 && local.minute == 0;
      final key = dayKey(DateTime(local.year, local.month, local.day + (local.hour >= 12 ? 1 : 0)));
      // Editing a day saved in another time zone wrote a second row for it;
      // the one keyed at this zone's midnight is most likely the edit.
      if (!kept.containsKey(key) || isLocalMidnight) kept[key] = row;
    }
    await transaction(() async {
      await delete(days).go();
      for (final MapEntry(:key, :value) in kept.entries) {
        await into(days).insert(value.copyWith(date: key));
      }
    });
  }

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'weeksalive.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
