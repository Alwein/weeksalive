import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weeksalive/domain/day/day.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/presentation/day_form/day_form.dart';
import 'package:weeksalive/presentation/day_form/day_form_controller.dart';
import 'package:weeksalive/presentation/day_form/day_form_view_model.dart';
import 'package:weeksalive/presentation/paywall/paywall_page.dart';
import 'package:weeksalive/presentation/redux/app_reducer.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';

import '../../helpers/localized_app.dart';

late Map<String, dynamic> _english;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
    _english = readEnglishTranslations();
  });

  testWidgets('the cross on a saved photo asks first, then removes that photo only', (tester) async {
    final semantics = tester.ensureSemantics();

    final date = DateTime(2026, 6, 1);
    final entry = DayEntry(
      date: date,
      averageFeeling: AverageFeeling.good,
      leaveATrace: const LeaveATrace(imagePaths: ['/photos/a.jpeg', '/photos/b.jpeg', '/photos/c.jpeg']),
    );
    final controller = DayFormController(initialEntry: entry);
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      localizedApp(
        english: _english,
        store: Store<AppState>(appReducer, initialState: AppState.initial()),
        home: Scaffold(
          body: SingleChildScrollView(
            child: DayFormContent(
              viewModel: DayFormViewModel(dayCount: '1', existingEntry: entry),
              date: date,
              controller: controller,
              onSave: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text(_english['leave_a_trace_section_title'] as String));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    final crosses = find.bySemanticsLabel('Remove photo');
    expect(crosses, findsNWidgets(3));

    await tester.tap(crosses.at(1));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Delete this photo?'), findsOneWidget);

    await tester.tap(find.text('Keep it'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Delete this photo?'), findsNothing);
    expect(controller.leaveATrace.imagePaths, hasLength(3));

    await tester.tap(crosses.at(1));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('Delete'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(controller.leaveATrace.imagePaths, ['/photos/a.jpeg', '/photos/c.jpeg']);
    // The tap did not reach the mosaic behind, which replaces every photo and
    // asks a free user to go Pro first.
    expect(find.byType(PaywallPage), findsNothing);
    expect(find.bySemanticsLabel('Remove photo'), findsNWidgets(2));
    semantics.dispose();
  });
}
