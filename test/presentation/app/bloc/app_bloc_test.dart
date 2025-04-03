import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_fast_template/domain/remote_config/remote_config.dart';
import 'package:flutter_fast_template/presentation/app/bloc/app_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../utils/mocks.dart';

void main() {
  late MockRemoteConfigRepository remoteConfigRepository;
  late MockConfigurationRepository configurationRepository;
  late MockAppOpenCountRepository appOpenCountRepository;

  setUp(() {
    remoteConfigRepository = MockRemoteConfigRepository();
    configurationRepository = MockConfigurationRepository();
    appOpenCountRepository = MockAppOpenCountRepository();
  });

  AppBloc buildBloc() => AppBloc(
        remoteConfigRepository: remoteConfigRepository,
        configurationRepository: configurationRepository,
        appOpenCountRepository: appOpenCountRepository,
      );

  test('initial state', () {
    expect(
        buildBloc().state,
        const AppState(
          appRemoteConfig: null,
          shouldForceUpdate: false,
          isLoading: true,
        ));
  });

  group('onInit', () {
    blocTest<AppBloc, AppState>(
      'should emit AppState with shouldForceUpdate to true',
      build: buildBloc,
      setUp: () {
        remoteConfigRepository.withRemoteConfig(const AppRemoteConfig(minAppVersion: "1.0.1"));
        configurationRepository.withAppVersion("1.0.0");
        appOpenCountRepository.withAppOpenCount(0);
      },
      act: (bloc) => bloc.add(const AppEvent.initialize()),
      expect: () => const <AppState>[
        AppState(
          appRemoteConfig: AppRemoteConfig(minAppVersion: "1.0.1"),
          shouldForceUpdate: true,
          isLoading: false,
        ),
      ],
      verify: (bloc) {
        verify(() => appOpenCountRepository.incrementAppOpenCount()).called(1);
      },
    );

    blocTest<AppBloc, AppState>(
      'should emit AppState with shouldForceUpdate to false',
      build: buildBloc,
      setUp: () {
        remoteConfigRepository.withRemoteConfig(const AppRemoteConfig(minAppVersion: "1.0.0"));
        configurationRepository.withAppVersion("1.0.0");
        appOpenCountRepository.withAppOpenCount(1);
      },
      act: (bloc) => bloc.add(const AppEvent.initialize()),
      expect: () => const <AppState>[
        AppState(
          appRemoteConfig: AppRemoteConfig(minAppVersion: "1.0.0"),
          shouldForceUpdate: false,
          isLoading: false,
        ),
      ],
      verify: (bloc) {
        verify(() => appOpenCountRepository.incrementAppOpenCount()).called(1);
      },
    );
  });
}
