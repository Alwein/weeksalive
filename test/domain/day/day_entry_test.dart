import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/domain/day/day.dart';
import 'package:weeksalive/domain/day/day_entry.dart';

void main() {
  group('dayScoreLevel', () {
    test('returns 0 when nothing is recorded', () {
      expect(dayScoreLevel(), 0);
    });

    test('returns 4 when every section is at its maximum', () {
      final level = dayScoreLevel(
        averageFeeling: AverageFeeling.values.last,
        meaningScore: MeaningScore.values.last,
        hasNewExperience: true,
        livingIntentionIds: const ['a'],
      );
      expect(level, 4);
    });

    test('stays within [0, 4]', () {
      for (final feeling in AverageFeeling.values) {
        for (final meaning in MeaningScore.values) {
          final level = dayScoreLevel(
            averageFeeling: feeling,
            meaningScore: meaning,
            hasNewExperience: true,
            livingIntentionIds: const ['a'],
          );
          expect(level, inInclusiveRange(0, 4));
        }
      }
    });

    test('a single full section yields a partial level', () {
      final level = dayScoreLevel(hasNewExperience: true);
      expect(level, greaterThan(0));
      expect(level, lessThan(4));
    });
  });

  group('computeStreak', () {
    final today = DateTime(2026, 6, 1);

    DateTime daysAgo(int n) => DateTime(2026, 6, 1).subtract(Duration(days: n));

    test('returns 0 when today has no entry', () {
      final dates = {daysAgo(1), daysAgo(2)};
      expect(computeStreak(dates, today), 0);
    });

    test('counts a single day', () {
      expect(computeStreak({today}, today), 1);
    });

    test('counts consecutive days ending today', () {
      final dates = {today, daysAgo(1), daysAgo(2)};
      expect(computeStreak(dates, today), 3);
    });

    test('stops at the first gap', () {
      final dates = {today, daysAgo(1), daysAgo(3)};
      expect(computeStreak(dates, today), 2);
    });

    test('ignores time components on the recorded dates', () {
      final dates = {DateTime(2026, 6, 1, 23, 59), DateTime(2026, 5, 31, 8, 0)};
      expect(computeStreak(dates, DateTime(2026, 6, 1, 12)), 2);
    });
  });

  group('DayEntry', () {
    test('round-trips through JSON', () {
      final entry = DayEntry(
        date: DateTime(2026, 6, 1),
        averageFeeling: AverageFeeling.values.first,
        meaningScore: MeaningScore.values.last,
        hasNewExperience: true,
        livingIntentionIds: const ['focus', 'rest'],
        leaveATrace: const LeaveATrace(text: 'a good day', imagePaths: ['/tmp/a.png']),
      );

      final restored = DayEntry.fromJson(entry.toJson());

      expect(restored.date, entry.date);
      expect(restored.averageFeeling, entry.averageFeeling);
      expect(restored.meaningScore, entry.meaningScore);
      expect(restored.hasNewExperience, entry.hasNewExperience);
      expect(restored.livingIntentionIds, entry.livingIntentionIds);
      expect(restored.leaveATrace.text, entry.leaveATrace.text);
      expect(restored.leaveATrace.imagePaths, entry.leaveATrace.imagePaths);
      expect(restored.sizeLevel, entry.sizeLevel);
    });

    test('normalizes the date to midnight', () {
      final entry = DayEntry(date: DateTime(2026, 6, 1, 14, 30));
      expect(entry.date, DateTime(2026, 6, 1));
    });
  });
}
