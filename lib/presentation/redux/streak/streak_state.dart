class StreakState {
  final int count;

  const StreakState({this.count = 0});

  StreakState copyWith({int? count}) {
    return StreakState(count: count ?? this.count);
  }
}
