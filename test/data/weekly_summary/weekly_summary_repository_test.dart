import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weeksalive/data/weekly_summary/weekly_summary_repository.dart';

void main() {
  late WeeklySummaryRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    repository = WeeklySummaryRepository(preferences: prefs);
  });

  group('WeeklySummaryRepository', () {
    test('getLastCompletedWeekKey returns null when nothing is stored', () async {
      expect(await repository.getLastCompletedWeekKey(), isNull);
    });

    test('setLastCompletedWeekKey persists the value', () async {
      await repository.setLastCompletedWeekKey('2026-06-08');
      expect(await repository.getLastCompletedWeekKey(), '2026-06-08');
    });
  });
}
