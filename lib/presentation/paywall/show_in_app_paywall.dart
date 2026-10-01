import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:weeksalive/data/analytics/analytics_events.dart';
import 'package:weeksalive/presentation/paywall/paywall_page.dart';
import 'package:weeksalive/presentation/paywall/paywall_presentation.dart';
import 'package:weeksalive/presentation/redux/analytics/analytics_actions.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';

/// Pushes the dismissible in-app paywall. Returns `true` when the user subscribed.
///
/// [feature] names the locked feature the user just reached, when the paywall
/// is opened by a gate rather than shown on its own.
Future<bool?> showInAppPaywall(BuildContext context, {String? feature}) {
  if (feature != null) {
    StoreProvider.of<AppState>(context, listen: false)
        .dispatch(TrackAnalyticsEventAction(AnalyticsEvent.proFeatureGateHit(feature: feature)));
  }

  // Root navigator: gates also fire from inside sheets that own a nested
  // navigator (day form, weekly summary), where the paywall must cover the sheet.
  return Navigator.of(context, rootNavigator: true).push<bool>(
    PaywallPage.route(
      presentation: PaywallPresentation.inApp,
    ),
  );
}
