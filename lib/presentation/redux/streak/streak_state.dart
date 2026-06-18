class StreakState {
  final int count;
  final int bestEver;

  const StreakState({
    this.count = 0,
    this.bestEver = 0,
  });

  StreakState copyWith({
    int? count,
    int? bestEver,
  }) {
    return StreakState(
      count: count ?? this.count,
      bestEver: bestEver ?? this.bestEver,
    );
  }
}
