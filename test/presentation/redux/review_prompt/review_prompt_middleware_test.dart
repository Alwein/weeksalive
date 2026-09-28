import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/domain/feedback/feedback_sentiment.dart';
import 'package:weeksalive/presentation/redux/analytics/analytics_middleware.dart';
import 'package:weeksalive/presentation/redux/app_reducer.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/day/day_actions.dart';
import 'package:weeksalive/presentation/redux/review_prompt/review_prompt_actions.dart';
import 'package:weeksalive/presentation/redux/review_prompt/review_prompt_middleware.dart';

import '../../../helpers/fake_analytics_repository.dart';
import '../../../helpers/test_app_state.dart';
import '../../../mocks.dart';

Future<void> _waitForMiddleware() => Future<void>.delayed(const Duration(milliseconds: 50));

Store<AppState> _reviewPromptStore({
  required FakeReviewPromptStore reviewPromptStore,
  required FakeAnalyticsRepository analyticsRepository,
  Future<bool> Function()? isReviewAvailable,
  Future<void> Function()? requestReview,
}) {
  return Store<AppState>(
    appReducer,
    initialState: initialAppState(),
    middleware: [
      ReviewPromptMiddleware(
        reviewPromptStore: reviewPromptStore,
        isReviewAvailable: isReviewAvailable ?? () async => true,
        requestReview: requestReview ?? () async {},
      ).call,
      AnalyticsMiddleware(
        analyticsRepository: analyticsRepository,
        installRepository: FakeInstallRepository(),
      ).call,
    ],
  );
}

DayEntry todayEntry() => DayEntry(date: DateTime.now());

DayEntry yesterdayEntry() {
  final yesterday = normalizeDay(DateTime.now()).subtract(const Duration(days: 1));
  return DayEntry(date: yesterday);
}

void main() {
  group('ReviewPromptMiddleware', () {
    late FakeReviewPromptStore reviewPromptStore;
    late FakeAnalyticsRepository analyticsRepository;
    var reviewRequested = false;

    setUp(() {
      reviewPromptStore = FakeReviewPromptStore();
      analyticsRepository = FakeAnalyticsRepository();
      reviewRequested = false;
    });

    test('increments check-in count for today entries only', () async {
      final store = _reviewPromptStore(
        reviewPromptStore: reviewPromptStore,
        analyticsRepository: analyticsRepository,
      );

      store.dispatch(SaveDayAction(todayEntry()));
      await _waitForMiddleware();
      store.dispatch(SaveDayAction(yesterdayEntry()));
      await _waitForMiddleware();
      store.dispatch(SaveDayAction(todayEntry()));
      await _waitForMiddleware();

      expect(reviewPromptStore.checkInCount, 2);

      store.teardown();
    });

    test('does not show the feedback pulse before the third check-in', () async {
      final store = _reviewPromptStore(
        reviewPromptStore: reviewPromptStore,
        analyticsRepository: analyticsRepository,
      );

      store.dispatch(SaveDayAction(todayEntry()));
      await _waitForMiddleware();
      store.dispatch(const TryReviewPromptAction());
      await _waitForMiddleware();

      expect(store.state.reviewPromptState.pulsePending, isFalse);
      expect(reviewPromptStore.hasRequested, isFalse);

      store.teardown();
    });

    test('shows the feedback pulse, not the native review, on the third check-in', () async {
      final store = _reviewPromptStore(
        reviewPromptStore: reviewPromptStore,
        analyticsRepository: analyticsRepository,
        requestReview: () async {
          reviewRequested = true;
        },
      );

      for (var i = 0; i < 3; i++) {
        store.dispatch(SaveDayAction(todayEntry()));
        await _waitForMiddleware();
      }

      store.dispatch(const TryReviewPromptAction());
      await _waitForMiddleware();

      expect(store.state.reviewPromptState.pulsePending, isTrue);
      expect(store.state.reviewPromptState.pulseSource, 'third_check_in');
      expect(reviewPromptStore.hasRequested, isTrue);
      expect(reviewRequested, isFalse);
      expect(analyticsRepository.propertiesOf('feedback_pulse_shown')?['source'], 'third_check_in');

      store.teardown();
    });

    test('does not show the feedback pulse again after it has been shown', () async {
      final store = _reviewPromptStore(
        reviewPromptStore: reviewPromptStore,
        analyticsRepository: analyticsRepository,
      );

      for (var i = 0; i < 3; i++) {
        store.dispatch(SaveDayAction(todayEntry()));
        await _waitForMiddleware();
      }

      store.dispatch(const TryReviewPromptAction());
      await _waitForMiddleware();
      store.dispatch(const FeedbackPulseResolvedAction(answered: true));

      store.dispatch(SaveDayAction(todayEntry()));
      await _waitForMiddleware();
      store.dispatch(const TryReviewPromptAction());
      await _waitForMiddleware();

      expect(store.state.reviewPromptState.pulsePending, isFalse);
      expect(
        analyticsRepository.capturedNames.where((name) => name == 'feedback_pulse_shown'),
        hasLength(1),
      );

      store.teardown();
    });

    test('requests the native review after a positive answer', () async {
      final store = _reviewPromptStore(
        reviewPromptStore: reviewPromptStore,
        analyticsRepository: analyticsRepository,
        requestReview: () async {
          reviewRequested = true;
        },
      );

      store.dispatch(const RequestStoreReviewAction(source: 'third_check_in'));
      await _waitForMiddleware();

      expect(reviewRequested, isTrue);
      expect(analyticsRepository.propertiesOf('review_prompt_shown')?['source'], 'third_check_in');

      store.teardown();
    });

    test('does not request the native review when it is unavailable', () async {
      final store = _reviewPromptStore(
        reviewPromptStore: reviewPromptStore,
        analyticsRepository: analyticsRepository,
        isReviewAvailable: () async => false,
        requestReview: () async {
          reviewRequested = true;
        },
      );

      store.dispatch(const RequestStoreReviewAction(source: 'third_check_in'));
      await _waitForMiddleware();

      expect(reviewRequested, isFalse);
      expect(analyticsRepository.capturedNames, isNot(contains('review_prompt_shown')));

      store.teardown();
    });

    test('tracks pulse answers, dismissals and submitted feedback', () async {
      final store = _reviewPromptStore(
        reviewPromptStore: reviewPromptStore,
        analyticsRepository: analyticsRepository,
      );

      store.dispatch(const FeedbackPulseRequestedAction(source: 'third_check_in'));
      store.dispatch(const FeedbackPulseResolvedAction(answered: false));
      store.dispatch(
        const FeedbackPulseAnsweredAction(sentiment: FeedbackSentiment.negative, source: 'third_check_in'),
      );
      store.dispatch(
        const FeedbackSubmittedAction(
          message: 'More themes',
          source: 'third_check_in',
          sentiment: FeedbackSentiment.negative,
        ),
      );
      await _waitForMiddleware();

      expect(store.state.reviewPromptState.pulsePending, isFalse);
      expect(analyticsRepository.propertiesOf('feedback_pulse_dismissed')?['source'], 'third_check_in');
      expect(analyticsRepository.propertiesOf('feedback_pulse_answered'), {
        'sentiment': 'negative',
        'source': 'third_check_in',
      });
      expect(analyticsRepository.propertiesOf('feedback_submitted'), {
        'message': 'More themes',
        'message_length': 11,
        'source': 'third_check_in',
        'sentiment': 'negative',
      });

      store.teardown();
    });
  });
}
