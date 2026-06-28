import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tiktok_events_sdk/tiktok_events_sdk.dart';
import 'package:weeksalive/core/utils/logger.dart';

class TikTokEventsRepository {
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  static bool isConfigured(DotEnv dotenv) {
    const keys = [
      'TIKTOK_IOS_APP_ID',
      'TIKTOK_IOS_ID',
      'TIKTOK_ANDROID_APP_ID',
      'TIKTOK_ANDROID_ID',
    ];
    return keys.every((key) {
      final value = dotenv.env[key];
      return value != null && value.isNotEmpty;
    });
  }

  Future<void> initializeFromEnv(DotEnv dotenv, {required bool isDebugMode}) async {
    if (!isConfigured(dotenv)) {
      log.w('TikTok Events SDK not configured. Skipping initialization.');
      return;
    }

    try {
      log.i('Initializing TikTok Events SDK...');

      const iosOptions = TikTokIosOptions(
        disableTracking: false,
        disableAutomaticTracking: true,
        disableSKAdNetworkSupport: false,
      );

      const androidOptions = TikTokAndroidOptions(
        disableAutoStart: false,
        enableAutoIapTrack: false,
        disableAdvertiserIDCollection: false,
      );

      await TikTokEventsSdk.initSdk(
        androidAppId: dotenv.env['TIKTOK_ANDROID_APP_ID']!,
        tikTokAndroidId: dotenv.env['TIKTOK_ANDROID_ID']!,
        iosAppId: dotenv.env['TIKTOK_IOS_APP_ID']!,
        tiktokIosId: dotenv.env['TIKTOK_IOS_ID']!,
        isDebugMode: isDebugMode,
        logLevel: isDebugMode ? TikTokLogLevel.debug : TikTokLogLevel.info,
        androidOptions: androidOptions,
        iosOptions: iosOptions,
      );

      _isInitialized = true;
      log.i('TikTok Events SDK initialized successfully');
    } catch (e, stackTrace) {
      log.e('Failed to initialize TikTok Events SDK', error: e, stackTrace: stackTrace);
    }
  }

  Future<void> identifyUser({
    String? externalId,
    String? externalUserName,
    String? phoneNumber,
    String? email,
  }) async {
    if (!_isInitialized) {
      log.w('TikTok Events SDK not initialized. Skipping user identification.');
      return;
    }

    try {
      await TikTokEventsSdk.identify(
        identifier: TikTokIdentifier(
          externalId: externalId ?? '',
          externalUserName: externalUserName ?? '',
          phoneNumber: phoneNumber ?? '',
          email: email ?? '',
        ),
      );
      log.i('TikTok user identified: $externalId');
    } catch (e, stackTrace) {
      log.e('Failed to identify TikTok user', error: e, stackTrace: stackTrace);
    }
  }

  Future<void> logEvent({
    required String eventName,
    String? eventId,
    EventProperties? properties,
  }) async {
    if (!_isInitialized) {
      log.w('TikTok Events SDK not initialized. Skipping event: $eventName');
      return;
    }

    try {
      await TikTokEventsSdk.logEvent(
        event: TikTokEvent(
          eventName: eventName,
          eventId: eventId,
          properties: properties,
        ),
      );
      log.d('TikTok event logged: $eventName');
    } catch (e, stackTrace) {
      log.e('Failed to log TikTok event: $eventName', error: e, stackTrace: stackTrace);
    }
  }

  Future<void> logCompleteRegistration({
    String? userId,
    String? registrationMethod,
  }) async {
    await logEvent(
      eventName: 'CompleteRegistration',
      properties: EventProperties(
        customProperties: {
          if (userId != null) 'user_id': userId,
          if (registrationMethod != null) 'method': registrationMethod,
        },
      ),
    );
  }

  Future<void> logPurchase({
    required double value,
    required String currency,
    String? contentId,
    String? contentName,
    int? quantity,
  }) async {
    await logEvent(
      eventName: 'Purchase',
      properties: EventProperties(
        value: value,
        currency: CurrencyCode.fromString(currency.toUpperCase()) ?? CurrencyCode.USD,
        contentId: contentId,
        contentName: contentName,
        quantity: quantity,
      ),
    );
  }

  Future<void> logSubscribe({
    required double value,
    required String currency,
    String? contentId,
    String? contentName,
  }) async {
    await logEvent(
      eventName: 'Subscribe',
      properties: EventProperties(
        value: value,
        currency: CurrencyCode.fromString(currency.toUpperCase()) ?? CurrencyCode.USD,
        contentId: contentId,
        contentName: contentName,
      ),
    );
  }

  Future<void> logout() async {
    if (!_isInitialized) {
      log.w('TikTok Events SDK not initialized. Skipping logout.');
      return;
    }

    try {
      await TikTokEventsSdk.logout();
      log.i('TikTok user logged out');
    } catch (e, stackTrace) {
      log.e('Failed to logout TikTok user', error: e, stackTrace: stackTrace);
    }
  }
}
