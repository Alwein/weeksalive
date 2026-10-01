import 'package:redux/redux.dart';
import 'package:weeksalive/data/analytics/analytics_events.dart';
import 'package:weeksalive/data/analytics/analytics_person_properties.dart';
import 'package:weeksalive/data/analytics/analytics_repository.dart';
import 'package:weeksalive/data/install/install_repository.dart';
import 'package:weeksalive/data/purchases/offering_trial.dart';
import 'package:weeksalive/data/purchases/purchase_repository.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/domain/rewards/reward_id.dart';
import 'package:weeksalive/domain/user/user.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_steps.dart';
import 'package:weeksalive/presentation/paywall/paywall_presentation.dart';
import 'package:weeksalive/presentation/redux/analytics/analytics_actions.dart';
import 'package:weeksalive/presentation/redux/app_icon/app_icon_actions.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/day/day_actions.dart';
import 'package:weeksalive/presentation/redux/grid_motif/grid_motif_actions.dart';
import 'package:weeksalive/presentation/redux/navigation/navigation_actions.dart';
import 'package:weeksalive/presentation/redux/purchase/purchase_actions.dart';
import 'package:weeksalive/presentation/redux/purchase/purchase_state.dart';
import 'package:weeksalive/presentation/redux/push_notifications/push_notification_actions.dart';
import 'package:weeksalive/presentation/redux/review_prompt/review_prompt_actions.dart';
import 'package:weeksalive/presentation/redux/rewards/rewards_actions.dart';
import 'package:weeksalive/presentation/redux/streak/streak_actions.dart';
import 'package:weeksalive/presentation/redux/theme/theme_actions.dart';
import 'package:weeksalive/presentation/redux/user/user_actions.dart';
import 'package:weeksalive/presentation/redux/user/user_state.dart';
import 'package:weeksalive/presentation/redux/wallpaper/wallpaper_actions.dart';
import 'package:weeksalive/presentation/redux/weekly_intent/weekly_intent_actions.dart';
import 'package:weeksalive/presentation/redux/weekly_summary/weekly_summary_actions.dart';

/// What the user is buying, kept from the tap until the store answers. The
/// paywall can be closed in between, so none of it may be read back from there.
typedef _PendingPurchase = ({
  String presentation,
  String productId,
  double price,
  String currency,
  String plan,
  int? trialDays,
});

/// Derives analytics events from state changes.
///
/// Instrumenting here rather than in widgets means an event fires wherever the
/// action comes from, and exactly once. It must be the last middleware in the
/// chain so that everything it reads has already been reduced.
class AnalyticsMiddleware extends MiddlewareClass<AppState> {
  AnalyticsMiddleware({
    required this.analyticsRepository,
    required this.installRepository,
    int? totalOnboardingSteps,
    DateTime Function()? now,
  }) : totalOnboardingSteps = totalOnboardingSteps ?? kOnboardingSteps.length,
       _now = now ?? DateTime.now;

  final AnalyticsRepository analyticsRepository;
  final InstallRepository installRepository;
  final int totalOnboardingSteps;
  final DateTime Function() _now;

  int _onboardingAttempt = 0;
  DateTime? _onboardingStartedAt;
  DateTime? _stepViewedAt;
  String? _paywallPresentation;
  DateTime? _paywallOpenedAt;
  _PendingPurchase? _pendingPurchase;
  bool _restoreInFlight = false;
  bool _notificationPermissionRequested = false;
  String? _checkInSource;
  DateTime? _checkInStartedAt;

