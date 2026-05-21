import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hidden_logo/hidden_logo.dart';
import 'package:jiffy/jiffy.dart';
import 'package:redux/redux.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/utils/sensorial_feedback.dart';
import 'package:weeksalive/presentation/bootstrap/bootstrap_page.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/widgets/app_background_scale.dart';
import 'package:weeksalive/presentation/widgets/notch_logo.dart';

class App extends StatefulWidget {
  final Store<AppState> store;
  const App({super.key, required this.store});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _backgroundScaleController = AppBackgroundScaleController();
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: widget.store,
      child: StoreConnector<AppState, ThemeMode>(
        converter: (store) => store.state.themeState.themeMode,
        builder: (context, themeMode) => MaterialApp(
          title: 'WeeksAlive',
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
            HapticNavigatorObserver(),
          ],
          themeMode: themeMode,
          builder: (context, child) {
            Jiffy.setLocale(Localizations.localeOf(context).languageCode);
            return HiddenLogo(
              body: AppBackgroundScaleScope(
                notifier: _backgroundScaleController,
                child: AnimatedBuilder(
                  animation: _backgroundScaleController,
                  child: child!,
                  builder: (context, child) => AnimatedScale(
                    scale: _backgroundScaleController.scale,
                    duration: AnimationDurations.base,
                    curve: Curves.easeOutSine,
                    child: child,
                  ),
                ),
              ),
              notchBuilder: (context, size) => NotchLogo(size: size),
              dynamicIslandBuilder: (context, size) => NotchLogo(size: size),
            );
          },
          theme: ThemeData(
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
          ),
          home: const BootstrapPage(),
        ),
      ),
    );
  }
}

class HapticNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    SensorialFeedback.navigationChanged();
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    SensorialFeedback.navigationChanged();
  }
}
