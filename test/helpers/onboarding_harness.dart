import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weeksalive/core/styles/app_theme_builder.dart';
import 'package:weeksalive/core/styles/app_theme_id.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_page.dart';
import 'package:weeksalive/presentation/redux/app_reducer.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';

/// Pumps onboarding screens with the real reducer, English texts and the app
/// theme, recording every dispatched action.
class OnboardingHarness {
  final List<Object?> dispatched = [];
  late Map<String, dynamic> _english;

  /// Call from `setUpAll`.
  Future<void> setUpAll() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
    _english = jsonDecode(File('assets/translations/en-US.json').readAsStringSync()) as Map<String, dynamic>;
  }

  Future<void> pumpSteps(WidgetTester tester, List<OnboardingStep> steps) =>
      pump(tester, OnboardingPage(steps: steps));

  Future<void> pump(WidgetTester tester, Widget home) async {
    dispatched.clear();
    final store = Store<AppState>(
      appReducer,
      initialState: AppState.initial(),
      middleware: [
        (store, action, next) {
          dispatched.add(action);
          next(action);
        },
      ],
    );

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en', 'US')],
        path: 'assets/translations',
        // Served from memory: loading the asset bundle runs outside the test's
        // fake clock, and only the first test of a file would see the page.
        assetLoader: _InMemoryLoader(_english),
        fallbackLocale: const Locale('en', 'US'),
        startLocale: const Locale('en', 'US'),
        child: Builder(
          builder: (context) => StoreProvider<AppState>(
            store: store,
            child: MaterialApp(
              locale: context.locale,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              theme: AppThemeBuilder.build(AppThemeId.light).theme,
              home: home,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }
}

/// A step that only shows where onboarding went next.
class NextStepMarker extends OnboardingStep {
  const NextStepMarker();

  static const text = 'next step';

  @override
  String primaryLabel(BuildContext context) => 'next';

  @override
  Widget buildContent(BuildContext context) => const Center(child: Text(text));
}

class _InMemoryLoader extends AssetLoader {
  const _InMemoryLoader(this.translations);

  final Map<String, dynamic> translations;

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async => translations;
}
