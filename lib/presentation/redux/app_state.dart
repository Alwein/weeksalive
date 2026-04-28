import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weeksalive/presentation/redux/remote_config/remote_config_state.dart';
import 'package:weeksalive/presentation/redux/user/user_state.dart';

part 'app_state.freezed.dart';

@freezed
class AppState with _$AppState {
  const factory AppState({
    required RemoteConfigState remoteConfigState,
    required UserState userState,
  }) = _AppState;

  factory AppState.initial() {
    return const AppState(
      remoteConfigState: RemoteConfigState(),
      userState: UserState.loading(),
    );
  }
}
