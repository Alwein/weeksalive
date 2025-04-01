import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class AppPurchaseConfig {
  final Store store;
  final String apiKey;
  static AppPurchaseConfig? _instance;

  static Future<void> initializeFromEnv(DotEnv dotenvInstance) async {
    if (kIsWeb) {
      throw UnsupportedError('RevenueCat not configured for web');
    }

    _instance = switch (defaultTargetPlatform) {
      TargetPlatform.iOS => AppPurchaseConfig(
          store: Store.appStore,
          apiKey: dotenvInstance.env['REVENUE_CAT_APPLE_API_KEY']!,
        ),
      TargetPlatform.android => AppPurchaseConfig(
          store: Store.playStore,
          apiKey: dotenvInstance.env['REVENUE_CAT_GOOGLE_API_KEY']!,
        ),
      _ => throw UnsupportedError('RevenueCat not configured for this platform'),
    };

    final configuration = PurchasesConfiguration(_instance!.apiKey);
    await Purchases.configure(configuration);
  }

  factory AppPurchaseConfig({required Store store, required String apiKey}) {
    _instance ??= AppPurchaseConfig._internal(store, apiKey);
    return _instance!;
  }

  AppPurchaseConfig._internal(this.store, this.apiKey);

  static AppPurchaseConfig get instance {
    if (_instance == null) {
      throw StateError('AppPurchaseConfig not initialized. Call initializeFromEnv first.');
    }
    return _instance!;
  }

  static bool isForAppleStore() => instance.store == Store.appStore;

  static bool isForGooglePlay() => instance.store == Store.playStore;
}