  @override
  void call(Store<AppState> store, action, NextDispatcher next) {
    // Captured before reduction: these events are about the transition, not
    // about the resulting value.
    final wasPro = store.state.purchaseState.isPro;
    final previousStreak = store.state.streakState.count;
    final previouslyUnlocked = store.state.rewardsState.unlocked;
    final previousUser = store.state.userState.userOrNull;

    next(action);

    switch (action) {
      case TrackAnalyticsEventAction():
        analyticsRepository.capture(action.event);

      case OnboardingStartedAction():
        _onOnboardingStarted();

      case OnboardingStepViewedAction():
        _stepViewedAt = _now();
        analyticsRepository.capture(
          AnalyticsEvent.onboardingStepViewed(
            stepIndex: action.stepIndex,
            stepName: action.stepName,
            totalSteps: totalOnboardingSteps,
            attempt: _onboardingAttempt,
          ),
        );

      case OnboardingStepCompletedAction():
        analyticsRepository.capture(
          AnalyticsEvent.onboardingStepCompleted(
            stepIndex: action.stepIndex,
            stepName: action.stepName,
            secondsOnStep: _secondsSince(_stepViewedAt),
          ),
        );

      case OnboardingBackPressedAction():
        analyticsRepository.capture(
          AnalyticsEvent.onboardingBackPressed(
            stepIndex: action.stepIndex,
            stepName: action.stepName,
          ),
        );

      case OnboardingProfileSubmittedAction():
        _onOnboardingProfileSubmitted(action);

      case PaywallOpenedAction():
        _onPaywallOpened(store, action);

      case PaywallClosedAction():
        _onPaywallClosed(action);

      case OfferingLoadedAction() || OfferingLoadFailedAction():
        _onOfferingsResolved(store);

      case PurchasePackageAction():
        _onPurchaseStarted(store, action);

      case RestorePurchasesAction():
        _restoreInFlight = true;

      case PurchaseSucceededAction():
        _onPurchaseResolved(store, action, wasPro: wasPro);

      case PurchaseErrorAction():
        _onPurchaseFailed(action);

      case CheckInStartedAction():
        _onCheckInStarted(action);

      case CheckInAbandonedAction():
        _onCheckInAbandoned();

      case SaveDayAction():
        _onDaySaved(action);

      case StreakRecalculatedAction():
        _onStreakRecalculated(action, previousStreak: previousStreak);

      case RewardsLoadedAction():
        _onRewardsLoaded(store, action, previouslyUnlocked: previouslyUnlocked);

      case SetWeeklyIntentSelectionAction():
        analyticsRepository.capture(
          AnalyticsEvent.weeklyIntentSelected(
            intentsCount: action.ids.length,
            intentIds: action.ids,
          ),
        );
        analyticsRepository.setPersonProperties({
          'intents_count': action.ids.length,
        });

      case WeeklySummaryCompletedAction():
        analyticsRepository.capture(
          AnalyticsEvent.weeklySummaryCompleted(
            daysRecorded: _daysRecordedLastWeek(store),
          ),
        );

      case RequestNotificationPermissionAction():
        _notificationPermissionRequested = true;

      case PushNotificationEnabledLoadedAction():
        _onNotificationPermissionResolved(action);

      case UpdateNotificationSettingsAction():
        analyticsRepository.setPersonProperties({
          'notification_slots': notificationSlotsCount(action.slots),
        });

      case SetHomeTabIndexAction():
        analyticsRepository.capture(
          AnalyticsEvent.gridViewChanged(
            tab: action.index == 0 ? 'life' : 'year',
          ),
        );

      case NotificationTappedAction():
        analyticsRepository.capture(
          AnalyticsEvent.notificationTapped(type: action.payload),
        );

      case SetAppThemeAction():
        analyticsRepository.capture(
          AnalyticsEvent.themeChanged(themeId: action.themeId.name),
        );
        analyticsRepository.setPersonProperties({'theme': action.themeId.name});

      case SetAppIconAction():
        analyticsRepository.capture(
          AnalyticsEvent.appIconChanged(appIconId: action.iconId.name),
        );

      case SetGridMotifAction():
        analyticsRepository.capture(
          AnalyticsEvent.gridMotifChanged(motifId: action.motifId.name),
        );

      case WallpaperInstallCompletedAction(success: true):
        analyticsRepository.capture(AnalyticsEvent.wallpaperExported());

      case WallpaperPromptRequestedAction():
        analyticsRepository.capture(AnalyticsEvent.wallpaperPromptShown());

      case WallpaperPromptResolvedAction():
        analyticsRepository.capture(
          AnalyticsEvent.wallpaperPromptResolved(accepted: action.accepted),
        );

      case FeedbackPulseRequestedAction():
        analyticsRepository.capture(
          AnalyticsEvent.feedbackPulseShown(source: action.source),
        );

      case FeedbackPulseAnsweredAction():
        analyticsRepository.capture(
          AnalyticsEvent.feedbackPulseAnswered(
            sentiment: action.sentiment.name,
            source: action.source,
          ),
        );
        analyticsRepository.setPersonProperties({
          'feedback_sentiment': action.sentiment.name,
        });

      case FeedbackPulseResolvedAction(answered: false):
        analyticsRepository.capture(
          AnalyticsEvent.feedbackPulseDismissed(
            source: store.state.reviewPromptState.pulseSource,
          ),
        );

      case FeedbackSubmittedAction():
        analyticsRepository.capture(
          AnalyticsEvent.feedbackSubmitted(
            message: action.message,
            source: action.source,
            sentiment: action.sentiment?.name,
          ),
        );

      case UpdateUserAction():
        _onProfileUpdated(store, action, previousUser: previousUser);

      case ClearUserAction():
        analyticsRepository.reset();
    }
  }

