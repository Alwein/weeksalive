import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_fast_template/app_purchase_config.dart';
import 'package:flutter_fast_template/bloc_observer.dart';
import 'package:flutter_fast_template/core/dependency_injection/locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await dotenv.load(fileName: 'env/.env');

  await AppPurchaseConfig.initializeFromEnv(dotenv);

  await EasyLocalization.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final sharedPreferences = await SharedPreferences.getInstance();

  Locator.initialize(sharedPreferences);

  Bloc.observer = AppBlocObserver();
}
