import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weeksalive/data/weekly_intent/weekly_intent_repository.dart';
import 'package:weeksalive/domain/weekly_intent/weekly_intent.dart';

void main() {
  late WeeklyIntentRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    repository = WeeklyIntentRepository(preferences: prefs);
  });

  group('WeeklyIntentRepository', () {
    group('intents', () {
      test('getIntents returns null when nothing is stored', () async {
        final result = await repository.getIntents();
        expect(result, isNull);
      });

      test('setIntents then getIntents returns the same list', () async {
        final intents = [
          const WeeklyIntent(id: 'a', label: 'EXPLORE'),
          WeeklyIntent(id: 'b', label: 'REST', lastSelectedAt: DateTime(2026, 5, 21)),
        ];

        await repository.setIntents(intents);
        final result = await repository.getIntents();

        expect(result, isNotNull);
        expect(result!.length, 2);
        expect(result[0].id, 'a');
        expect(result[0].label, 'EXPLORE');
        expect(result[0].lastSelectedAt, isNull);
        expect(result[1].id, 'b');
        expect(result[1].lastSelectedAt, DateTime(2026, 5, 21));
      });

      test('setIntents overwrites a previously stored list', () async {
        await repository.setIntents([const WeeklyIntent(id: 'a', label: 'EXPLORE')]);
        await repository.setIntents([const WeeklyIntent(id: 'b', label: 'REST')]);

        final result = await repository.getIntents();
        expect(result!.length, 1);
        expect(result.first.id, 'b');
      });
    });

    group('selection', () {
      test('getSelection returns an empty list when nothing is stored', () async {
        final result = await repository.getSelection();
        expect(result, isEmpty);
      });

      test('setSelection then getSelection returns the same ids', () async {
        await repository.setSelection(['a', 'b', 'c']);
        final result = await repository.getSelection();
        expect(result, ['a', 'b', 'c']);
      });

      test('setSelection overwrites a previously stored selection', () async {
        await repository.setSelection(['a', 'b']);
        await repository.setSelection(['c']);

        final result = await repository.getSelection();
        expect(result, ['c']);
      });
    });

    group('weekKey', () {
      test('getWeekKey returns null when nothing is stored', () async {
        final result = await repository.getWeekKey();
        expect(result, isNull);
      });

      test('setWeekKey then getWeekKey returns the same value', () async {
        await repository.setWeekKey('2026-W21');
        final result = await repository.getWeekKey();
        expect(result, '2026-W21');
      });

      test('setWeekKey overwrites a previously stored value', () async {
        await repository.setWeekKey('2026-W20');
        await repository.setWeekKey('2026-W21');

        final result = await repository.getWeekKey();
        expect(result, '2026-W21');
      });
    });
  });
}
