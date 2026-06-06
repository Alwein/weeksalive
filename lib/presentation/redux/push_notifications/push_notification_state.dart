class PushNotificationState {
  const PushNotificationState({this.pendingOpenDayForm = false});

  final bool pendingOpenDayForm;

  PushNotificationState copyWith({bool? pendingOpenDayForm}) {
    return PushNotificationState(
      pendingOpenDayForm: pendingOpenDayForm ?? this.pendingOpenDayForm,
    );
  }
}
