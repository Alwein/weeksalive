part of 'app_bloc.dart';

@freezed
class AppState with _$AppState {
  const factory AppState({
    AppRemoteConfig? appRemoteConfig,
    @Default(false) bool shouldForceUpdate,
    @Default(true) bool isLoading,
  }) = _AppState;
}
