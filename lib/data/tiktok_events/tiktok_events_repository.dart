import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tiktok_events_sdk/tiktok_events_sdk.dart';
import 'package:weeksalive/core/utils/logger.dart';

class TikTokEventsRepository {
  TikTokEventsRepository({Future<TrackingStatus> Function()? readAttStatus})
      : _readAttStatus = readAttStatus ?? (() => AppTrackingTransparency.trackingAuthorizationStatus);

  final Future<TrackingStatus> Function() _readAttStatus;

  bool _isInitialized = false;
  ({DotEnv dotenv, bool isDebugMode, String? externalId})? _deferredStart;

  bool get isInitialized => _isInitialized;

  /// Whether the SDK is waiting for the onboarding ATT answer before it starts.
  bool get isWaitingForAtt => _deferredStart != null;

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

  /// On an iOS first launch the SDK is held back until onboarding has asked for
  /// ATT (see [onAttResolved]). The SDK reads the IDFA when it sends its queue,
  /// and it sends the automatic InstallApp within seconds of starting: started
  /// at launch, the install leaves minutes before the ATT prompt, with no IDFA,
  /// and TikTok can attribute the trial that follows but not the install the
  /// campaign optimizes on. SKAdNetwork registration does not wait — the app
  /// delegate registers at launch, so installs that never reach the prompt are
  /// still counted.
  Future<void> initializeFromEnv(
    DotEnv dotenv, {
    required bool isDebugMode,
    bool isFirstLaunch = false,
    String? externalId,
  }) async {
    if (!isConfigured(dotenv)) {
      log.w('TikTok Events SDK not configured. Skipping initialization.');
      return;
    }

    if (isFirstLaunch && await _attIsUndetermined()) {
      log.i('TikTok Events SDK deferred until the onboarding ATT answer.');
      _deferredStart = (dotenv: dotenv, isDebugMode: isDebugMode, externalId: externalId);
      return;
    }

    await _start(dotenv, isDebugMode: isDebugMode, externalId: externalId);
  }

  /// Starts the SDK held back by [initializeFromEnv], now that the IDFA it will
  /// send with the install is whatever the user just chose.
  Future<void> onAttResolved() async {
    final deferred = _deferredStart;
    if (deferred == null || _isInitialized) return;
    _deferredStart = null;
    await _start(deferred.dotenv, isDebugMode: deferred.isDebugMode, externalId: deferred.externalId);
  }

  Future<bool> _attIsUndetermined() async {
    if (defaultTargetPlatform != TargetPlatform.iOS) return false;
    return await _readAttStatus() == TrackingStatus.notDetermined;
  }

  Future<void> _start(DotEnv dotenv, {required bool isDebugMode, String? externalId}) async {
    try {
      log.i('Initializing TikTok Events SDK...');

      final iosOptions = iosOptionsFor(
        attConsentStatus: await _attConsentStatus(),
        consentedAt: DateTime.now(),
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
      return;
    }

    if (externalId != null) await identifyUser(externalId: externalId);
  }

  /// Kept apart from [initializeFromEnv] because the method channel only
  /// forwards these on a real device: a host test would assert on the Android
  /// options instead, and both settings below have already broken once.
  @visibleForTesting
  static TikTokIosOptions iosOptionsFor({
    required String attConsentStatus,
    required DateTime consentedAt,
  }) {
    return TikTokIosOptions(
      disableTracking: false,
      // Automatic tracking is what emits InstallApp and LaunchAPP, the events
      // TikTok attributes an install to. Disabling it leaves a campaign able to
      // count trials but unable to tell which ad produced them.
      disableAutomaticTracking: false,
      disableSKAdNetworkSupport: false,
      // Onboarding asks for ATT itself, at step 29, behind a screen that says
      // why. iOS grants that dialog once and once only, so letting the SDK
      // raise its own at cold start would spend it with no explanation.
      displayAtt: false,
      externalConsentStatus: attConsentStatus,
      externalConsentTimestamp: _iso8601Seconds(consentedAt),
    );
  }

  /// The plugin validates this timestamp against a regex that accepts no
  /// fractional seconds, which `toIso8601String` always emits — and rejects the
  /// whole SDK initialization when it sees them.
  static String _iso8601Seconds(DateTime time) {
    return '${time.toUtc().toIso8601String().split('.').first}Z';
  }

  /// The plugin refuses to suppress its own ATT dialog without an audit trail
  /// of the consent obtained elsewhere. It keeps this locally — nothing is sent
  /// to TikTok — so the honest value is whatever iOS reports right now.
  Future<String> _attConsentStatus() async {
    if (defaultTargetPlatform != TargetPlatform.iOS) return 'denied';
    final status = await _readAttStatus();
    return status == TrackingStatus.authorized ? 'granted' : 'denied';
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

  /// The event TikTok's App Event Optimization bids on when the campaign goal
  /// is trials. [value] is the price the trial converts to, not what is charged
  /// today (nothing is), which is what lets TikTok weigh a trial by the revenue
  /// it can become.
  Future<void> logStartTrial({
    required double value,
    required String currency,
    String? contentId,
    String? contentName,
    int? trialDays,
  }) async {
    await logEvent(
      eventName: 'StartTrial',
      properties: EventProperties(
        value: value,
        currency: CurrencyCode.fromString(currency.toUpperCase()) ?? CurrencyCode.USD,
        contentId: contentId,
        contentName: contentName,
        customProperties: {
          if (trialDays != null) 'trial_days': trialDays,
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
