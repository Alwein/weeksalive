/// The one-tap answer to the in-app feedback pulse.
///
/// Only [positive] leads to the native store review prompt; the other two open
/// a free-text form so the user can tell us what is missing.
enum FeedbackSentiment {
  negative,
  neutral,
  positive,
}
