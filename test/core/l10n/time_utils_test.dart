import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/core/l10n/time_utils.dart';
import 'package:weeksalive/core/styles/app_theme_builder.dart';
import 'package:weeksalive/core/styles/app_theme_id.dart';
import 'package:weeksalive/presentation/widgets/show_custom_time_picker.dart';

void main() {
  const evening = TimeOfDay(hour: 20, minute: 0);

  Future<void> pumpLocalizedApp(
    WidgetTester tester, {
    required Locale locale,
    required Widget home,
    bool alwaysUse24HourFormat = false,
  }) async {
    final theme = AppThemeBuilder.build(AppThemeId.light);
    await tester.pumpWidget(
      MaterialApp(
        locale: locale,
        theme: theme.theme,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('fr', 'FR'),
        ],
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: alwaysUse24HourFormat),
            child: child!,
          );
        },
        home: home,
      ),
    );
    await tester.pumpAndSettle();
  }

  group('TimeUtils.formatTime', () {
    testWidgets('shows 8:00 PM for en_US', (tester) async {
      late String formatted;
      await pumpLocalizedApp(
        tester,
        locale: const Locale('en', 'US'),
        home: Builder(
          builder: (context) {
            formatted = TimeUtils.formatTime(context, evening);
            return const SizedBox();
          },
        ),
      );

      expect(formatted, '8:00 PM');
    });

    testWidgets('shows 20:00 for fr_FR', (tester) async {
      late String formatted;
      await pumpLocalizedApp(
        tester,
        locale: const Locale('fr', 'FR'),
        home: Builder(
          builder: (context) {
            formatted = TimeUtils.formatTime(context, evening);
            return const SizedBox();
          },
        ),
      );

      expect(formatted, '20:00');
    });

    testWidgets('keeps 24-hour time when the device clock is set to 24 hours', (tester) async {
      late String formatted;
      await pumpLocalizedApp(
        tester,
        locale: const Locale('en', 'US'),
        alwaysUse24HourFormat: true,
        home: Builder(
          builder: (context) {
            formatted = TimeUtils.formatTime(context, evening);
            return const SizedBox();
          },
        ),
      );

      expect(formatted, '20:00');
    });
  });

  group('showCustomTimePicker', () {
    testWidgets('uses a 12-hour clock for en_US', (tester) async {
      await pumpLocalizedApp(
        tester,
        locale: const Locale('en', 'US'),
        home: Builder(
          builder: (context) {
            return TextButton(
              onPressed: () => showCustomTimePicker(context, initialTime: evening),
              child: const Text('open'),
            );
          },
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('PM'), findsWidgets);
      expect(find.text('AM'), findsWidgets);
    });

    testWidgets('uses a 24-hour clock for fr_FR', (tester) async {
      await pumpLocalizedApp(
        tester,
        locale: const Locale('fr', 'FR'),
        home: Builder(
          builder: (context) {
            return TextButton(
              onPressed: () => showCustomTimePicker(context, initialTime: evening),
              child: const Text('open'),
            );
          },
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('PM'), findsNothing);
      expect(find.text('20'), findsWidgets);
    });
  });
}