  void _onPaywallOpened(Store<AppState> store, PaywallOpenedAction action) {
    _paywallPresentation = action.presentation;
    _paywallOpenedAt = _now();

    final isPlansPaywall =
        action.presentation == PaywallPresentation.inApp.name;
    final offering = isPlansPaywall
        ? store.state.purchaseState.plansOffering
        : store.state.purchaseState.offering;
    final product = offering?.annual?.storeProduct;
    analyticsRepository.capture(
      AnalyticsEvent.paywallViewed(
        presentation: action.presentation,
        offeringId: offering?.identifier,
        productId: product?.identifier,
        price: product?.price,
        currency: product?.currencyCode,
        trialDays: isPlansPaywall ? null : offering?.trialDays,
      ),
    );
  }

  void _onPaywallClosed(PaywallClosedAction action) {
    final openedAt = _paywallOpenedAt;
    if (!action.purchased && openedAt != null) {
      analyticsRepository.capture(
        AnalyticsEvent.paywallDismissed(
          presentation: action.presentation,
          secondsOnPaywall: _now().difference(openedAt).inSeconds,
        ),
      );
    }
    _paywallPresentation = null;
    _paywallOpenedAt = null;
  }

  /// A paywall with nothing to sell is a revenue outage. An open paywall only
  /// needs the offering it sells; with none open, both are checked so that a
  /// missing offering shows up before anyone reaches it.
  void _onOfferingsResolved(Store<AppState> store) {
    final offerings = store.state.purchaseState.offerings;
    final presentation = _paywallPresentation;
    final isPlansPaywall = presentation == PaywallPresentation.inApp.name;
    final checkCurrent = presentation == null || !isPlansPaywall;
    final checkPlans = presentation == null || isPlansPaywall;

    if (checkCurrent && offerings.current == null) {
      analyticsRepository.capture(
        AnalyticsEvent.paywallOfferingUnavailable(
          presentation: presentation ?? 'background',
          offering: 'current',
        ),
      );
    }
    if (checkPlans && offerings.plans == null) {
      analyticsRepository.capture(
        AnalyticsEvent.paywallOfferingUnavailable(
          presentation: presentation ?? 'background',
          offering: PurchaseRepository.plansOfferingId,
        ),
      );
    }
  }

  void _onPurchaseStarted(Store<AppState> store, PurchasePackageAction action) {
    final package = action.package;
    final product = package.storeProduct;
    final pending = (
      presentation: _paywallPresentation ?? 'unknown',
      productId: product.identifier,
      price: product.price,
      currency: product.currencyCode,
      plan: package.packageType.name,
      trialDays: store.state.purchaseState.offerings.trialDaysOf(package),
    );
    _pendingPurchase = pending;
    analyticsRepository.capture(
      AnalyticsEvent.paywallPurchaseStarted(
        presentation: pending.presentation,
        productId: pending.productId,
        price: pending.price,
        currency: pending.currency,
      ),
    );
  }

