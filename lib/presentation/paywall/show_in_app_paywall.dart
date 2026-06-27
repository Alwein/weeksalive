import 'package:flutter/material.dart';
import 'package:weeksalive/presentation/paywall/paywall_page.dart';
import 'package:weeksalive/presentation/paywall/paywall_presentation.dart';

/// Pushes the dismissible in-app paywall. Returns `true` when the user subscribed.
Future<bool?> showInAppPaywall(BuildContext context) {
  return Navigator.of(context).push<bool>(
    PaywallPage.route(
      presentation: PaywallPresentation.inApp,
    ),
  );
}
