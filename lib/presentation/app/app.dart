import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fast_template/presentation/app/app_bloc_wrapper.dart';
import 'package:flutter_fast_template/presentation/app/bloc/app_bloc.dart';
import 'package:flutter_fast_template/presentation/auth/bloc/auth_bloc.dart';
import 'package:flutter_fast_template/presentation/force_update/force_update_page.dart';
import 'package:flutter_fast_template/presentation/home/home_page.dart';
import 'package:flutter_fast_template/presentation/onboarding/wrapper/onboarding_wrapper.dart';
import 'package:flutter_fast_template/presentation/splash/splas_page.dart';
import 'package:flutter_fast_template/presentation/user/user_bloc_wrapper.dart';
import 'package:jiffy/jiffy.dart';

// TODO: Ajouter les règles de sécurité pour user

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Jiffy.setLocale(Localizations.localeOf(context).languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return AppBlocProvidersWrapper(
      builder: (context) {
        return MaterialApp(
          title: 'Flutter App', // TODO: Ajouter ça dans le script
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          navigatorObservers: [FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)],
          themeMode: ThemeMode.system,
          theme: ThemeData(
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
          ),
          home: Builder(
            builder: (context) {
              return _AppRouterWrapper(
                child: _AuthRouterWrapper(
                  builder: (context, authenticated) => OnboardingWrapper(
                    child: UserBlocWrapper(
                      userId: authenticated.userId,
                      child: const MyHomePage(title: "title"),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _AppRouterWrapper extends StatelessWidget {
  const _AppRouterWrapper({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const SplashPage();
        }

        if (state.shouldForceUpdate) {
          return const ForceUpdatePage();
        }

        return child;
      },
    );
  }
}

class _AuthRouterWrapper extends StatelessWidget {
  const _AuthRouterWrapper({required this.builder});
  final Widget Function(BuildContext context, AuthAuthenticated authenticated) builder;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return state.map(
          unauthenticated: (_) => const SplashPage(),
          authenticated: (authenticated) => builder(context, authenticated),
        );
      },
    );
  }
}
