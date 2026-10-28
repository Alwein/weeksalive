import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/data/day/app_database.dart';
import 'package:weeksalive/data/day/day_repository.dart';
import 'package:weeksalive/data/day/image_storage.dart';
import 'package:weeksalive/domain/day/day.dart';
import 'package:weeksalive/domain/day/day_entry.dart';

class _FakeImageStorage implements ImageStorage {
  final List<String> saved = [];
  final List<String> deleted = [];

  @override
  Future<String> save(String absolutePath) async {
    saved.add(absolutePath);
    return absolutePath.split('/').last;
  }

  @override
  Future<String> resolve(String fileName) async => '/tmp/$fileName';

  @override
  Future<void> delete(String fileName) async => deleted.add(fileName);
}

void main() {
  group('DayRepository', () {
    late AppDatabase database;
    late _FakeImageStorage imageStorage;
    late DayRepository repository;

    setUp(() async {
      database = AppDatabase(NativeDatabase.memory());
      imageStorage = _FakeImageStorage();
      repository = DayRepository(database: database, imageStorage: imageStorage);
    });

    tearDown(() async {
      await database.close();
    });

    test('returns an empty list when nothing is stored', () async {
      expect(await repository.getAll(), isEmpty);
    });

    test('upserts and reads back an entry', () async {
      final entry = DayEntry(
        date: DateTime(2026, 6, 1),
        averageFeeling: AverageFeeling.values.first,
        meaningScore: MeaningScore.values.last,
        hasNewExperience: true,
        livingIntentionIds: const ['focus'],
        leaveATrace: const LeaveATrace(text: 'note', imagePaths: ['/tmp/a.png']),
      );

      await repository.upsert(entry);

      final stored = await repository.getByDate(DateTime(2026, 6, 1));
      expect(stored, isNotNull);
      expect(stored!.averageFeeling, entry.averageFeeling);
      expect(stored.meaningScore, entry.meaningScore);
      expect(stored.hasNewExperience, isTrue);
      expect(stored.livingIntentionIds, ['focus']);
      expect(stored.leaveATrace.text, 'note');
      expect(stored.leaveATrace.imagePaths, ['/tmp/a.png']);
      expect(stored.sizeLevel, entry.sizeLevel);
    });

    test('upsert overwrites an existing day but keeps the original savedAt', () async {
      final firstSavedAt = DateTime(2026, 6, 1, 9);
      await repository.upsert(DayEntry(date: DateTime(2026, 6, 1), hasNewExperience: false, savedAt: firstSavedAt));
      await repository.upsert(DayEntry(date: DateTime(2026, 6, 1), hasNewExperience: true));

      final all = await repository.getAll();
      expect(all, hasLength(1));
      expect(all.single.hasNewExperience, isTrue);
      expect(all.single.savedAt, firstSavedAt);
    });

    test('matches a day regardless of time-of-day on the query', () async {
      await repository.upsert(DayEntry(date: DateTime(2026, 6, 1)));
      final stored = await repository.getByDate(DateTime(2026, 6, 1, 18, 45));
      expect(stored, isNotNull);
    });

    test('keys a day by its calendar date, not by an instant of the device time zone', () async {
      await repository.upsert(DayEntry(date: DateTime(2026, 10, 27, 21)));

      final row = await database.select(database.days).getSingle();
      expect(row.date.isAtSameMomentAs(DateTime.utc(2026, 10, 27)), isTrue);
      expect((await repository.getAll()).single.date, DateTime(2026, 10, 27));
    });

    test('keeps photos already saved instead of saving them again', () async {
      await repository.upsert(
        DayEntry(
          date: DateTime(2026, 6, 1),
          leaveATrace: const LeaveATrace(imagePaths: ['/picker/a.png']),
        ),
      );
      final stored = await repository.getByDate(DateTime(2026, 6, 1));

      await repository.upsert(stored!.copyWith(hasNewExperience: true));

      expect(imageStorage.saved, ['/picker/a.png']);
      expect(imageStorage.deleted, isEmpty);
      expect((await repository.getByDate(DateTime(2026, 6, 1)))!.leaveATrace.imagePaths, ['/tmp/a.png']);
    });

    test('deletes the files of photos removed from an entry', () async {
      await repository.upsert(
        DayEntry(
          date: DateTime(2026, 6, 1),
          leaveATrace: const LeaveATrace(imagePaths: ['/picker/a.png', '/picker/b.png']),
        ),
      );
      final stored = await repository.getByDate(DateTime(2026, 6, 1));

      await repository.upsert(
        stored!.copyWith(leaveATrace: stored.leaveATrace.copyWith(imagePaths: ['/tmp/b.png'])),
      );

      expect(imageStorage.deleted, ['a.png']);
      expect((await repository.getByDate(DateTime(2026, 6, 1)))!.leaveATrace.imagePaths, ['/tmp/b.png']);
    });

    test('deleting a day removes it and its photo files', () async {
      await repository.upsert(
        DayEntry(
          date: DateTime(2026, 6, 1),
          leaveATrace: const LeaveATrace(imagePaths: ['/picker/a.png', '/picker/b.png']),
        ),
      );

      await repository.delete(DateTime(2026, 6, 1, 18, 45));

      expect(await repository.getByDate(DateTime(2026, 6, 1)), isNull);
      expect(imageStorage.deleted, unorderedEquals(['a.png', 'b.png']));
    });

    test('leaves alone a photo stored as an absolute path by an older version', () async {
      await database
          .into(database.days)
          .insert(
            DaysCompanion.insert(
              date: dayKey(DateTime(2026, 6, 1)),
              savedAt: DateTime(2026, 6, 1, 9),
              leaveATraceImagePaths: const Value('["/legacy/a.png"]'),
            ),
          );

      await repository.delete(DateTime(2026, 6, 1));

      expect(await repository.getByDate(DateTime(2026, 6, 1)), isNull);
      expect(imageStorage.deleted, isEmpty);
    });
  });
}
