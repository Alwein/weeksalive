import 'package:weeksalive/presentation/redux/review_prompt/review_prompt_actions.dart';
import 'package:weeksalive/presentation/redux/review_prompt/review_prompt_state.dart';

ReviewPromptState reviewPromptReducer(ReviewPromptState state, dynamic action) {
  if (action is FeedbackPulseRequestedAction) {
    return state.copyWith(pulsePending: true, pulseSource: action.source);
  }
  if (action is FeedbackPulseResolvedAction) {
    return state.copyWith(pulsePending: false);
  }
  return state;
}
