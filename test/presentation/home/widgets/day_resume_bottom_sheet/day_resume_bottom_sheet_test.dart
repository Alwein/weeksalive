import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weeksalive/core/styles/app_theme_builder.dart';
import 'package:weeksalive/core/styles/app_theme_id.dart';
import 'package:weeksalive/domain/day/day.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/presentation/home/widgets/day_resume_bottom_sheet/day_resume_bottom_sheet.dart';
import 'package:weeksalive/presentation/redux/app_reducer.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/day/day_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  testWidgets(
    'swiping left and right changes the visible day and stops at today',
    (tester) async {
      final today = normalizeDay(DateTime.now());
      final yesterday = DateTime(today.year, today.month, today.day - 1);
      final dayBefore = DateTime(today.year, today.month, today.day - 2);
      final tomorrow = DateTime(today.year, today.month, today.day + 1);
      final recorded = [dayBefore, yesterday, today];
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.initial().copyWith(
          dayState: DayState(
            entries: {
              for (final date in recorded)
                date: DayEntry(
                  date: date,
                  leaveATrace: LeaveATrace(text: _marker(date)),
                ),
            },
          ),
        ),
      );
      final theme = AppThemeBuilder.build(AppThemeId.light).theme;

      await tester.pumpWidget(
        EasyLocalization(
          supportedLocales: const [Locale('en', 'US')],
          path: 'assets/translations',
          fallbackLocale: const Locale('en', 'US'),
          startLocale: const Locale('en', 'US'),
          child: Builder(
            builder: (context) {
              return StoreProvider<AppState>(
                store: store,
                child: MaterialApp(
                  locale: context.locale,
                  supportedLocales: context.supportedLocales,
                  localizationsDelegates: context.localizationDelegates,
                  theme: theme,
                  home: Scaffold(
                    body: Builder(
                      builder: (context) {
                        return TextButton(
                          onPressed: () => DayResumeBottomSheet.show(
                            context,
                            date: yesterday,
                          ),
                          child: const Text('open'),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('open'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(DayResumeBottomSheet), findsOneWidget);
      expect(_dayIsVisible(tester, yesterday), isTrue);
      expect(_dayIsVisible(tester, today), isFalse);

      await tester.drag(
        find.byType(DayResumeBottomSheet),
        const Offset(-420, 0),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(DayResumeBottomSheet), findsOneWidget);
      expect(_dayIsVisible(tester, today), isTrue);
      expect(_dayIsVisible(tester, yesterday), isFalse);

      await tester.drag(
        find.byType(DayResumeBottomSheet),
        const Offset(-420, 0),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(_dayIsVisible(tester, today), isTrue);
      expect(find.text('"${_marker(tomorrow)}"'), findsNothing);

      await tester.drag(
        find.byType(DayResumeBottomSheet),
        const Offset(420, 0),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(_dayIsVisible(tester, yesterday), isTrue);
      expect(_dayIsVisible(tester, today), isFalse);
    },
  );
}

String _marker(DateTime date) => '${date.year}-${date.month}-${date.day}';

bool _dayIsVisible(WidgetTester tester, DateTime date) {
  final finder = find.text('"${_marker(date)}"');
  if (finder.evaluate().isEmpty) return false;
  final sheet = tester.getRect(find.byType(DayResumeBottomSheet));
  return sheet.overlaps(tester.getRect(finder));
}
