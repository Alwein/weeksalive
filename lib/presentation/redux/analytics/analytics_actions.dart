import 'package:weeksalive/data/analytics/analytics_events.dart';
import 'package:weeksalive/domain/notifications/notification_slots.dart';
import 'package:weeksalive/domain/user/user.dart';

/// Sends [event] as-is.
///
/// For flows that do not change Redux state and therefore have no action for
/// [AnalyticsMiddleware] to derive an event from — screen-level moments in
/// onboarding, the paywall and the settings screens.
class TrackAnalyticsEventAction {
  const TrackAnalyticsEventAction(this.event);

  final AnalyticsEvent event;
}

/// Onboarding was opened at its first step.
///
/// [AnalyticsMiddleware] owns the attempt counter and the timings for every
/// onboarding event, so the screens only have to say what happened and when.
class OnboardingStartedAction {
  const OnboardingStartedAction();
}

class OnboardingStepViewedAction {
  const OnboardingStepViewedAction({required this.stepIndex, required this.stepName});

  final int stepIndex;
  final String stepName;
}

class OnboardingStepCompletedAction {
  const OnboardingStepCompletedAction({required this.stepIndex, required this.stepName});

  final int stepIndex;
  final String stepName;
}

class OnboardingBackPressedAction {
  const OnboardingBackPressedAction({required this.stepIndex, required this.stepName});

  final int stepIndex;
  final String stepName;
}

/// The profile was submitted, ending onboarding.
///
/// The profile is carried here rather than read from the store because it only
/// lands in state once it has been persisted, one event loop later.
class OnboardingProfileSubmittedAction {
  const OnboardingProfileSubmittedAction({
    required this.user,
    required this.slots,
    required this.intentsCount,
  });

  final User user;
  final NotificationSlots slots;
  final int intentsCount;
}

/// The paywall is on screen.
///
/// [AnalyticsMiddleware] keeps the presentation and the time of arrival so that
/// purchase outcomes — which surface as purchase actions with no paywall
/// context of their own — can be attributed to the right paywall.
class PaywallOpenedAction {
  const PaywallOpenedAction(this.presentation);

  final String presentation;
}

class PaywallClosedAction {
  const PaywallClosedAction({required this.presentation, required this.purchased});

  final String presentation;
  final bool purchased;
}

/// The check-in form was opened, from [source] (`today_button`, `notification`,
/// `calendar` or `resume`), for a day [dayOffset] days before today.
class CheckInStartedAction {
  const CheckInStartedAction({required this.source, this.dayOffset = 0});

  final String source;
  final int dayOffset;
}

/// The check-in form was closed without saving.
class CheckInAbandonedAction {
  const CheckInAbandonedAction();
}
