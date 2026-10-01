import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/domain/pro/free_plan.dart';

void main() {
  final now = DateTime(2026, 9, 30, 15);

  DateTime daysAgo(int days) => DateTime(2026, 9, 30 - days);

  group('canReadDay', () {
    test('covers today and the six days before', () {
      for (var i = 0; i < FreePlan.historyDays; i++) {
        expect(FreePlan.canReadDay(daysAgo(i), now), isTrue, reason: '$i days ago');
      }
    });

    test('locks days older than the window', () {
      expect(FreePlan.canReadDay(daysAgo(7), now), isFalse);
      expect(FreePlan.canReadDay(daysAgo(40), now), isFalse);
    });

    test('counts calendar days across a DST change', () {
      // Europe switches to winter time on 2026-10-25.
      final afterDst = DateTime(2026, 10, 31, 1);
      expect(FreePlan.canReadDay(DateTime(2026, 10, 25), afterDst), isTrue);
      expect(FreePlan.canReadDay(DateTime(2026, 10, 24), afterDst), isFalse);
    });
  });

  group('canOpenDayForm', () {
    test('allows today whether or not it is logged', () {
      expect(FreePlan.canOpenDayForm(date: now, hasEntry: false, now: now), isTrue);
      expect(FreePlan.canOpenDayForm(date: now, hasEntry: true, now: now), isTrue);
    });

    test('allows logging yesterday while its grace window is open', () {
      expect(FreePlan.canOpenDayForm(date: daysAgo(1), hasEntry: false, now: now), isTrue);
    });

    test('locks a missed day once its grace window has closed', () {
      expect(FreePlan.canOpenDayForm(date: daysAgo(2), hasEntry: false, now: now), isFalse);
      expect(FreePlan.canOpenDayForm(date: daysAgo(6), hasEntry: false, now: now), isFalse);
    });

    test('allows editing a logged day inside the history window', () {
      expect(FreePlan.canOpenDayForm(date: daysAgo(6), hasEntry: true, now: now), isTrue);
    });

    test('locks a logged day outside the history window', () {
      expect(FreePlan.canOpenDayForm(date: daysAgo(7), hasEntry: true, now: now), isFalse);
    });
  });
}
