import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:weeksalive/data/day/app_database.dart';
import 'package:weeksalive/domain/day/day.dart';
import 'package:weeksalive/domain/day/day_entry.dart';

class DayRepository {
  final AppDatabase _db;

  DayRepository({required AppDatabase database}) : _db = database;

  Future<List<DayEntry>> getAll() async {
    final rows = await _db.select(_db.days).get();
    return rows.map(_toEntry).toList();
  }

  Future<DayEntry?> getByDate(DateTime date) async {
    final normalized = normalizeDay(date);
    final query = _db.select(_db.days)..where((t) => t.date.equals(normalized));
    final row = await query.getSingleOrNull();
    return row == null ? null : _toEntry(row);
  }

  Future<void> upsert(DayEntry entry) async {
    await _db.into(_db.days).insertOnConflictUpdate(_toCompanion(entry));
  }

  Future<void> delete(DateTime date) async {
    final normalized = normalizeDay(date);
    await (_db.delete(_db.days)..where((t) => t.date.equals(normalized))).go();
  }

  DayEntry _toEntry(Day row) {
    return DayEntry(
      date: row.date,
      averageFeeling: _enumByName(AverageFeeling.values, row.averageFeeling),
      meaningScore: _enumByName(MeaningScore.values, row.meaningScore),
      hasNewExperience: row.hasNewExperience,
      livingIntentionIds: (jsonDecode(row.livingIntentionIds) as List<dynamic>).map((e) => e as String).toList(),
      leaveATrace: LeaveATrace(
        text: row.leaveATraceText,
        imagePaths: (jsonDecode(row.leaveATraceImagePaths) as List<dynamic>).map((e) => e as String).toList(),
      ),
      sizeLevel: row.sizeLevel,
    );
  }

  DaysCompanion _toCompanion(DayEntry entry) {
    return DaysCompanion(
      date: Value(entry.date),
      averageFeeling: Value(entry.averageFeeling?.name),
      meaningScore: Value(entry.meaningScore?.name),
      hasNewExperience: Value(entry.hasNewExperience),
      livingIntentionIds: Value(jsonEncode(entry.livingIntentionIds)),
      leaveATraceText: Value(entry.leaveATrace.text),
      leaveATraceImagePaths: Value(jsonEncode(entry.leaveATrace.imagePaths)),
      sizeLevel: Value(entry.sizeLevel),
    );
  }
}

T? _enumByName<T extends Enum>(List<T> values, String? name) {
  if (name == null) return null;
  for (final value in values) {
    if (value.name == name) return value;
  }
  return null;
}
