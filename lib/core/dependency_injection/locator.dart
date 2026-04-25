import 'package:weeksalive/data/analytics/analytics_repository.dart';
import 'package:weeksalive/data/app_open_count/app_open_count_repository.dart';
import 'package:weeksalive/data/auth/auth_repository.dart';
import 'package:weeksalive/data/crashlytics/crashlytics_repository.dart';
import 'package:weeksalive/data/device/configuration_repository.dart';
import 'package:weeksalive/data/onboarding/onboarding_repository.dart';
import 'package:weeksalive/data/remote_config/remote_config_repository.dart';
import 'package:weeksalive/data/services/firestore_user_queries.dart';
import 'package:weeksalive/data/user/user_repository.dart';
import 'package:weeksalive/presentation/app/bloc/app_bloc.dart';
import 'package:weeksalive/presentation/auth/bloc/auth_bloc.dart';
import 'package:weeksalive/presentation/onboarding/wrapper/bloc/onboarding_wrapper_bloc.dart';
import 'package:weeksalive/presentation/user/bloc/user_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'blocs_locator.dart';
part 'repositories_locator.dart';
part 'services_locator.dart';

class Locator {
  static final Locator _instance = Locator._internal();

  factory Locator() {
    return _instance;
  }

  Locator._internal();

  static T get<T extends Object>() => GetIt.I.get<T>();

  static void initialize(SharedPreferences sharedPreferences) {
    ServicesLocator.register();
    RepositoriesLocator.register(sharedPreferences);
    BlocsLocator.register();
  }
}
