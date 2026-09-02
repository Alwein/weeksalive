import 'package:in_app_review/in_app_review.dart';
import 'package:redux/redux.dart';
import 'package:weeksalive/data/analytics/analytics_events.dart';
import 'package:weeksalive/data/review/review_prompt_repository.dart';
import 'package:weeksalive/data/review/review_prompt_store.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/presentation/redux/analytics/analytics_actions.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/day/day_actions.dart';
import 'package:weeksalive/presentation/redux/review_prompt/review_prompt_actions.dart';

class ReviewPromptMiddleware extends MiddlewareClass<AppState> {
  ReviewPromptMiddleware({
    required ReviewPromptStore reviewPromptStore,
    InAppReview? inAppReview,
    Future<bool> Function()? isReviewAvailable,
    Future<void> Function()? requestReview,
  })  : _reviewPromptStore = reviewPromptStore,
        _inAppReview = inAppReview ?? InAppReview.instance,
        _isReviewAvailable = isReviewAvailable,
        _requestReview = requestReview;

  final ReviewPromptStore _reviewPromptStore;
  final InAppReview _inAppReview;
  final Future<bool> Function()? _isReviewAvailable;
  final Future<void> Function()? _requestReview;

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is SaveDayAction) {
      await _recordCheckIn(action);
    }

    if (action is TryReviewPromptAction) {
      await _maybeRequestReview(store, action.source);
    }
  }

  Future<void> _recordCheckIn(SaveDayAction action) async {
    if (_reviewPromptStore.hasRequested) return;

    final dayOffset = normalizeDay(DateTime.now()).difference(normalizeDay(action.entry.date)).inDays;
    if (dayOffset != 0) return;

    await _reviewPromptStore.incrementCheckInCount();
  }

  Future<void> _maybeRequestReview(Store<AppState> store, String source) async {
    if (_reviewPromptStore.hasRequested) return;
    if (_reviewPromptStore.checkInCount < ReviewPromptRepository.triggerAtCheckIn) return;

    final isAvailable = _isReviewAvailable != null
        ? await _isReviewAvailable()
        : await _inAppReview.isAvailable();
    if (!isAvailable) return;

    await _reviewPromptStore.markRequested();

    try {
      store.dispatch(
        TrackAnalyticsEventAction(AnalyticsEvent.reviewPromptShown(source: source)),
      );
    } catch (_) {
      // Store torn down (e.g. in tests) during the async gap.
    }

    if (_requestReview != null) {
      await _requestReview();
    } else {
      await _inAppReview.requestReview();
    }
  }
}
