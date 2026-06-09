import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:redux/redux.dart';
import 'package:weeksalive/domain/notifications/notification_slots.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/user/user_state.dart';

part 'notifications_settings_view_model.freezed.dart';

@freezed
abstract class NotificationsSettingsViewModel with _$NotificationsSettingsViewModel {
  const factory NotificationsSettingsViewModel({
    required bool notificationsEnabled,
    required NotificationSlotState dailySlot1,
    required NotificationSlotState dailySlot2,
    required NotificationSlotState weeklySummarySlot,
    required int weekStartDay,
  }) = _NotificationsSettingsViewModel;

  factory NotificationsSettingsViewModel.create(Store<AppState> store) {
    final slots = store.state.pushNotificationState.slots;

    return NotificationsSettingsViewModel(
      notificationsEnabled: store.state.pushNotificationState.pushNotificationEnabled,
      dailySlot1: slots.slot1,
      dailySlot2: slots.slot2,
      weeklySummarySlot: slots.weeklySummary,
      weekStartDay: store.state.userState.userOrNull?.weekStartDay ?? DateTime.monday,
    );
  }
}
