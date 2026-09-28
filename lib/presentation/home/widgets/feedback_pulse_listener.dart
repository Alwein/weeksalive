import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:weeksalive/presentation/feedback/feedback_sheet.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/review_prompt/review_prompt_actions.dart';

/// Shows the one-time feedback pulse once the middleware flags it as pending
/// (see [FeedbackPulseRequestedAction]), and asks for a store review when the
/// user answered it positively.
class FeedbackPulseListener extends StatefulWidget {
  const FeedbackPulseListener({super.key, required this.child});

  final Widget child;

  @override
  State<FeedbackPulseListener> createState() => _FeedbackPulseListenerState();
}

class _FeedbackPulseListenerState extends State<FeedbackPulseListener> {
  bool _shown = false;

  void _tryShow(Store<AppState> store, {required bool pending}) {
    if (_shown || !pending) return;

    _shown = true;
    final source = store.state.reviewPromptState.pulseSource;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final result = await FeedbackSheet.show(context, source: source);

      try {
        store.dispatch(FeedbackPulseResolvedAction(answered: result != FeedbackSheetResult.dismissed));
        if (result == FeedbackSheetResult.positive) {
          // Let the sheet finish closing before the system prompt appears.
          await Future<void>.delayed(const Duration(milliseconds: 400));
          store.dispatch(RequestStoreReviewAction(source: source));
        }
      } catch (_) {
        // Store torn down during the async gap.
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, bool>(
      converter: (store) => store.state.reviewPromptState.pulsePending,
      distinct: true,
      onInitialBuild: (pending) => _tryShow(StoreProvider.of<AppState>(context), pending: pending),
      onWillChange: (previous, next) {
        if (next && previous != true) {
          _tryShow(StoreProvider.of<AppState>(context), pending: next);
        }
      },
      builder: (context, _) => widget.child,
    );
  }
}
