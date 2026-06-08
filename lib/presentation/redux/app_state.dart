import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weeksalive/presentation/redux/day/day_state.dart';
import 'package:weeksalive/presentation/redux/purchase/purchase_state.dart';
import 'package:weeksalive/presentation/redux/push_notifications/push_notification_state.dart';
import 'package:weeksalive/presentation/redux/remote_config/remote_config_state.dart';
import 'package:weeksalive/presentation/redux/streak/streak_state.dart';
import 'package:weeksalive/presentation/redux/theme/theme_state.dart';
import 'package:weeksalive/presentation/redux/user/user_state.dart';
import 'package:weeksalive/presentation/redux/navigation/navigation_state.dart';
import 'package:weeksalive/presentation/redux/weekly_intent/weekly_intent_state.dart';

part 'app_state.freezed.dart';

@freezed
abstract class AppState with _$AppState {
  const factory AppState({
    required RemoteConfigState remoteConfigState,
    required UserState userState,
    required PurchaseState purchaseState,
    required ThemeState themeState,
    required StreakState streakState,
    required WeeklyIntentState weeklyIntentState,
    required DayState dayState,
    required PushNotificationState pushNotificationState,
    required NavigationState navigationState,
  }) = _AppState;

  factory AppState.initial() {
    return AppState(
      remoteConfigState: const RemoteConfigState(),
      userState: const UserState.loading(),
      purchaseState: const PurchaseState.initial(),
      themeState: const ThemeState(),
      streakState: const StreakState(),
      weeklyIntentState: WeeklyIntentState.initial(),
      dayState: DayState.initial(),
      pushNotificationState: PushNotificationState(),
      navigationState: const NavigationState(),
    );
  }
}
