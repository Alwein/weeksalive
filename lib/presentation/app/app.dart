import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weeksalive/core/styles/app_system_ui_style.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hidden_logo/hidden_logo.dart';
import 'package:jiffy/jiffy.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:redux/redux.dart';
import 'package:weeksalive/core/styles/app_theme_builder.dart';
import 'package:weeksalive/core/styles/app_theme_id.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/utils/sensorial_feedback.dart';
import 'package:weeksalive/data/push_notifications/push_notification_repository.dart';
import 'package:weeksalive/presentation/bootstrap/bootstrap_page.dart';
import 'package:weeksalive/presentation/push_notifications/push_notification_navigation_handler.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/home_widget/home_widget_actions.dart';
import 'package:weeksalive/presentation/redux/wallpaper/wallpaper_actions.dart';
import 'package:weeksalive/presentation/widgets/app_background_scale.dart';
import 'package:weeksalive/presentation/widgets/notch_logo.dart';

class App extends StatefulWidget {
  final Store<AppState> store;
  final PushNotificationRepository pushNotificationRepository;

  const App({
    super.key,
    required this.store,
    required this.pushNotificationRepository,
  });

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  final _backgroundScaleController = AppBackgroundScaleController();
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Refresh the home widgets both when returning to the app (so they reflect
    // changes made elsewhere) and when leaving it (so the latest in-app changes
    // are pushed before the app is backgrounded/closed).
    if (state == AppLifecycleState.resumed ||
        state == AppLifecycleState.paused) {
      widget.store.dispatch(const RefreshHomeWidgetsAction());
      widget.store.dispatch(const RefreshWallpaperAction());
    }
  }

  @override
  Widget build(BuildContext context) {
    // PostHogWidget hosts the session replay capture; it has to sit above the
    // MaterialApp for the whole tree to be recorded.
    return PostHogWidget(
      child: StoreProvider<AppState>(
        store: widget.store,
        child: StoreConnector<AppState, AppThemeId>(
          converter: (store) => store.state.themeState.selectedTheme,
          builder: (context, selectedTheme) {
            final config = AppThemeBuilder.build(selectedTheme);
            return PushNotificationNavigationHandler(
              navigatorKey: _navigatorKey,
              pushNotificationRepository: widget.pushNotificationRepository,
              child: MaterialApp(
                navigatorKey: _navigatorKey,
                title: 'WeeksAlive',
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                navigatorObservers: [
                  FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
                  PosthogObserver(),
                  HapticNavigatorObserver(),
                ],
                themeMode: config.themeMode,
                builder: (context, child) {
                  Jiffy.setLocale(Localizations.localeOf(context).languageCode);
                  return AnnotatedRegion<SystemUiOverlayStyle>(
                    value: AppSystemUiStyle.forContext(context),
                    child: HiddenLogo(
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
                    ),
                  );
                },
                theme: config.theme,
                darkTheme: config.darkTheme,
                home: const BootstrapPage(),
              ),
            );
          },
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
