part of 'locator.dart';

class RepositoriesLocator {
  static void register(SharedPreferences sharedPreferences) {
    _registerCrashlyticsRepository();
    _registerRemoteConfigRepository();
    _registerUserRepository();
    _registerAuthRepository();
    _registerConfigurationRepository(sharedPreferences);
    _registerAppOpenCountRepository(sharedPreferences);
    _registerOnboardingRepository(sharedPreferences);
  }

  static void _registerCrashlyticsRepository() {
    GetIt.I.registerLazySingleton<CrashlyticsRepository>(() => CrashlyticsRepositoryImpl());
  }

  static void _registerRemoteConfigRepository() {
    GetIt.I.registerLazySingleton<RemoteConfigRepository>(
      () => RemoteConfigRepository(
        crashlyticsRepository: Locator.get<CrashlyticsRepository>(),
      ),
    );
  }

  static void _registerUserRepository() {
    GetIt.I.registerLazySingleton<UserRepository>(
      () => UserRepository(
        firestoreUserQueries: Locator.get<FirestoreUserQueries>(),
        crashlyticsRepository: Locator.get<CrashlyticsRepository>(),
      ),
    );
  }

  static void _registerAuthRepository() {
    GetIt.I.registerLazySingleton<AuthRepository>(
      () => AuthRepository(
        userRepository: Locator.get<UserRepository>(),
        crashlyticsRepository: Locator.get<CrashlyticsRepository>(),
      ),
    );
  }

  static void _registerConfigurationRepository(SharedPreferences sharedPreferences) {
    GetIt.I.registerLazySingleton<ConfigurationRepository>(() => ConfigurationRepository());
  }

  static void _registerAppOpenCountRepository(SharedPreferences sharedPreferences) {
    GetIt.I.registerLazySingleton<AppOpenCountRepository>(
      () => AppOpenCountRepository(preferences: sharedPreferences),
    );
  }

  static void _registerOnboardingRepository(SharedPreferences sharedPreferences) {
    GetIt.I.registerLazySingleton<OnboardingRepository>(() => OnboardingRepository(preferences: sharedPreferences));
  }
}