  /// A purchase, a restore and a plain status refresh all land on
  /// [PurchaseSucceededAction]; only the pending flags say which happened.
  ///
  /// Trial or paid is the store's answer, not the paywall's: a trial offer
  /// can be charged at once to a user who already used an intro offer.
  void _onPurchaseResolved(
    Store<AppState> store,
    PurchaseSucceededAction action, {
    required bool wasPro,
  }) {
    final isPro = store.state.purchaseState.isPro;

    if (_restoreInFlight) {
      _restoreInFlight = false;
      analyticsRepository.capture(
        AnalyticsEvent.paywallRestoreResult(found: isPro),
      );
    }

    final pending = _pendingPurchase;
    if (pending != null) {
      _pendingPurchase = null;
      if (isPro && !wasPro) {
        analyticsRepository.capture(
          action.isTrial
              ? AnalyticsEvent.trialStarted(
                  presentation: pending.presentation,
                  productId: pending.productId,
                  price: pending.price,
                  currency: pending.currency,
                  trialDays: pending.trialDays,
                )
              : AnalyticsEvent.subscriptionStarted(
                  presentation: pending.presentation,
                  productId: pending.productId,
                  price: pending.price,
                  currency: pending.currency,
                  plan: pending.plan,
                ),
        );
      } else if (!isPro) {
        analyticsRepository.capture(
          AnalyticsEvent.purchaseCancelled(
            presentation: pending.presentation,
            productId: pending.productId,
          ),
        );
      }
    }

    if (isPro != wasPro) {
      analyticsRepository.setPersonProperties({'is_pro': isPro});
    }
  }

  void _onPurchaseFailed(PurchaseErrorAction action) {
    if (_restoreInFlight) {
      _restoreInFlight = false;
      analyticsRepository.capture(
        AnalyticsEvent.paywallRestoreResult(found: false),
      );
      return;
    }
    final pending = _pendingPurchase;
    if (pending == null) return;

    _pendingPurchase = null;
    analyticsRepository.capture(
      AnalyticsEvent.purchaseFailed(
        presentation: pending.presentation,
        errorCode: action.errorCode,
      ),
    );
  }

  void _onCheckInStarted(CheckInStartedAction action) {
    _checkInSource = action.source;
    _checkInStartedAt = _now();
    analyticsRepository.capture(
      AnalyticsEvent.checkInStarted(
        source: action.source,
        dayOffset: action.dayOffset,
      ),
    );
  }

  void _onCheckInAbandoned() {
    final startedAt = _checkInStartedAt;
    if (startedAt == null) return;

    analyticsRepository.capture(
      AnalyticsEvent.checkInAbandoned(
        source: _checkInSource ?? 'unknown',
        seconds: _now().difference(startedAt).inSeconds,
      ),
    );
    _clearCheckIn();
  }

  void _onDaySaved(SaveDayAction action) {
    final entry = action.entry;
    final startedAt = _checkInStartedAt;
    final dayOffset = normalizeDay(
      _now(),
    ).difference(normalizeDay(entry.date)).inDays;

    analyticsRepository.capture(
      AnalyticsEvent.checkInCompleted(
        intentionsLivedCount: entry.livingIntentionIds.length,
        hasTraceText: entry.leaveATrace.text.trim().isNotEmpty,
        photosCount: entry.leaveATrace.imagePaths.length,
        sizeLevel: entry.sizeLevel,
        isBackfill: dayOffset != 0,
        dayOffset: dayOffset,
        feeling: entry.averageFeeling?.name,
        meaningScore: entry.meaningScore?.name,
        newExperience: entry.hasNewExperience,
        secondsToComplete: startedAt == null
            ? null
            : _now().difference(startedAt).inSeconds,
      ),
    );
    _clearCheckIn();
  }

  void _onStreakRecalculated(
    StreakRecalculatedAction action, {
    required int previousStreak,
  }) {
    if (action.count > previousStreak) {
      analyticsRepository.capture(
        AnalyticsEvent.streakContinued(
          streakLength: action.count,
          bestEver: action.bestEver,
        ),
      );
    } else if (previousStreak > 0 && action.count < previousStreak) {
      analyticsRepository.capture(
        AnalyticsEvent.streakBroken(previousLength: previousStreak),
      );
    }
  }

