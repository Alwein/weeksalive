import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weeksalive/presentation/feedback_bottom_sheet/feedback_bottom_sheet.dart';
import 'package:weeksalive/presentation/quick_action/bloc/quick_action_bloc.dart';

class QuickActionWrapper extends StatelessWidget {
  const QuickActionWrapper({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QuickActionBloc>(
      create: (context) => QuickActionBloc()..add(const QuickActionEvent.started()),
      child: BlocListener<QuickActionBloc, QuickActionState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          state.status.mapOrNull(
            triggered: (triggered) {
              if (triggered.type == 'feedback') {
                FeedbackBottomSheet.show(context);
              }
            },
          );
        },
        child: child,
      ),
    );
  }
}
