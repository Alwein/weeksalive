import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
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
    final row = await _findRow(date);
    return row == null ? null : _toEntry(row);
  }

  /// Also deletes the files of the photos the entry no longer has.
  Future<void> upsert(DayEntry entry) async {
    final existing = await _findRow(entry.date);
    final fileNames = await Future.wait(entry.leaveATrace.imagePaths.map(_storedFileName));
    final updatedEntry = entry.copyWith(
      savedAt: existing?.savedAt ?? entry.savedAt,
      leaveATrace: entry.leaveATrace.copyWith(imagePaths: fileNames),
    );
    await _db.into(_db.days).insertOnConflictUpdate(_toCompanion(updatedEntry));
    if (existing != null) {
      await _deleteImages(_storedImages(existing).toSet().difference(fileNames.toSet()));
    }
  }

  /// Also deletes the day's photo files.
  Future<void> delete(DateTime date) async {
    final existing = await _findRow(date);
    if (existing == null) return;
    await (_db.delete(_db.days)..where((t) => t.date.equals(existing.date))).go();
    await _deleteImages(_storedImages(existing));
  }

  Future<Day?> _findRow(DateTime date) {
    final normalized = normalizeDay(date);
    return (_db.select(_db.days)..where((t) => t.date.equals(normalized))).getSingleOrNull();
  }

  /// The stable file name to store for [path]: an image picked from outside
  /// the app is saved first, while a saved one is kept as it is (entries read
  /// back hold it resolved to its absolute path).
  Future<String> _storedFileName(String path) async {
    if (_isFileName(path)) return path;
    final fileName = p.basename(path);
    if (await _imageStorage.resolve(fileName) == path) return fileName;
    return _imageStorage.save(path);
  }

  List<String> _storedImages(Day row) =>
      (jsonDecode(row.leaveATraceImagePaths) as List<dynamic>).map((e) => e as String).toList();

  /// Only bare file names point into the app's own storage; an absolute path
  /// stored by an older version may point anywhere and is left alone.
  Future<void> _deleteImages(Iterable<String> stored) =>
      Future.wait(stored.where(_isFileName).map(_imageStorage.delete));

  /// A stored value is a bare file name (no directory separator).
  bool _isFileName(String value) => !value.contains('/');

  Future<DayEntry> _toEntry(Day row) async {
    final resolvedPaths = await Future.wait(
      _storedImages(row).map((name) async {
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
