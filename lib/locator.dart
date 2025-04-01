import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Locator {
  static final Locator _instance = Locator._internal();

  factory Locator() {
    return _instance;
  }

  final GetIt getIt = GetIt.instance;

  Locator._internal();

  T get<T extends Object>() => getIt.get<T>();

  static void initialize(SharedPreferences shredPreferences) {
    // registerAuthBloc();
  }

  // void registerAuthBloc() => getIt.registerLazySingleton<AuthBloc>(
  //       () => AuthBloc(GetIt.I.get<AuthRepository>()),
  //     );
}
