import 'package:redux/redux.dart';
import 'package:weeksalive/data/day/day_repository.dart';
import 'package:weeksalive/data/home_widget/home_widget_service.dart';
import 'package:weeksalive/data/navigation/navigation_repository.dart';
import 'package:weeksalive/data/purchases/purchase_repository.dart';
import 'package:weeksalive/data/push_notifications/push_notification_repository.dart';
import 'package:weeksalive/data/remote_config/remote_config_repository.dart';
import 'package:weeksalive/data/streak/streak_repository.dart';
import 'package:weeksalive/data/theme/theme_repository.dart';
import 'package:weeksalive/data/user/user_repository.dart';
import 'package:weeksalive/data/wallpaper/wallpaper_config_repository.dart';
import 'package:weeksalive/data/weekly_intent/weekly_intent_repository.dart';
import 'package:weeksalive/data/weekly_summary/weekly_summary_repository.dart';
import 'package:weeksalive/domain/theme/theme_unlock_service.dart';
import 'package:weeksalive/presentation/redux/app_reducer.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_middleware.dart';
import 'package:weeksalive/presentation/redux/day/day_middleware.dart';
import 'package:weeksalive/presentation/redux/home_widget/home_widget_middleware.dart';
import 'package:weeksalive/presentation/redux/navigation/navigation_middleware.dart';
import 'package:weeksalive/presentation/redux/purchase/purchase_middleware.dart';
import 'package:weeksalive/presentation/redux/push_notifications/push_notification_middleware.dart';
import 'package:weeksalive/presentation/redux/streak/streak_middleware.dart';
import 'package:weeksalive/presentation/redux/theme/theme_middleware.dart';
import 'package:weeksalive/presentation/redux/user/user_middleware.dart';
import 'package:weeksalive/presentation/redux/wallpaper/wallpaper_middleware.dart';
import 'package:weeksalive/presentation/redux/weekly_intent/weekly_intent_middleware.dart';
import 'package:weeksalive/presentation/redux/weekly_summary/weekly_summary_middleware.dart';

class StoreFactory {
  final RemoteConfigRepository remoteConfigRepository;
  final UserRepository userRepository;
  final ThemeRepository themeRepository;
  final NavigationRepository navigationRepository;
  final PushNotificationRepository pushNotificationRepository;
  final PurchaseRepository purchaseRepository;
  final StreakRepository streakRepository;
  final WeeklyIntentRepository weeklyIntentRepository;
  final WeeklySummaryRepository weeklySummaryRepository;
  final DayRepository dayRepository;
  final ThemeUnlockService themeUnlockService;
  final HomeWidgetService homeWidgetService;
  final WallpaperConfigRepository wallpaperConfigRepository;

  StoreFactory({
    required this.remoteConfigRepository,
    required this.userRepository,
    required this.themeRepository,
    required this.navigationRepository,
    required this.pushNotificationRepository,
    required this.purchaseRepository,
    required this.streakRepository,
    required this.weeklyIntentRepository,
    required this.weeklySummaryRepository,
    required this.dayRepository,
    ThemeUnlockService? themeUnlockService,
    HomeWidgetService? homeWidgetService,
    required this.wallpaperConfigRepository,
  })  : themeUnlockService = themeUnlockService ?? const ThemeUnlockService(),
        homeWidgetService = homeWidgetService ?? HomeWidgetService();

  Store<AppState> createStore({AppState? initialState}) {
    return Store<AppState>(
      appReducer,
      initialState: initialState ?? AppState.initial(),
      middleware: [
        BootstrapMiddleware().call,
        UserMiddleware(userRepository: userRepository).call,
        ThemeMiddleware(
          themeRepository: themeRepository,
          themeUnlockService: themeUnlockService,
        ).call,
        NavigationMiddleware(navigationRepository: navigationRepository).call,
        PushNotificationMiddleware(pushNotificationRepository: pushNotificationRepository).call,
        PurchaseMiddleware(purchaseRepository: purchaseRepository).call,
        StreakMiddleware(streakRepository: streakRepository).call,
        WeeklyIntentMiddleware(weeklyIntentRepository: weeklyIntentRepository).call,
        WeeklySummaryMiddleware(weeklySummaryRepository: weeklySummaryRepository).call,
        HomeWidgetMiddleware(homeWidgetService: homeWidgetService).call,
        WallpaperMiddleware(repository: wallpaperConfigRepository).call,
        DayMiddleware(dayRepository: dayRepository).call,
      ],
    );
  }
}
