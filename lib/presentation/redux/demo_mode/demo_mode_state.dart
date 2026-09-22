class DemoModeState {
  final bool enabled;

  const DemoModeState({this.enabled = false});

  DemoModeState copyWith({bool? enabled}) {
    return DemoModeState(enabled: enabled ?? this.enabled);
  }
}
