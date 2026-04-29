import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:jiffy/jiffy.dart';
import 'package:redux/redux.dart';
import 'package:weeksalive/presentation/bootstrap/bootstrap_page.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';

class App extends StatefulWidget {
  final Store<AppState> store;
  const App({super.key, required this.store});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: widget.store,
      child: MaterialApp(
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
        home: const BootstrapPage(),
      ),
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
