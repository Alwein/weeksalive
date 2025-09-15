part of 'locator.dart';

class BlocsLocator {
  static void register() {
    _registerAppBlocSingleton();
    _registerAuthBlocSingleton();
    _registerOnboardingWrapperBlocFactory();
    _registerUserBlocSingleton();
  }

  static void _registerAppBlocSingleton() {
    GetIt.I.registerLazySingleton<AppBloc>(
      () => AppBloc(
        remoteConfigRepository: Locator.get<RemoteConfigRepository>(),
        configurationRepository: Locator.get<ConfigurationRepository>(),
        appOpenCountRepository: Locator.get<AppOpenCountRepository>(),
      ),
    );
  }

  static void _registerAuthBlocSingleton() {
    GetIt.I.registerLazySingleton<AuthBloc>(
      () => AuthBloc(Locator.get<AuthRepository>()),
    );
  }

  static void _registerOnboardingWrapperBlocFactory() {
    GetIt.I.registerFactory<OnboardingWrapperBloc>(
      () => OnboardingWrapperBloc(Locator.get<OnboardingRepository>()),
    );
  }

  static void _registerUserBlocSingleton() {
    GetIt.I.registerLazySingleton<UserBloc>(
      () => UserBloc(
        userRepository: Locator.get<UserRepository>(),
        configurationRepository: Locator.get<ConfigurationRepository>(),
        analyticsRepository: Locator.get<AnalyticsRepository>(),
      ),
    );
  }
}
