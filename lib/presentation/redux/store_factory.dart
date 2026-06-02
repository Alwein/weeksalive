import 'package:redux/redux.dart';
import 'package:weeksalive/data/day/day_repository.dart';
import 'package:weeksalive/data/purchases/purchase_repository.dart';
import 'package:weeksalive/data/push_notifications/push_notification_repository.dart';
import 'package:weeksalive/data/remote_config/remote_config_repository.dart';
import 'package:weeksalive/data/streak/streak_repository.dart';
import 'package:weeksalive/data/theme/theme_repository.dart';
import 'package:weeksalive/data/user/user_repository.dart';
import 'package:weeksalive/data/weekly_intent/weekly_intent_repository.dart';
import 'package:weeksalive/presentation/redux/app_reducer.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_middleware.dart';
import 'package:weeksalive/presentation/redux/day/day_middleware.dart';
import 'package:weeksalive/presentation/redux/purchase/purchase_middleware.dart';
import 'package:weeksalive/presentation/redux/push_notifications/push_notification_middleware.dart';
import 'package:weeksalive/presentation/redux/streak/streak_middleware.dart';
import 'package:weeksalive/presentation/redux/theme/theme_middleware.dart';
import 'package:weeksalive/presentation/redux/user/user_middleware.dart';
import 'package:weeksalive/presentation/redux/weekly_intent/weekly_intent_middleware.dart';

class StoreFactory {
  final RemoteConfigRepository remoteConfigRepository;
  final UserRepository userRepository;
  final ThemeRepository themeRepository;
  final PushNotificationRepository pushNotificationRepository;
  final PurchaseRepository purchaseRepository;
  final StreakRepository streakRepository;
  final WeeklyIntentRepository weeklyIntentRepository;
  final DayRepository dayRepository;

  StoreFactory({
    required this.remoteConfigRepository,
    required this.userRepository,
    required this.themeRepository,
    required this.pushNotificationRepository,
    required this.purchaseRepository,
    required this.streakRepository,
    required this.weeklyIntentRepository,
    required this.dayRepository,
  });

  Store<AppState> createStore({AppState? initialState}) {
    return Store<AppState>(
      appReducer,
      initialState: initialState ?? AppState.initial(),
      middleware: [
        BootstrapMiddleware().call,
        UserMiddleware(userRepository: userRepository).call,
        ThemeMiddleware(themeRepository: themeRepository).call,
        PushNotificationMiddleware(pushNotificationRepository: pushNotificationRepository).call,
        PurchaseMiddleware(purchaseRepository: purchaseRepository).call,
        StreakMiddleware(streakRepository: streakRepository).call,
        WeeklyIntentMiddleware(weeklyIntentRepository: weeklyIntentRepository).call,
        DayMiddleware(dayRepository: dayRepository).call,
      ],
    );
  }
}
