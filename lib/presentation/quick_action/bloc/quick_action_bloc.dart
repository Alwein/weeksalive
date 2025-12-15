import 'package:bloc/bloc.dart';
import 'package:flutter_fast_template/core/texts/strings.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quick_actions/quick_actions.dart';

part 'quick_action_bloc.freezed.dart';
part 'quick_action_event.dart';
part 'quick_action_state.dart';

class QuickActionBloc extends Bloc<QuickActionEvent, QuickActionState> {
  QuickActionBloc() : super(const QuickActionState()) {
    on<QuickActionEvent>(
      (event, emit) => event.map(
        started: (e) => _onStarted(e, emit),
        trigger: (e) => _onTrigger(e, emit),
      ),
    );

    _initQuickActions();
  }

  final QuickActions _quickActions = const QuickActions();

  void _initQuickActions() {
    _quickActions.initialize((shortcutType) {
      add(QuickActionEvent.trigger(type: shortcutType));
    });

    _quickActions.setShortcutItems(<ShortcutItem>[
      ShortcutItem(
        type: 'feedback',
        localizedTitle: Strings.quickActionFeedbackTitle,
        localizedSubtitle: Strings.quickActionFeedbackSubtitle,
        icon: 'compose',
      ),
    ]);
  }

  Future<void> _onStarted(_Started event, Emitter<QuickActionState> emit) async {
    // Nothing to do here for now
  }

  Future<void> _onTrigger(_Trigger event, Emitter<QuickActionState> emit) async {
    emit(
      state.copyWith(
        status: QuickActionStatus.triggered(
          type: event.type,
          timestamp: DateTime.now(),
        ),
      ),
    );
  }
}
