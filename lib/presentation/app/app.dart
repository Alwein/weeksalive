import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:weeksalive/presentation/app/app_bloc_wrapper.dart';
import 'package:weeksalive/presentation/app/bloc/app_bloc.dart';
import 'package:weeksalive/presentation/auth/bloc/auth_bloc.dart';
import 'package:weeksalive/presentation/force_update/force_update_page.dart';
import 'package:weeksalive/presentation/home/home_page.dart';
import 'package:weeksalive/presentation/onboarding/wrapper/onboarding_wrapper.dart';
import 'package:weeksalive/presentation/splash/splas_page.dart';
import 'package:weeksalive/presentation/user/user_bloc_wrapper.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return AppBlocProvidersWrapper(
      builder: (context) {
        return MaterialApp(
          title: 'WeeksAlive',
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
            HapticNavigatorObserver(),
          ],
          themeMode: ThemeMode.system,
          builder: (context, child) {
            Jiffy.setLocale(Localizations.localeOf(context).languageCode);
            return child!;
          },
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

class HapticNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    HapticFeedback.lightImpact();
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    HapticFeedback.lightImpact();
  }
}
