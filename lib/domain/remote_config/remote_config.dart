import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_config.freezed.dart';

@freezed
abstract class AppRemoteConfig with _$AppRemoteConfig {
  const factory AppRemoteConfig({
    @Default("1.0.0") String minAppVersion,
  }) = _AppRemoteConfig;
}
