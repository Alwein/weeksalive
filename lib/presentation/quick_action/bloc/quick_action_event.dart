part of 'quick_action_bloc.dart';

@freezed
class QuickActionEvent with _$QuickActionEvent {
  const factory QuickActionEvent.started() = _Started;
  const factory QuickActionEvent.trigger({required String type}) = _Trigger;
}

