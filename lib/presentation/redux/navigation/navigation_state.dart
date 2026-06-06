class NavigationState {
  final int homeTabIndex;

  const NavigationState({this.homeTabIndex = 0});

  NavigationState copyWith({int? homeTabIndex}) {
    return NavigationState(homeTabIndex: homeTabIndex ?? this.homeTabIndex);
  }
}
