import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/domain/day/day.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_form_controller.dart';

void main() {
  late OnboardingFormController controller;

  setUp(() => controller = OnboardingFormController(totalSteps: 3));
  tearDown(() => controller.dispose());

  group('preferredReminderTime', () {
    test('is the first enabled reminder', () {
      controller.setSlot1Time(const TimeOfDay(hour: 21, minute: 30));

      expect(controller.preferredReminderTime, const TimeOfDay(hour: 21, minute: 30));
    });

    test('falls back to the slot the user would pick when none is enabled', () {
      controller.toggleSlot1(false);
      controller.toggleSlot2(false);

      expect(controller.preferredReminderTime, controller.slot2.time);
    });
  });

  group('firstCheckInDay', () {
    setUp(() {
      controller.toggleSlot2(false);
      controller.setSlot1Time(const TimeOfDay(hour: 21, minute: 0));
    });

    test('looks back on yesterday before the reminder time', () {
      // Today is not over yet: tonight's reminder still comes for it.
      final day = controller.firstCheckInDay(DateTime(2026, 10, 13, 9, 15));

      expect(day, DateTime(2026, 10, 12));
    });

    test('is today from the reminder time on', () {
      expect(controller.firstCheckInDay(DateTime(2026, 10, 13, 21)), DateTime(2026, 10, 13));
      expect(controller.firstCheckInDay(DateTime(2026, 10, 13, 23, 59)), DateTime(2026, 10, 13));
    });

    test('crosses months and years', () {
      expect(controller.firstCheckInDay(DateTime(2026, 1, 1, 8)), DateTime(2025, 12, 31));
    });
  });

  group('first check-in', () {
    final day = DateTime(2026, 10, 12);

    test('records nothing until a question is answered', () {
      controller.openFirstCheckIn(day);

      expect(controller.recordFirstCheckIn(), isNull);
      expect(controller.firstCheckIn, isNull);
    });

    test('records the answers on the day it was opened for', () {
      controller.openFirstCheckIn(day).setAverageFeeling(AverageFeeling.good);

      final entry = controller.recordFirstCheckIn();

      expect(entry?.date, day);
      expect(entry?.averageFeeling, AverageFeeling.good);
      expect(controller.firstCheckIn, entry);
    });

    test('keeps the answers when the user comes back to the step', () {
      controller.openFirstCheckIn(day).setMeaningScore(MeaningScore.much);

      final reopened = controller.openFirstCheckIn(DateTime(2026, 10, 12, 18));

      expect(reopened.meaningScore, MeaningScore.much);
    });

    test('resumes an entry saved before', () {
      final form = controller.openFirstCheckIn(
        day,
        existingEntry: DayEntry(date: day, hasNewExperience: true),
      );

      expect(form.hasNewExperience, isTrue);
    });

    test('an answer refreshes the onboarding, so its button can enable', () {
      var notified = 0;
      controller.addListener(() => notified++);

      controller.openFirstCheckIn(day).setAverageFeeling(AverageFeeling.low);

      expect(notified, greaterThan(0));
    });
  });
}
