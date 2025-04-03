part of 'locator.dart';

class ServicesLocator {
  static void register() {
    _registerFirestoreUserQueries();
  }

  static void _registerFirestoreUserQueries() {
    GetIt.I.registerLazySingleton<FirestoreUserQueries>(() => FirestoreUserQueries());
  }
}
