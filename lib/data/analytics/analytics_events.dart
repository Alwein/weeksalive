import 'package:collection/collection.dart';

/// The complete catalogue of product analytics events.
///
/// Every event the app can send is declared here as a named constructor, so
/// event names and property keys exist in exactly one place. Naming follows
/// `object_action` in snake_case with a past-tense verb.
///
/// Nothing that could identify a person or expose journal content belongs in a
/// property: no name, no date of birth, no entry text, no photos. Counts,
/// buckets and enum names only.
class AnalyticsEvent {
  const AnalyticsEvent._(this.name, [this.properties = const {}]);

  final String name;
  final Map<String, Object> properties;

  // --- Onboarding ---------------------------------------------------------

  factory AnalyticsEvent.onboardingStarted({
    required int attempt,
    required int totalSteps,
  }) =>
      AnalyticsEvent._('onboarding_started', {
        'onboarding_attempt': attempt,
        'total_steps': totalSteps,
      });

  factory AnalyticsEvent.onboardingStepViewed({
    required int stepIndex,
    required String stepName,
    required int totalSteps,
    required int attempt,
  }) =>
      AnalyticsEvent._('onboarding_step_viewed', {
        'step_index': stepIndex,
        'step_name': stepName,
        'total_steps': totalSteps,
        'onboarding_attempt': attempt,
      });

  factory AnalyticsEvent.onboardingStepCompleted({
    required int stepIndex,
    required String stepName,
    required int secondsOnStep,
  }) =>
      AnalyticsEvent._('onboarding_step_completed', {
        'step_index': stepIndex,
        'step_name': stepName,
        'seconds_on_step': secondsOnStep,
      });

  factory AnalyticsEvent.onboardingBackPressed({
    required int stepIndex,
    required String stepName,
  }) =>
      AnalyticsEvent._('onboarding_back_pressed', {
        'step_index': stepIndex,
        'step_name': stepName,
      });

  factory AnalyticsEvent.onboardingProfileSubmitted({
    required String ageBand,
    required String gender,
    required int lifespan,
    required int weekStartDay,
    required int intentsCount,
    required int notificationSlotsCount,
    required int secondsTotal,
  }) =>
      AnalyticsEvent._('onboarding_profile_submitted', {
        'age_band': ageBand,
        'gender': gender,
        'lifespan': lifespan,
        'week_start_day': weekStartDay,
        'intents_count': intentsCount,
        'notification_slots_count': notificationSlotsCount,
        'seconds_total': secondsTotal,
      });

  factory AnalyticsEvent.notificationPermissionResult({required bool granted}) =>
      AnalyticsEvent._('notification_permission_result', {'granted': granted});

  factory AnalyticsEvent.attPermissionResult({required String status}) =>
      AnalyticsEvent._('att_permission_result', {'status': status});

  factory AnalyticsEvent.reviewPromptShown({required String source}) =>
      AnalyticsEvent._('review_prompt_shown', {'source': source});

  // --- Paywall and purchase ------------------------------------------------

  factory AnalyticsEvent.paywallViewed({
    required String presentation,
    String? offeringId,
    String? productId,
    double? price,
    String? currency,
    int? trialDays,
  }) =>
      AnalyticsEvent._('paywall_viewed', _props({
        'presentation': presentation,
        'offering_id': offeringId,
        'product_id': productId,
        'price': price,
        'currency': currency,
        'trial_days': trialDays,
      }));

  /// The offering failed to load, so the paywall cannot sell anything.
  /// Revenue silently drops to zero when this fires, which is why it is tracked.
  factory AnalyticsEvent.paywallOfferingUnavailable({required String presentation}) =>
      AnalyticsEvent._('paywall_offering_unavailable', {'presentation': presentation});

  factory AnalyticsEvent.paywallPurchaseStarted({
    required String presentation,
    String? productId,
    double? price,
    String? currency,
  }) =>
      AnalyticsEvent._('paywall_purchase_started', _props({
        'presentation': presentation,
        'product_id': productId,
        'price': price,
        'currency': currency,
      }));

  factory AnalyticsEvent.trialStarted({
    required String presentation,
    String? productId,
    double? price,
    String? currency,
    int? trialDays,
  }) =>
      AnalyticsEvent._('trial_started', _props({
        'presentation': presentation,
        'product_id': productId,
        'price': price,
        'currency': currency,
        'trial_days': trialDays,
      }));

  factory AnalyticsEvent.purchaseCancelled({
    required String presentation,
    String? productId,
  }) =>
      AnalyticsEvent._('purchase_cancelled', _props({
        'presentation': presentation,
        'product_id': productId,
      }));

  factory AnalyticsEvent.purchaseFailed({
    required String presentation,
    required String errorCode,
  }) =>
      AnalyticsEvent._('purchase_failed', {
        'presentation': presentation,
        'error_code': errorCode,
      });

  factory AnalyticsEvent.paywallRestoreResult({required bool found}) =>
      AnalyticsEvent._('paywall_restore_result', {'found': found});

