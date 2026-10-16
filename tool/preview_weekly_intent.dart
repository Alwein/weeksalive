// Temporary preview of the onboarding intentions step. Not part of the app.
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:weeksalive/core/styles/app_theme_builder.dart';
import 'package:weeksalive/core/styles/app_theme_id.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_page.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_25_weekly_intent.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_26_first_dot.dart';
import 'package:weeksalive/presentation/redux/app_reducer.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';

const _english = bool.fromEnvironment('EN');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  final store = Store<AppState>(appReducer, initialState: AppState.initial());
  final theme = AppThemeBuilder.build(AppThemeId.light);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('fr', 'FR')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      startLocale: _english ? const Locale('en', 'US') : const Locale('fr', 'FR'),
      child: Builder(
        builder: (context) => StoreProvider<AppState>(
          store: store,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            theme: theme.theme,
            home: const OnboardingPage(steps: [Step25WeeklyIntent(), Step26FirstDot()]),
          ),
        ),
      ),
    ),
  );
}
