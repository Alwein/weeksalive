import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fast_template/presentation/app/app_bloc_wrapper.dart';
import 'package:flutter_fast_template/presentation/force_update/force_update_page.dart';
import 'package:flutter_fast_template/presentation/home/home_page.dart';
import 'package:flutter_fast_template/presentation/onboarding/wrapper/onboarding_wrapper.dart';
import 'package:flutter_fast_template/presentation/splash/splas_page.dart';
import 'package:jiffy/jiffy.dart';

// TODO: Ajouter les règles de sécurité pour user

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    final FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

    return AppBlocWrapper(
      builder: (context, appState, authState) {
        return MaterialApp(
          title: 'Flutter App',
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          navigatorObservers: [observer],
          themeMode: ThemeMode.system,
          theme: ThemeData(
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
          ),
          home: Builder(
            builder: (context) {
              // TODO: Tester l'affichage des pages principales
              Jiffy.setLocale(Localizations.localeOf(context).languageCode);

              if (appState.isLoading) {
                return const SplashPage();
              }

              if (appState.shouldForceUpdate) {
                return const ForceUpdatePage();
              }

              return OnboardingWrapper(
                child: authState.map(
                  unauthenticated: (_) => const SplashPage(),
                  authenticated: (_) => const MyHomePage(title: "title"), // TODO: UserBloc
                ),
              );
            },
          ),
        );
      },
    );
  }
}
