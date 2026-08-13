import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';
import 'package:weeksalive/core/app_icon/app_icon_id.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_id.dart';
import 'package:weeksalive/core/styles/app_theme_id.dart';
import 'package:weeksalive/data/analytics/analytics_events.dart';
import 'package:weeksalive/domain/day/day.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/domain/notifications/notification_slots.dart';
import 'package:weeksalive/domain/rewards/reward_id.dart';
import 'package:weeksalive/domain/user/user.dart';
import 'package:weeksalive/presentation/redux/analytics/analytics_actions.dart';
import 'package:weeksalive/presentation/redux/analytics/analytics_middleware.dart';
import 'package:weeksalive/presentation/redux/app_icon/app_icon_actions.dart';
import 'package:weeksalive/presentation/redux/app_reducer.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/day/day_actions.dart';
import 'package:weeksalive/presentation/redux/day/day_state.dart';
import 'package:weeksalive/presentation/redux/grid_motif/grid_motif_actions.dart';
import 'package:weeksalive/presentation/redux/navigation/navigation_actions.dart';
import 'package:weeksalive/presentation/redux/purchase/purchase_actions.dart';
import 'package:weeksalive/presentation/redux/purchase/purchase_state.dart';
import 'package:weeksalive/presentation/redux/push_notifications/push_notification_actions.dart';
import 'package:weeksalive/presentation/redux/rewards/rewards_actions.dart';
import 'package:weeksalive/presentation/redux/rewards/rewards_state.dart';
import 'package:weeksalive/presentation/redux/streak/streak_actions.dart';
import 'package:weeksalive/presentation/redux/streak/streak_state.dart';
import 'package:weeksalive/presentation/redux/theme/theme_actions.dart';
import 'package:weeksalive/presentation/redux/user/user_actions.dart';
import 'package:weeksalive/presentation/redux/user/user_state.dart';
import 'package:weeksalive/presentation/redux/weekly_intent/weekly_intent_actions.dart';
import 'package:weeksalive/presentation/redux/weekly_summary/weekly_summary_actions.dart';

import '../../../fixtures/purchase_fixtures.dart';
import '../../../fixtures/user_fixtures.dart';
import '../../../helpers/fake_analytics_repository.dart';

