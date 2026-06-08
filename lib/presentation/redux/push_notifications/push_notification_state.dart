class PushNotificationState {
  const PushNotificationState({
    this.pendingOpenDayForm = false,
    this.pushNotificationEnabled = false,
  });

  final bool pendingOpenDayForm;
  final bool pushNotificationEnabled;

  PushNotificationState copyWith({
    bool? pendingOpenDayForm,
    bool? pushNotificationEnabled,
  }) {
    return PushNotificationState(
      pendingOpenDayForm: pendingOpenDayForm ?? this.pendingOpenDayForm,
      pushNotificationEnabled: pushNotificationEnabled ?? this.pushNotificationEnabled,
    );
  }
}
