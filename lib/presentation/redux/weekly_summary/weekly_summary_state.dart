class WeeklySummaryState {
  const WeeklySummaryState({this.pendingShow = false});

  final bool pendingShow;

  WeeklySummaryState copyWith({bool? pendingShow}) {
    return WeeklySummaryState(
      pendingShow: pendingShow ?? this.pendingShow,
    );
  }
}