void main() {
  late FakeAnalyticsRepository analytics;
  late FakeInstallRepository install;
  late DateTime clock;

  const totalSteps = 34;
  final today = DateTime(2026, 5, 20, 9);

  setUp(() {
    analytics = FakeAnalyticsRepository();
    install = FakeInstallRepository();
    clock = today;
  });

  /// A store running the analytics middleware alone, so that assertions only
  /// see what it produces.
  Store<AppState> analyticsStore({AppState? initialState}) {
    return Store<AppState>(
      appReducer,
      initialState: initialState ?? AppState.initial(),
      middleware: [
        AnalyticsMiddleware(
          analyticsRepository: analytics,
          installRepository: install,
          totalOnboardingSteps: totalSteps,
          now: () => clock,
        ).call,
      ],
    );
  }

  Store<AppState> paywallStore({bool isPro = false}) => analyticsStore(
        initialState: AppState.initial().copyWith(
          purchaseState: PurchaseState.success(offering: offeringFixture(), isPro: isPro),
        ),
      );

  void advance(Duration duration) => clock = clock.add(duration);

  group('onboarding', () {
    test('start counts a new attempt and reports the funnel length', () async {
      final store = analyticsStore();

      store.dispatch(const OnboardingStartedAction());
      await pumpEventQueue();

      expect(analytics.capturedNames, ['onboarding_started']);
      expect(analytics.propertiesOf('onboarding_started'), {
        'onboarding_attempt': 1,
        'total_steps': totalSteps,
      });
    });

    test('a restart is reported as a second attempt', () async {
      final store = analyticsStore();

      store.dispatch(const OnboardingStartedAction());
      await pumpEventQueue();
      analytics.clear();
      store.dispatch(const OnboardingStartedAction());
      await pumpEventQueue();

      expect(analytics.propertiesOf('onboarding_started')?['onboarding_attempt'], 2);
    });

    test('the first step of an attempt is not reported as attempt zero', () {
      final store = analyticsStore();

      // Onboarding opens and shows its first step in the same frame, so the
      // attempt cannot wait on the counter being persisted.
      store.dispatch(const OnboardingStartedAction());
      store.dispatch(const OnboardingStepViewedAction(stepIndex: 0, stepName: 'step_01_welcome'));

      expect(analytics.propertiesOf('onboarding_step_viewed')?['onboarding_attempt'], 1);
    });

    test('a step carries the current attempt and how long it was on screen', () async {
      final store = analyticsStore();

      store.dispatch(const OnboardingStartedAction());
      await pumpEventQueue();
      store.dispatch(const OnboardingStepViewedAction(stepIndex: 3, stepName: 'step_04_make_it_count'));
      advance(const Duration(seconds: 12));
      store.dispatch(const OnboardingStepCompletedAction(stepIndex: 3, stepName: 'step_04_make_it_count'));

      expect(analytics.propertiesOf('onboarding_step_viewed'), {
        'step_index': 3,
        'step_name': 'step_04_make_it_count',
        'total_steps': totalSteps,
        'onboarding_attempt': 1,
      });
      expect(analytics.propertiesOf('onboarding_step_completed')?['seconds_on_step'], 12);
    });

    test('going back is reported with the step left behind', () {
      analyticsStore().dispatch(
        const OnboardingBackPressedAction(stepIndex: 7, stepName: 'step_08_week_begin'),
      );

      expect(analytics.propertiesOf('onboarding_back_pressed'), {
        'step_index': 7,
        'step_name': 'step_08_week_begin',
      });
    });

    test('submitting the profile reports an age band, never the birth date', () async {
      final store = analyticsStore();
      final user = userFixture(dateOfBirth: DateTime(1994, 3, 2), lifespan: 88);

      store.dispatch(const OnboardingStartedAction());
      await pumpEventQueue();
      advance(const Duration(minutes: 4));
      store.dispatch(
        OnboardingProfileSubmittedAction(
          user: user,
          slots: NotificationSlots.defaults(),
          intentsCount: 3,
        ),
      );

      final properties = analytics.propertiesOf('onboarding_profile_submitted')!;
      expect(properties['age_band'], '25_34');
      expect(properties['lifespan'], 88);
      expect(properties['intents_count'], 3);
      expect(properties['seconds_total'], 240);
      expect(properties.containsKey('date_of_birth'), isFalse);
      expect(properties.containsKey('name'), isFalse);

      expect(analytics.mergedPersonProperties['age_band'], '25_34');
      expect(analytics.mergedPersonProperties.containsKey('name'), isFalse);
    });
  });

  group('paywall', () {
    test('opening reports the offer that is actually on screen', () {
      paywallStore().dispatch(const PaywallOpenedAction('onboarding'));

      expect(analytics.propertiesOf('paywall_viewed'), {
        'presentation': 'onboarding',
        'offering_id': 'default',
        'product_id': 'yearly',
        'price': 49.99,
        'currency': 'USD',
        'trial_days': 14,
      });
    });

    test('an offering that fails to load is reported as a revenue outage', () {
      paywallStore().dispatch(const OfferingLoadedAction(null));

      expect(analytics.capturedNames, contains('paywall_offering_unavailable'));
    });

    test('a purchase that turns the user pro is reported as a trial start', () {
      final store = paywallStore();

      store.dispatch(const PaywallOpenedAction('onboarding'));
      store.dispatch(PurchasePackageAction(packageFixture()));
      store.dispatch(const PurchaseSucceededAction(isPro: true));

      expect(analytics.capturedNames, [
        'paywall_viewed',
        'paywall_purchase_started',
        'trial_started',
      ]);
      expect(analytics.propertiesOf('trial_started'), {
        'presentation': 'onboarding',
        'product_id': 'yearly',
        'price': 49.99,
        'currency': 'USD',
        'trial_days': 14,
      });
      expect(analytics.mergedPersonProperties['is_pro'], isTrue);
    });

    test('a purchase that resolves without pro is reported as cancelled', () {
      final store = paywallStore();

      store.dispatch(const PaywallOpenedAction('in_app'));
      store.dispatch(PurchasePackageAction(packageFixture()));
      store.dispatch(const PurchaseSucceededAction(isPro: false));

      expect(analytics.capturedNames, contains('purchase_cancelled'));
      expect(analytics.capturedNames, isNot(contains('trial_started')));
    });

    test('a failure is reported with a stable error code, not the message', () {
      final store = paywallStore();

      store.dispatch(const PaywallOpenedAction('onboarding'));
      store.dispatch(PurchasePackageAction(packageFixture()));
      store.dispatch(const PurchaseErrorAction('Réessaie plus tard', errorCode: 'networkError'));

      expect(analytics.propertiesOf('purchase_failed'), {
        'presentation': 'onboarding',
        'error_code': 'networkError',
      });
    });

    test('a status refresh outside a purchase reports nothing', () {
      paywallStore().dispatch(const PurchaseSucceededAction(isPro: false));

      expect(analytics.captured, isEmpty);
    });

    test('a restore reports whether a subscription was found', () {
      final store = paywallStore();

      store.dispatch(const RestorePurchasesAction());
      store.dispatch(const PurchaseSucceededAction(isPro: true));

      expect(analytics.propertiesOf('paywall_restore_result'), {'found': true});
    });

    test('leaving without buying reports the time spent on the paywall', () {
      final store = paywallStore();

      store.dispatch(const PaywallOpenedAction('in_app'));
      advance(const Duration(seconds: 25));
      store.dispatch(const PaywallClosedAction(presentation: 'in_app', purchased: false));

      expect(analytics.propertiesOf('paywall_dismissed'), {
        'presentation': 'in_app',
        'seconds_on_paywall': 25,
      });
    });

    test('leaving after buying is not a dismissal', () {
      final store = paywallStore();

      store.dispatch(const PaywallOpenedAction('onboarding'));
      store.dispatch(const PaywallClosedAction(presentation: 'onboarding', purchased: true));

      expect(analytics.capturedNames, isNot(contains('paywall_dismissed')));
    });
  });

  group('check-in', () {
    test('a completed check-in carries its shape, not its content', () {
      final store = analyticsStore();

      store.dispatch(const CheckInStartedAction(source: 'today_button'));
      advance(const Duration(seconds: 45));
      store.dispatch(
        SaveDayAction(
          DayEntry(
            date: today,
            averageFeeling: AverageFeeling.good,
            meaningScore: MeaningScore.much,
            hasNewExperience: true,
            livingIntentionIds: const ['a', 'b'],
            leaveATrace: const LeaveATrace(text: 'a private thought', imagePaths: ['one.jpg']),
          ),
        ),
      );

      final properties = analytics.propertiesOf('check_in_completed')!;
      expect(properties['intentions_lived_count'], 2);
      expect(properties['has_trace_text'], isTrue);
      expect(properties['photos_count'], 1);
      expect(properties['is_backfill'], isFalse);
      expect(properties['seconds_to_complete'], 45);
      expect(properties.values, isNot(contains('a private thought')));
    });

    test('logging an earlier day is flagged as a backfill', () {
      analyticsStore().dispatch(
        SaveDayAction(DayEntry(date: today.subtract(const Duration(days: 3)))),
      );

      final properties = analytics.propertiesOf('check_in_completed')!;
      expect(properties['is_backfill'], isTrue);
      expect(properties['day_offset'], 3);
    });

    test('closing the form without saving reports an abandon', () {
      final store = analyticsStore();

      store.dispatch(const CheckInStartedAction(source: 'notification', dayOffset: 1));
      advance(const Duration(seconds: 8));
      store.dispatch(const CheckInAbandonedAction());

      expect(analytics.propertiesOf('check_in_started'), {
        'source': 'notification',
        'day_offset': 1,
      });
      expect(analytics.propertiesOf('check_in_abandoned'), {'source': 'notification', 'seconds': 8});
    });

    test('a saved check-in is not also reported as abandoned', () {
      final store = analyticsStore();

      store.dispatch(const CheckInStartedAction(source: 'today_button'));
      store.dispatch(SaveDayAction(DayEntry(date: today)));
      store.dispatch(const CheckInAbandonedAction());

      expect(analytics.capturedNames, isNot(contains('check_in_abandoned')));
    });
  });

  group('streaks and rewards', () {
    test('a longer streak is reported as continued', () {
      final store = analyticsStore(
        initialState: AppState.initial().copyWith(streakState: const StreakState(count: 4)),
      );

      store.dispatch(const StreakRecalculatedAction(count: 5, bestEver: 5));

      expect(analytics.propertiesOf('streak_continued'), {'streak_length': 5, 'best_ever': 5});
    });

    test('a lost streak is reported with the length it reached', () {
      final store = analyticsStore(
        initialState: AppState.initial().copyWith(streakState: const StreakState(count: 9)),
      );

      store.dispatch(const StreakRecalculatedAction(count: 0, bestEver: 9));

      expect(analytics.propertiesOf('streak_broken'), {'previous_length': 9});
    });

    test('rewards restored at launch are not reported as new unlocks', () {
      analyticsStore().dispatch(const RewardsLoadedAction(unlocked: {RewardId.themeMatcha}));

      expect(analytics.captured, isEmpty);
    });

    test('only the newly unlocked reward is reported', () {
      final store = analyticsStore(
        initialState: AppState.initial().copyWith(
          rewardsState: const RewardsState(unlocked: {RewardId.themeMatcha}),
          streakState: const StreakState(count: 30),
        ),
      );

      store.dispatch(
        const RewardsLoadedAction(unlocked: {RewardId.themeMatcha, RewardId.appIconGold}),
      );

      expect(analytics.capturedNames, ['reward_unlocked']);
      expect(analytics.propertiesOf('reward_unlocked'), {
        'reward_id': RewardId.appIconGold.name,
        'streak_length': 30,
      });
    });
  });

  group('habit and settings', () {
    test('picking weekly intentions reports how many, and updates the person', () {
      analyticsStore().dispatch(const SetWeeklyIntentSelectionAction(['a', 'b']));

      expect(analytics.propertiesOf('weekly_intent_selected'), {
        'intents_count': 2,
        'intent_ids': ['a', 'b'],
      });
      expect(analytics.mergedPersonProperties['intents_count'], 2);
    });

    test('a weekly summary reports the days recorded that week', () {
      final store = analyticsStore(
        initialState: AppState.initial().copyWith(
          dayState: DayState(
            entries: {
              for (var i = 0; i < 3; i++)
                normalizeDay(today.subtract(Duration(days: i))): DayEntry(
                  date: today.subtract(Duration(days: i)),
                ),
              // Older than the week being summarised.
              normalizeDay(today.subtract(const Duration(days: 20))): DayEntry(
                date: today.subtract(const Duration(days: 20)),
              ),
            },
          ),
        ),
      );

      store.dispatch(const WeeklySummaryCompletedAction());

      expect(analytics.propertiesOf('weekly_summary_completed'), {'days_recorded': 3});
    });

    test('a notification tap is reported with its type', () {
      analyticsStore().dispatch(const NotificationTappedAction('daily_reminder'));

      expect(analytics.propertiesOf('notification_tapped'), {'type': 'daily_reminder'});
    });

    test('cosmetic changes are reported and the theme is kept on the person', () {
      final store = analyticsStore();

      store.dispatch(const SetAppThemeAction(AppThemeId.matcha));
      store.dispatch(const SetAppIconAction(AppIconId.defaultIcon));
      store.dispatch(const SetGridMotifAction(GridMotifId.dots));
      store.dispatch(const SetHomeTabIndexAction(1));

      expect(analytics.capturedNames, [
        'theme_changed',
        'app_icon_changed',
        'grid_motif_changed',
        'grid_view_changed',
      ]);
      expect(analytics.propertiesOf('grid_view_changed'), {'tab': 'year'});
      expect(analytics.mergedPersonProperties['theme'], AppThemeId.matcha.name);
    });

    test('editing the profile reports only the fields that changed', () {
      final previous = userFixture(lifespan: 90, gender: Gender.female);
      final store = analyticsStore(
        initialState: AppState.initial().copyWith(userState: UserState.success(previous)),
      );

      store.dispatch(
        UpdateUserAction(
          name: previous.name,
          dateOfBirth: previous.dateOfBirth,
          gender: previous.gender,
          lifespan: 95,
          weekStartDay: DateTime.sunday,
        ),
      );

      expect(analytics.propertiesOf('profile_updated'), {
        'fields_changed': ['lifespan', 'week_start_day'],
        'fields_changed_count': 2,
      });
      expect(analytics.mergedPersonProperties['lifespan'], 95);
    });
  });

  group('permissions and identity', () {
    test('a permission answer is only reported when we asked for it', () {
      final store = analyticsStore();

      store.dispatch(const PushNotificationEnabledLoadedAction(true));
      expect(analytics.captured, isEmpty);

      store.dispatch(const RequestNotificationPermissionAction());
      store.dispatch(const PushNotificationEnabledLoadedAction(true));

      expect(analytics.propertiesOf('notification_permission_result'), {'granted': true});
      expect(analytics.mergedPersonProperties['notification_permission'], isTrue);
    });

    test('clearing the user detaches the person from the install', () {
      analyticsStore().dispatch(const ClearUserAction());

      expect(analytics.resetCount, 1);
    });

    test('an arbitrary tracked event is passed through untouched', () {
      final event = AnalyticsEvent.proFeatureGateHit(feature: 'pro_badge');

      analyticsStore().dispatch(TrackAnalyticsEventAction(event));

      expect(analytics.captured, [event]);
    });
  });
}
