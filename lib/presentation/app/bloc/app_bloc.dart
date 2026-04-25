import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:weeksalive/core/utils/app_version_utils.dart';
import 'package:weeksalive/data/app_open_count/app_open_count_repository.dart';
import 'package:weeksalive/data/device/configuration_repository.dart';
import 'package:weeksalive/data/remote_config/remote_config_repository.dart';
import 'package:weeksalive/domain/remote_config/remote_config.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_bloc.freezed.dart';
part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required RemoteConfigRepository remoteConfigRepository,
    required ConfigurationRepository configurationRepository,
    required AppOpenCountRepository appOpenCountRepository,
  })  : _remoteConfigRepository = remoteConfigRepository,
        _configurationRepository = configurationRepository,
        _appOpenCountRepository = appOpenCountRepository,
        super(const AppState()) {
    on<AppEvent>(
      (event, emit) => event.map(
        initialize: (_) => _onInit(emit),
      ),
    );
  }

  final RemoteConfigRepository _remoteConfigRepository;
  final ConfigurationRepository _configurationRepository;
  final AppOpenCountRepository _appOpenCountRepository;

  FutureOr<void> _onInit(Emitter<AppState> emit) async {
    final appRemoteConfig = await _remoteConfigRepository.getRemoteConfig();

    emit(
      AppState(
        appRemoteConfig: appRemoteConfig,
        shouldForceUpdate: await _shouldForceUpdate(appRemoteConfig),
        isLoading: false,
      ),
    );

    await _appOpenCountRepository.incrementAppOpenCount();
  }

  Future<bool> _shouldForceUpdate(AppRemoteConfig? remoteConfig) async {
    if (remoteConfig == null) {
      return false;
    }
    final actualAppVersion = await _configurationRepository.getAppVersion();
    return AppVersionUtils.shouldForceUpdate(actualAppVersion, remoteConfig.minAppVersion);
  }
}
