part of 'quick_action_bloc.dart';

@freezed
class QuickActionState with _$QuickActionState {
  const factory QuickActionState({
    @Default(QuickActionStatus.initial()) QuickActionStatus status,
  }) = _QuickActionState;
}

@freezed
class QuickActionStatus with _$QuickActionStatus {
  const factory QuickActionStatus.initial() = _Initial;
  const factory QuickActionStatus.triggered({
    required String type,
    required DateTime timestamp,
  }) = _Triggered;
}
