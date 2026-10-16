import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_25b_first_check_in.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_26_first_dot.dart';
import 'package:weeksalive/presentation/widgets/primary_button.dart';

import '../../../helpers/onboarding_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('nextCheckInAfterOnboarding', () {
    const reminder = TimeOfDay(hour: 20, minute: 0);

    test('is tomorrow once today is checked in', () {
      final now = DateTime(2026, 10, 16, 21);

      expect(
        nextCheckInAfterOnboarding(checkIn: DayEntry(date: now), now: now, reminder: reminder),
        NextCheckIn.tomorrowAtReminder,
      );
    });

    test('is tonight after a check-in on yesterday', () {
      final now = DateTime(2026, 10, 16, 9);

      expect(
        nextCheckInAfterOnboarding(checkIn: DayEntry(date: DateTime(2026, 10, 15)), now: now, reminder: reminder),
        NextCheckIn.todayAtReminder,
      );
    });

    test('is today without a time once the reminder has passed', () {
      expect(
        nextCheckInAfterOnboarding(checkIn: null, now: DateTime(2026, 10, 16, 22), reminder: reminder),
        NextCheckIn.today,
      );
      expect(
        nextCheckInAfterOnboarding(checkIn: null, now: DateTime(2026, 10, 16, 8), reminder: reminder),
        NextCheckIn.todayAtReminder,
      );
    });
  });

  group('step', () {
    final harness = OnboardingHarness();
    setUpAll(harness.setUpAll);

    Future<void> reachFirstDot(WidgetTester tester, {required bool checkIn}) async {
      await harness.pumpSteps(tester, const [Step25bFirstCheckIn(), Step26FirstDot()]);
      if (checkIn) {
        await tester.tap(find.byWidgetPredicate((w) => w.runtimeType.toString() == '_SquareChip').first);
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(PrimaryButton, Strings.done));
      } else {
        await tester.tap(find.text(Strings.onboardingFirstCheckInLater));
      }
      await tester.pumpAndSettle();
      // The dot appears once the page transition is over.
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
    }

    testWidgets('shows the day just checked in on the grid', (tester) async {
      await reachFirstDot(tester, checkIn: true);

      expect(find.text(Strings.onboardingFirstDotTitle), findsOneWidget);
      expect(
        find.text(Strings.onboardingFirstDotYesterday).evaluate().length +
            find.text(Strings.onboardingFirstDotToday).evaluate().length,
        greaterThanOrEqualTo(1),
      );
    });

    testWidgets('shows the slot still waiting after a skipped check-in', (tester) async {
      await reachFirstDot(tester, checkIn: false);

      expect(find.text(Strings.onboardingFirstDotTitleWaiting), findsOneWidget);
      expect(find.text(Strings.onboardingFirstDotYesterday), findsNothing);
    });
  });
}
