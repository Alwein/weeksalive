import 'package:weeksalive/domain/feedback/feedback_sentiment.dart';

/// Dispatched after a check-in to let the middleware decide whether the
/// one-time feedback pulse should be shown.
class TryReviewPromptAction {
  const TryReviewPromptAction({this.source = 'third_check_in'});

  final String source;
}

/// The middleware decided the feedback pulse should be shown; the home
/// listener reacts.
class FeedbackPulseRequestedAction {
  const FeedbackPulseRequestedAction({required this.source});

  final String source;
}

/// The user tapped one of the pulse answers.
class FeedbackPulseAnsweredAction {
  const FeedbackPulseAnsweredAction({required this.sentiment, required this.source});

  final FeedbackSentiment sentiment;
  final String source;
}

/// The feedback sheet was closed. [answered] is false when the user dismissed
/// the pulse without picking an answer.
class FeedbackPulseResolvedAction {
  const FeedbackPulseResolvedAction({required this.answered});

  final bool answered;
}

/// The user sent a free-text message from the feedback form.
///
/// [sentiment] is null when the form was opened directly (from the profile)
/// rather than after a pulse answer.
class FeedbackSubmittedAction {
  const FeedbackSubmittedAction({required this.message, required this.source, this.sentiment});

  final String message;
  final String source;
  final FeedbackSentiment? sentiment;
}

/// Asks the platform for its native review prompt, after a positive pulse.
class RequestStoreReviewAction {
  const RequestStoreReviewAction({required this.source});

  final String source;
}
