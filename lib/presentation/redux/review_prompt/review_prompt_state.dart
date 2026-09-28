class ReviewPromptState {
  const ReviewPromptState({this.pulsePending = false, this.pulseSource = ''});

  /// True while the feedback pulse is waiting to be shown by the home screen
  /// listener.
  final bool pulsePending;

  /// What triggered the pending pulse, forwarded to analytics.
  final String pulseSource;

  ReviewPromptState copyWith({bool? pulsePending, String? pulseSource}) {
    return ReviewPromptState(
      pulsePending: pulsePending ?? this.pulsePending,
      pulseSource: pulseSource ?? this.pulseSource,
    );
  }
}
