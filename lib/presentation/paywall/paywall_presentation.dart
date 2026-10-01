enum PaywallPresentation {
  /// Paywall at the end of onboarding. The daily check-in is free, so the user
  /// can close it and go on to the app.
  onboarding,

  /// In-app paywall, opened by a Pro gate.
  inApp,
}

extension PaywallPresentationX on PaywallPresentation {
  /// Every paywall can be closed with the close button or the back gesture.
  bool get isDismissible => true;
}
