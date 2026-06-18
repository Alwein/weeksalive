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

  group('isStreakEligible', () {
    final monday = DateTime(2026, 6, 1);

    test('accepts a save on the calendar day', () {
      expect(
        isStreakEligible(entryDate: monday, savedAt: DateTime(2026, 6, 1, 20)),
        isTrue,
      );
    });

    test('accepts a save on the grace day after', () {
      expect(
        isStreakEligible(entryDate: monday, savedAt: DateTime(2026, 6, 2, 22)),
        isTrue,
      );
    });

    test('rejects a save after the grace window', () {
      expect(
        isStreakEligible(entryDate: monday, savedAt: DateTime(2026, 6, 3, 8)),
        isFalse,
      );
    });
  });

  group('isYesterdayGracePeriod', () {
    final today = DateTime(2026, 6, 3, 10);
    final yesterday = DateTime(2026, 6, 2);

    test('returns true when yesterday is missing and still in grace', () {
      expect(
        isYesterdayGracePeriod(recordedDays: {DateTime(2026, 6, 1)}, now: today),
        isTrue,
      );
    });

    test('returns false when the user has never logged a day', () {
      expect(
        isYesterdayGracePeriod(recordedDays: {}, now: today),
        isFalse,
      );
    });

    test('returns false when today is the only logged day', () {
      expect(
        isYesterdayGracePeriod(recordedDays: {today}, now: today),
        isFalse,
      );
    });

    test('returns false when yesterday is already logged', () {
      expect(
        isYesterdayGracePeriod(recordedDays: {yesterday}, now: today),
        isFalse,
      );
    });

    test('returns false once the missed day is no longer yesterday', () {
      expect(
        isYesterdayGracePeriod(
          recordedDays: {DateTime(2026, 6, 4), DateTime(2026, 6, 6)},
          now: DateTime(2026, 6, 7, 10),
        ),
        isFalse,
      );
    });
  });

  group('computeStreak', () {
    final monday = DateTime(2026, 6, 1);
    final tuesday = DateTime(2026, 6, 2);
    final wednesday = DateTime(2026, 6, 3);
    final thursday = DateTime(2026, 6, 4);
    final friday = DateTime(2026, 6, 5);

    DayEntry entry(DateTime date, DateTime savedAt) => DayEntry(
      date: date,
      savedAt: savedAt,
      hasNewExperience: true,
    );

    test('keeps yesterday streak while today is still in grace', () {
      final entries = [
        entry(monday, DateTime(2026, 6, 1, 12)),
        entry(tuesday, DateTime(2026, 6, 2, 12)),
      ];

      expect(computeStreak(entries, DateTime(2026, 6, 3, 12)), 2);
    });

    test('counts a single eligible day', () {
      expect(
        computeStreak([entry(monday, DateTime(2026, 6, 1, 12))], monday),
        1,
      );
    });

    test('counts consecutive eligible days ending on the reference day', () {
      final entries = [
        entry(monday, DateTime(2026, 6, 1, 12)),
        entry(tuesday, DateTime(2026, 6, 2, 12)),
        entry(wednesday, DateTime(2026, 6, 3, 12)),
      ];

      expect(computeStreak(entries, wednesday), 3);
    });

    test('stops at the first expired gap', () {
      final entries = [
        entry(monday, DateTime(2026, 6, 1, 12)),
        entry(tuesday, DateTime(2026, 6, 2, 12)),
        entry(wednesday, DateTime(2026, 6, 5, 12)),
      ];

      expect(computeStreak(entries, friday), 0);
    });

    test('ignores backfilled days saved outside their grace window', () {
      final entries = [
        entry(monday, DateTime(2026, 6, 1, 12)),
        entry(tuesday, DateTime(2026, 6, 2, 12)),
        entry(DateTime(2026, 5, 25), DateTime(2026, 6, 3, 12)),
      ];

      expect(computeStreak(entries, wednesday), 2);
    });

    test('resets when a missed day grace expires', () {
      final entries = [
        entry(monday, DateTime(2026, 6, 1, 12)),
        entry(tuesday, DateTime(2026, 6, 2, 12)),
      ];

      expect(computeStreak(entries, DateTime(2026, 6, 5, 10)), 0);
    });

    test('extends the streak when a grace-day save bridges the latest gap', () {
      final entries = [
        entry(monday, DateTime(2026, 6, 1, 12)),
        entry(tuesday, DateTime(2026, 6, 2, 12)),
        entry(wednesday, DateTime(2026, 6, 4, 22)),
      ];

      expect(computeStreak(entries, thursday), 3);
    });
  });

  group('computeBestStreak', () {
    DayEntry entry(DateTime date, DateTime savedAt) => DayEntry(
      date: date,
      savedAt: savedAt,
      hasNewExperience: true,
    );

    test('returns 0 when there are no eligible entries', () {
      expect(computeBestStreak([]), 0);
    });

    test('returns 1 for a single eligible day', () {
      expect(
        computeBestStreak([entry(DateTime(2026, 6, 1), DateTime(2026, 6, 1, 12))]),
        1,
      );
    });

    test('returns 3 for three consecutive eligible days', () {
      final entries = [
        entry(DateTime(2026, 6, 1), DateTime(2026, 6, 1, 12)),
        entry(DateTime(2026, 6, 2), DateTime(2026, 6, 2, 12)),
        entry(DateTime(2026, 6, 3), DateTime(2026, 6, 3, 12)),
      ];

      expect(computeBestStreak(entries), 3);
    });

    test('returns the longest of two disjoint runs', () {
      final entries = [
        entry(DateTime(2026, 6, 1), DateTime(2026, 6, 1, 12)),
        entry(DateTime(2026, 6, 2), DateTime(2026, 6, 2, 12)),
        entry(DateTime(2026, 6, 3), DateTime(2026, 6, 3, 12)),
        entry(DateTime(2026, 6, 4), DateTime(2026, 6, 4, 12)),
        entry(DateTime(2026, 6, 5), DateTime(2026, 6, 5, 12)),
        entry(DateTime(2026, 6, 10), DateTime(2026, 6, 10, 12)),
        entry(DateTime(2026, 6, 11), DateTime(2026, 6, 11, 12)),
        entry(DateTime(2026, 6, 12), DateTime(2026, 6, 12, 12)),
        entry(DateTime(2026, 6, 13), DateTime(2026, 6, 13, 12)),
        entry(DateTime(2026, 6, 14), DateTime(2026, 6, 14, 12)),
        entry(DateTime(2026, 6, 15), DateTime(2026, 6, 15, 12)),
        entry(DateTime(2026, 6, 16), DateTime(2026, 6, 16, 12)),
        entry(DateTime(2026, 6, 17), DateTime(2026, 6, 17, 12)),
      ];

      expect(computeBestStreak(entries), 8);
    });

    test('ignores days saved outside their grace window', () {
      final entries = [
        entry(DateTime(2026, 6, 1), DateTime(2026, 6, 1, 12)),
        entry(DateTime(2026, 6, 2), DateTime(2026, 6, 2, 12)),
        entry(DateTime(2026, 5, 20), DateTime(2026, 6, 3, 12)),
      ];

      expect(computeBestStreak(entries), 2);
    });
  });

  group('DayEntry', () {
    test('round-trips through JSON', () {
      final entry = DayEntry(
        date: DateTime(2026, 6, 1),
        savedAt: DateTime(2026, 6, 1, 18, 30),
        averageFeeling: AverageFeeling.values.first,
        meaningScore: MeaningScore.values.last,
        hasNewExperience: true,
        livingIntentionIds: const ['focus', 'rest'],
        leaveATrace: const LeaveATrace(text: 'a good day', imagePaths: ['/tmp/a.png']),
      );

      final restored = DayEntry.fromJson(entry.toJson());

      expect(restored.date, entry.date);
      expect(restored.savedAt, entry.savedAt);
      expect(restored.averageFeeling, entry.averageFeeling);
      expect(restored.meaningScore, entry.meaningScore);
      expect(restored.hasNewExperience, entry.hasNewExperience);
      expect(restored.livingIntentionIds, entry.livingIntentionIds);
      expect(restored.leaveATrace.text, entry.leaveATrace.text);
      expect(restored.leaveATrace.imagePaths, entry.leaveATrace.imagePaths);
      expect(restored.sizeLevel, entry.sizeLevel);
    });

    test('grandfathers missing savedAt to noon on the entry date', () {
      final restored = DayEntry.fromJson({
        'date': '2026-06-01T00:00:00.000',
        'hasNewExperience': true,
      });

      expect(restored.savedAt, DateTime(2026, 6, 1, 12));
      expect(
        isStreakEligible(entryDate: restored.date, savedAt: restored.savedAt),
        isTrue,
      );
    });

    test('normalizes the date to midnight', () {
      final entry = DayEntry(date: DateTime(2026, 6, 1, 14, 30));
      expect(entry.date, DateTime(2026, 6, 1));
    });
  });
}
