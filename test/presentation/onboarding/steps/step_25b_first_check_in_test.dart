import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/presentation/day_form/day_form.dart';
import 'package:weeksalive/presentation/day_form/day_form_controller.dart';
import 'package:weeksalive/presentation/day_form/day_form_view_model.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_25b_first_check_in.dart';
import 'package:weeksalive/presentation/redux/analytics/analytics_actions.dart';
import 'package:weeksalive/presentation/redux/day/day_actions.dart';
import 'package:weeksalive/presentation/widgets/primary_button.dart';

import '../../../helpers/onboarding_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final harness = OnboardingHarness();
  setUpAll(harness.setUpAll);

  Future<void> pumpStep(WidgetTester tester) =>
      harness.pumpSteps(tester, const [Step25bFirstCheckIn(), NextStepMarker()]);

  PrimaryButton doneButton(WidgetTester tester) =>
      tester.widget<PrimaryButton>(find.widgetWithText(PrimaryButton, Strings.done));

  Finder byType(String name) => find.byWidgetPredicate((widget) => widget.runtimeType.toString() == name);

  testWidgets('starts an onboarding check-in without intentions or photos', (tester) async {
    await pumpStep(tester);

    expect(
      harness.dispatched.whereType<CheckInStartedAction>().single.source,
      Step25bFirstCheckIn.analyticsSource,
    );
    expect(find.text(Strings.livingIntentionsSectionTitle), findsNothing);
    expect(byType('_ImageMosaic'), findsNothing);
    expect(doneButton(tester).onPressed, isNull);
  });

  testWidgets('saves the check-in once a question is answered', (tester) async {
    await pumpStep(tester);

    await tester.tap(byType('_SquareChip').first);
    await tester.pumpAndSettle();
    expect(doneButton(tester).onPressed, isNotNull);

    await tester.tap(find.widgetWithText(PrimaryButton, Strings.done));
    await tester.pumpAndSettle();

    final saved = harness.dispatched.whereType<SaveDayAction>().single.entry;
    final today = normalizeDay(DateTime.now());
    expect(saved.date, anyOf(today, today.subtract(const Duration(days: 1))));
    expect(saved.averageFeeling, isNotNull);
    expect(find.text(NextStepMarker.text), findsOneWidget);
  });

  testWidgets('can be put off, which saves nothing and reports an abandon', (tester) async {
    await pumpStep(tester);

    await tester.tap(find.text(Strings.onboardingFirstCheckInLater));
    await tester.pumpAndSettle();

    expect(harness.dispatched.whereType<SaveDayAction>(), isEmpty);
    expect(harness.dispatched.whereType<CheckInAbandonedAction>(), hasLength(1));
    expect(find.text(NextStepMarker.text), findsOneWidget);
  });

  testWidgets('asks about yesterday as yesterday', (tester) async {
    final yesterday = normalizeDay(DateTime.now()).subtract(const Duration(days: 1));
    final form = DayFormController();
    addTearDown(form.dispose);

    await harness.pump(
      tester,
      Scaffold(
        body: SingleChildScrollView(
          child: DayFormContent(
            viewModel: const DayFormViewModel(dayCount: '1'),
            date: yesterday,
            controller: form,
            onSave: () {},
            allowPhotos: false,
          ),
        ),
      ),
    );

    expect(find.text(Strings.feelingSectionQuestionYesterday), findsOneWidget);
    expect(find.text(Strings.feelingSectionQuestion), findsNothing);
  });
}
