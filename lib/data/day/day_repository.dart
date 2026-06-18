import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:weeksalive/data/day/app_database.dart';
import 'package:weeksalive/data/day/image_storage.dart';
import 'package:weeksalive/domain/day/day.dart';
import 'package:weeksalive/domain/day/day_entry.dart';

class DayRepository {
  final AppDatabase _db;
  final ImageStorage _imageStorage;

  DayRepository({required AppDatabase database, ImageStorage? imageStorage})
      : _db = database,
        _imageStorage = imageStorage ?? LocalImageStorage();

  Future<List<DayEntry>> getAll() async {
    final rows = await _db.select(_db.days).get();
    return Future.wait(rows.map(_toEntry));
  }

  Future<DayEntry?> getByDate(DateTime date) async {
    final normalized = normalizeDay(date);
    final query = _db.select(_db.days)..where((t) => t.date.equals(normalized));
    final row = await query.getSingleOrNull();
    return row == null ? null : _toEntry(row);
  }

  Future<void> upsert(DayEntry entry) async {
    final existing = await getByDate(entry.date);
    final savedFileNames = await _saveNewImages(entry.leaveATrace.imagePaths);
    final updatedEntry = entry.copyWith(
      savedAt: existing?.savedAt ?? entry.savedAt,
      leaveATrace: entry.leaveATrace.copyWith(imagePaths: savedFileNames),
    );
    await _db.into(_db.days).insertOnConflictUpdate(_toCompanion(updatedEntry));
  }

  Future<void> delete(DateTime date) async {
    final normalized = normalizeDay(date);
    await (_db.delete(_db.days)..where((t) => t.date.equals(normalized))).go();
  }

  /// Saves any new images (absolute paths) and returns the stable file name list.
  /// Already-saved file names (no path separator) are kept as-is.
  Future<List<String>> _saveNewImages(List<String> paths) async {
    return Future.wait(
      paths.map((path) async {
        if (_isFileName(path)) return path;
        return _imageStorage.save(path);
      }),
    );
  }

  /// A stored value is a bare file name (no directory separator).
  bool _isFileName(String value) => !value.contains('/');

  Future<DayEntry> _toEntry(Day row) async {
    final fileNames =
        (jsonDecode(row.leaveATraceImagePaths) as List<dynamic>).map((e) => e as String).toList();

    final resolvedPaths = await Future.wait(
      fileNames.map((name) async {
        if (_isFileName(name)) return _imageStorage.resolve(name);
        return name;
      }),
    );

    return DayEntry(
      date: row.date,
      savedAt: row.savedAt,
      averageFeeling: _enumByName(AverageFeeling.values, row.averageFeeling),
      meaningScore: _enumByName(MeaningScore.values, row.meaningScore),
      hasNewExperience: row.hasNewExperience,
      livingIntentionIds:
          (jsonDecode(row.livingIntentionIds) as List<dynamic>).map((e) => e as String).toList(),
      leaveATrace: LeaveATrace(
        text: row.leaveATraceText,
        imagePaths: resolvedPaths,
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
      savedAt: Value(entry.savedAt),
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