  factory AnalyticsEvent.paywallDismissed({
    required String presentation,
    required int secondsOnPaywall,
  }) =>
      AnalyticsEvent._('paywall_dismissed', {
        'presentation': presentation,
        'seconds_on_paywall': secondsOnPaywall,
      });

  factory AnalyticsEvent.proFeatureGateHit({required String feature}) =>
      AnalyticsEvent._('pro_feature_gate_hit', {'feature': feature});

  // --- Core loop -----------------------------------------------------------

  factory AnalyticsEvent.checkInStarted({
    required String source,
    required int dayOffset,
  }) =>
      AnalyticsEvent._('check_in_started', {
        'source': source,
        'day_offset': dayOffset,
      });

  factory AnalyticsEvent.checkInCompleted({
    required int intentionsLivedCount,
    required bool hasTraceText,
    required int photosCount,
    required int sizeLevel,
    required bool isBackfill,
    required int dayOffset,
    String? feeling,
    String? meaningScore,
    bool? newExperience,
    int? secondsToComplete,
  }) =>
      AnalyticsEvent._('check_in_completed', _props({
        'intentions_lived_count': intentionsLivedCount,
        'has_trace_text': hasTraceText,
        'photos_count': photosCount,
        'size_level': sizeLevel,
        'is_backfill': isBackfill,
        'day_offset': dayOffset,
        'feeling': feeling,
        'meaning_score': meaningScore,
        'new_experience': newExperience,
        'seconds_to_complete': secondsToComplete,
      }));

  factory AnalyticsEvent.checkInAbandoned({
    required String source,
    required int seconds,
  }) =>
      AnalyticsEvent._('check_in_abandoned', {
        'source': source,
        'seconds': seconds,
      });

  factory AnalyticsEvent.streakContinued({
    required int streakLength,
    required int bestEver,
  }) =>
      AnalyticsEvent._('streak_continued', {
        'streak_length': streakLength,
        'best_ever': bestEver,
      });

  factory AnalyticsEvent.streakBroken({required int previousLength}) =>
      AnalyticsEvent._('streak_broken', {'previous_length': previousLength});

  factory AnalyticsEvent.weeklyIntentSelected({
    required int intentsCount,
    required List<String> intentIds,
  }) =>
      AnalyticsEvent._('weekly_intent_selected', {
        'intents_count': intentsCount,
        'intent_ids': intentIds,
      });

  factory AnalyticsEvent.weeklySummaryCompleted({required int daysRecorded}) =>
      AnalyticsEvent._('weekly_summary_completed', {'days_recorded': daysRecorded});

  factory AnalyticsEvent.rewardUnlocked({
    required String rewardId,
    required int streakLength,
  }) =>
      AnalyticsEvent._('reward_unlocked', {
        'reward_id': rewardId,
        'streak_length': streakLength,
      });

  /// Which share of check-ins start from a reminder is the clearest read on
  /// whether notifications are carrying the daily habit.
  factory AnalyticsEvent.notificationTapped({required String type}) =>
      AnalyticsEvent._('notification_tapped', {'type': type});

  factory AnalyticsEvent.themeChanged({required String themeId}) =>
      AnalyticsEvent._('theme_changed', {'theme_id': themeId});

  factory AnalyticsEvent.appIconChanged({required String appIconId}) =>
      AnalyticsEvent._('app_icon_changed', {'app_icon_id': appIconId});

  factory AnalyticsEvent.gridMotifChanged({required String motifId}) =>
      AnalyticsEvent._('grid_motif_changed', {'motif_id': motifId});

  factory AnalyticsEvent.wallpaperExported() => const AnalyticsEvent._('wallpaper_exported');

  /// The second-launch nudge inviting the user to set up the wallpaper.
  factory AnalyticsEvent.wallpaperPromptShown() => const AnalyticsEvent._('wallpaper_prompt_shown');

  factory AnalyticsEvent.wallpaperPromptResolved({required bool accepted}) =>
      AnalyticsEvent._('wallpaper_prompt_resolved', {'accepted': accepted});

  factory AnalyticsEvent.widgetGuideViewed() => const AnalyticsEvent._('widget_guide_viewed');

  factory AnalyticsEvent.gridViewChanged({required String tab}) =>
      AnalyticsEvent._('grid_view_changed', {'tab': tab});

  factory AnalyticsEvent.profileUpdated({required List<String> fieldsChanged}) =>
      AnalyticsEvent._('profile_updated', {
        'fields_changed': fieldsChanged,
        'fields_changed_count': fieldsChanged.length,
      });

  static Map<String, Object> _props(Map<String, Object?> values) {
    return {
      for (final entry in values.entries)
        if (entry.value != null) entry.key: entry.value!,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnalyticsEvent &&
          other.name == name &&
          const DeepCollectionEquality().equals(other.properties, properties);

  @override
  int get hashCode => Object.hash(name, const DeepCollectionEquality().hash(properties));

  @override
  String toString() => 'AnalyticsEvent($name, $properties)';
}
