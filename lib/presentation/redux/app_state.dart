import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weeksalive/presentation/remote_config/remote_config_state.dart';

part 'app_state.freezed.dart';

@freezed
class AppState with _$AppState {
  const factory AppState({
    required RemoteConfigState remoteConfigState,
  }) = _AppState;

  factory AppState.initial() {
    return const AppState(
      remoteConfigState: RemoteConfigState(),
    );
  }
}
