import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/data/day/app_database.dart';
import 'package:weeksalive/data/day/day_repository.dart';
import 'package:weeksalive/domain/day/day.dart';
import 'package:weeksalive/domain/day/day_entry.dart';

void main() {
  group('DayRepository', () {
    late AppDatabase database;
    late DayRepository repository;

    setUp(() {
      database = AppDatabase(NativeDatabase.memory());
      repository = DayRepository(database: database);
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

    test('upsert overwrites an existing day', () async {
      await repository.upsert(DayEntry(date: DateTime(2026, 6, 1), hasNewExperience: false));
      await repository.upsert(DayEntry(date: DateTime(2026, 6, 1), hasNewExperience: true));

      final all = await repository.getAll();
      expect(all, hasLength(1));
      expect(all.single.hasNewExperience, isTrue);
    });

    test('matches a day regardless of time-of-day on the query', () async {
      await repository.upsert(DayEntry(date: DateTime(2026, 6, 1)));
      final stored = await repository.getByDate(DateTime(2026, 6, 1, 18, 45));
      expect(stored, isNotNull);
    });
  });
}
