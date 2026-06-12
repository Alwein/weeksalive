import 'package:redux/redux.dart';
import 'package:weeksalive/data/day/day_repository.dart';
import 'package:weeksalive/data/navigation/navigation_repository.dart';
import 'package:weeksalive/data/purchases/purchase_repository.dart';
import 'package:weeksalive/data/push_notifications/push_notification_repository.dart';
import 'package:weeksalive/data/remote_config/remote_config_repository.dart';
import 'package:weeksalive/data/streak/streak_repository.dart';
import 'package:weeksalive/data/theme/theme_repository.dart';
import 'package:weeksalive/data/user/user_repository.dart';
import 'package:weeksalive/data/weekly_intent/weekly_intent_repository.dart';
import 'package:weeksalive/data/weekly_summary/weekly_summary_repository.dart';
import 'package:weeksalive/domain/theme/theme_unlock_service.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/store_factory.dart';

import '../mocks.dart';

class TestStoreFactory {
  RemoteConfigRepository remoteConfigRepository = MockRemoteConfigRepository();
  UserRepository userRepository = MockUserRepository();
  PushNotificationRepository pushNotificationRepository = MockPushNotificationRepository();
  PurchaseRepository purchaseRepository = MockPurchaseRepository();
  ThemeRepository themeRepository = MockThemeRepository();
  StreakRepository streakRepository = MockStreakRepository();
  NavigationRepository navigationRepository = MockNavigationRepository();

  /// Not wired into the test store by default to prevent async dispatch
  /// interference with other middleware bootstrap tests. Use the isolated
  /// store helper in weekly_intent_state_test.dart for bootstrap tests.
  WeeklyIntentRepository weeklyIntentRepository = MockWeeklyIntentRepository();
  WeeklySummaryRepository weeklySummaryRepository = MockWeeklySummaryRepository();
  DayRepository dayRepository = MockDayRepository();

  Store<AppState> initializeReduxStore(AppState initialState) {
    return StoreFactory(
      remoteConfigRepository: remoteConfigRepository,
      userRepository: userRepository,
      pushNotificationRepository: pushNotificationRepository,
      purchaseRepository: purchaseRepository,
      themeRepository: themeRepository,
      streakRepository: streakRepository,
      weeklyIntentRepository: weeklyIntentRepository,
      weeklySummaryRepository: weeklySummaryRepository,
      dayRepository: dayRepository,
      navigationRepository: navigationRepository,
      themeUnlockService: const ThemeUnlockService(),
    ).createStore(initialState: initialState);
  }
}
