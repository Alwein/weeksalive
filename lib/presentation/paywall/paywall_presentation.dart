enum PaywallPresentation {
  /// Hard paywall at the end of onboarding — no dismiss control.
  onboarding,

  /// In-app paywall — dismissible via close button or back gesture.
  inApp,
}

extension PaywallPresentationX on PaywallPresentation {
  bool get isDismissible => this == PaywallPresentation.inApp;
}
