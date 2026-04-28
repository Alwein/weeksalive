import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weeksalive/domain/remote_config/remote_config.dart';

part 'remote_config_state.freezed.dart';

@freezed
class RemoteConfigState with _$RemoteConfigState {
  const factory RemoteConfigState({
    AppRemoteConfig? remoteConfig,
  }) = _RemoteConfigState;
}