  void _onRewardsLoaded(
    Store<AppState> store,
    RewardsLoadedAction action, {
    required Set<RewardId> previouslyUnlocked,
  }) {
    // The initial load reports every past unlock at once; only report unlocks
    // that happened while the app was running.
    if (previouslyUnlocked.isEmpty) return;

    for (final reward in action.unlocked.difference(previouslyUnlocked)) {
      analyticsRepository.capture(
        AnalyticsEvent.rewardUnlocked(
          rewardId: reward.name,
          streakLength: store.state.streakState.count,
        ),
      );
    }
  }

  void _onNotificationPermissionResolved(
    PushNotificationEnabledLoadedAction action,
  ) {
    if (!_notificationPermissionRequested) return;

    _notificationPermissionRequested = false;
    analyticsRepository.capture(
      AnalyticsEvent.notificationPermissionResult(
        granted: action.pushNotificationEnabled,
      ),
    );
    analyticsRepository.setPersonProperties({
      'notification_permission': action.pushNotificationEnabled,
    });
  }

  void _onOnboardingStarted() {
    _onboardingStartedAt = _now();
    // The first step is viewed in the same frame, so the attempt has to be known
    // now rather than once the counter has been written to disk.
    _onboardingAttempt = installRepository.onboardingAttempt + 1;
    analyticsRepository.capture(
      AnalyticsEvent.onboardingStarted(
        attempt: _onboardingAttempt,
        totalSteps: totalOnboardingSteps,
      ),
    );
    installRepository.incrementOnboardingAttempt();
  }

  void _onOnboardingProfileSubmitted(OnboardingProfileSubmittedAction action) {
    analyticsRepository.capture(
      AnalyticsEvent.onboardingProfileSubmitted(
        ageBand: ageBand(action.user.dateOfBirth, now: _now()),
        gender: action.user.gender.name,
        lifespan: action.user.lifespan,
        weekStartDay: action.user.weekStartDay,
        intentsCount: action.intentsCount,
        notificationSlotsCount: notificationSlotsCount(action.slots),
        secondsTotal: _secondsSince(_onboardingStartedAt),
      ),
    );
    analyticsRepository.setPersonProperties(
      profilePersonProperties(
        user: action.user,
        intentsCount: action.intentsCount,
        slots: action.slots,
      ),
    );
  }

  /// The profile edited from the settings screen.
  ///
  /// The updated user only reaches the store once it has been persisted, so the
  /// new values are read from the action and the old ones from the state.
  void _onProfileUpdated(
    Store<AppState> store,
    UpdateUserAction action, {
    required User? previousUser,
  }) {
    if (previousUser == null) return;

    final updatedUser = previousUser.copyWith(
      name: action.name,
      dateOfBirth: action.dateOfBirth,
      gender: action.gender,
      lifespan: action.lifespan,
      weekStartDay: action.weekStartDay,
    );

    analyticsRepository.capture(
      AnalyticsEvent.profileUpdated(
        fieldsChanged: _changedProfileFields(previousUser, action),
      ),
    );
    analyticsRepository.setPersonProperties(
      profilePersonProperties(
        user: updatedUser,
        intentsCount: store.state.weeklyIntentState.selectedIds.length,
        slots: store.state.pushNotificationState.slots,
      ),
    );
  }

  int _secondsSince(DateTime? start) =>
      start == null ? 0 : _now().difference(start).inSeconds;

  int _daysRecordedLastWeek(Store<AppState> store) {
    final firstDay = normalizeDay(_now()).subtract(const Duration(days: 6));
    return store.state.dayState.entries.keys
        .where((date) => !date.isBefore(firstDay))
        .length;
  }

  static List<String> _changedProfileFields(
    User? previous,
    UpdateUserAction action,
  ) {
    if (previous == null) return const [];

    return [
      if (previous.name != action.name) 'name',
      if (previous.dateOfBirth != action.dateOfBirth) 'date_of_birth',
      if (previous.gender != action.gender) 'gender',
      if (previous.lifespan != action.lifespan) 'lifespan',
      if (previous.weekStartDay != action.weekStartDay) 'week_start_day',
    ];
  }

  void _clearCheckIn() {
    _checkInSource = null;
    _checkInStartedAt = null;
  }
}
