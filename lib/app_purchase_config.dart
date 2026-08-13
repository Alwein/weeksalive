import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class AppPurchaseConfig {
  final Store store;
  final String apiKey;
  static AppPurchaseConfig? _instance;

  /// [appUserId] is the persisted install id, also used as the PostHog distinct
  /// id. Sharing it is what lets RevenueCat's server-side revenue events (trial
  /// conversion, renewal, churn, refund) attach to the right PostHog person.
  static Future<void> initializeFromEnv(DotEnv dotenvInstance, {String? appUserId}) async {
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

    final configuration = PurchasesConfiguration(_instance!.apiKey)..appUserID = appUserId;
    await Purchases.configure(configuration);

    if (appUserId != null) {
      // What RevenueCat's PostHog integration reads to pick the person its
      // revenue events belong to. It falls back to the app user id, which is
      // the same value, but only while nothing has aliased the user.
      await Purchases.setAttributes({r'$posthogUserId': appUserId});
    }
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
