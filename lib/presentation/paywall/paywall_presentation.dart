enum PaywallPresentation {
  /// Paywall at the end of onboarding. Sells the current offering, which
  /// includes a free trial. The daily check-in is free, so the user can close
  /// it and go on to the app — and doing so is what ends access to the trial.
  onboarding,

  /// In-app paywall, opened by a Pro gate after onboarding. Sells annual,
  /// weekly and lifetime, with no free trial.
  inApp,
}

extension PaywallPresentationX on PaywallPresentation {
  /// Every paywall can be closed with the close button or the back gesture.
  bool get isDismissible => true;
}
