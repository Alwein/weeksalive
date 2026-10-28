import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:weeksalive/core/styles/app_theme_builder.dart';
import 'package:weeksalive/core/styles/app_theme_id.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';

/// The English texts, read once from `setUpAll`.
Map<String, dynamic> readEnglishTranslations() =>
    jsonDecode(File('assets/translations/en-US.json').readAsStringSync()) as Map<String, dynamic>;

/// [home] in the app's theme with English texts and [store].
Widget localizedApp({
  required Map<String, dynamic> english,
  required Store<AppState> store,
  required Widget home,
}) {
  return EasyLocalization(
    supportedLocales: const [Locale('en', 'US')],
    path: 'assets/translations',
    assetLoader: InMemoryTranslationsLoader(english),
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
  );
}

/// Served from memory: loading the asset bundle runs outside the test's fake
/// clock, and only the first test of a file would see the page.
class InMemoryTranslationsLoader extends AssetLoader {
  const InMemoryTranslationsLoader(this.translations);

  final Map<String, dynamic> translations;

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async => translations;
}
