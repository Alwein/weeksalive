// import 'package:logger/logger.dart';
// import 'package:tiktok_events_sdk/tiktok_events_sdk.dart';

// class TikTokEventsRepository {
//   TikTokEventsRepository({
//     required Logger logger,
//   }) : _logger = logger;

//   final Logger _logger;
//   bool _isInitialized = false;

//   Future<void> initialize({
//     required String androidAppId,
//     required String tikTokAndroidId,
//     required String iosAppId,
//     required String tiktokIosId,
//     bool isDebugMode = false,
//   }) async {
//     try {
//       _logger.i('Initializing TikTok Events SDK...');

//       const iosOptions = TikTokIosOptions(
//         disableTracking: false,
//         disableAutomaticTracking: true,
//         disableSKAdNetworkSupport: false,
//       );

//       const androidOptions = TikTokAndroidOptions(
//         disableAutoStart: false,
//         enableAutoIapTrack: true, // Enable automatic IAP tracking
//         disableAdvertiserIDCollection: false,
//       );

//       await TikTokEventsSdk.initSdk(
//         androidAppId: androidAppId,
//         tikTokAndroidId: tikTokAndroidId,
//         iosAppId: iosAppId,
//         tiktokIosId: tiktokIosId,
//         isDebugMode: isDebugMode,
//         logLevel: isDebugMode ? TikTokLogLevel.debug : TikTokLogLevel.info,
//         androidOptions: androidOptions,
//         iosOptions: iosOptions,
//       );

//       _isInitialized = true;
//       _logger.i('TikTok Events SDK initialized successfully');
//     } catch (e, stackTrace) {
//       _logger.e(
//         'Failed to initialize TikTok Events SDK',
//         error: e,
//         stackTrace: stackTrace,
//       );
//       rethrow;
//     }
//   }

//   /// Identify a user with their details
//   ///
//   /// Call this after user login/signup to associate events with the user
//   Future<void> identifyUser({
//     String? externalId,
//     String? externalUserName,
//     String? phoneNumber,
//     String? email,
//   }) async {
//     if (!_isInitialized) {
//       _logger.w('TikTok Events SDK not initialized. Skipping user identification.');
//       return;
//     }

//     try {
//       await TikTokEventsSdk.identify(
//         identifier: TikTokIdentifier(
//           externalId: externalId ?? '',
//           externalUserName: externalUserName ?? '',
//           phoneNumber: phoneNumber ?? '',
//           email: email ?? '',
//         ),
//       );
//       _logger.i('TikTok user identified: $externalId');
//     } catch (e, stackTrace) {
//       _logger.e(
//         'Failed to identify TikTok user',
//         error: e,
//         stackTrace: stackTrace,
//       );
//     }
//   }

//   /// Log a custom event
//   Future<void> logEvent({
//     required String eventName,
//     String? eventId,
//     EventProperties? properties,
//   }) async {
//     if (!_isInitialized) {
//       _logger.w('TikTok Events SDK not initialized. Skipping event: $eventName');
//       return;
//     }

//     try {
//       await TikTokEventsSdk.logEvent(
//         event: TikTokEvent(
//           eventName: eventName,
//           eventId: eventId,
//           properties: properties,
//         ),
//       );
//       _logger.d('TikTok event logged: $eventName');
//     } catch (e, stackTrace) {
//       _logger.e(
//         'Failed to log TikTok event: $eventName',
//         error: e,
//         stackTrace: stackTrace,
//       );
//     }
//   }

//   /// Log when user completes registration
//   Future<void> logCompleteRegistration({
//     String? userId,
//     String? registrationMethod,
//   }) async {
//     await logEvent(
//       eventName: 'CompleteRegistration',
//       properties: EventProperties(
//         customProperties: {
//           if (userId != null) 'user_id': userId,
//           if (registrationMethod != null) 'method': registrationMethod,
//         },
//       ),
//     );
//   }

//   /// Log when user completes a purchase
//   Future<void> logPurchase({
//     required double value,
//     required String currency,
//     String? contentId,
//     String? contentName,
//     int? quantity,
//   }) async {
//     await logEvent(
//       eventName: 'Purchase',
//       properties: EventProperties(
//         value: value,
//         currency: CurrencyCode.values.firstWhere(
//           (c) => c.name.toUpperCase() == currency.toUpperCase(),
//           orElse: () => CurrencyCode.USD,
//         ),
//         contentId: contentId,
//         contentName: contentName,
//         quantity: quantity,
//       ),
//     );
//   }

//   /// Logout current user
//   Future<void> logout() async {
//     if (!_isInitialized) {
//       _logger.w('TikTok Events SDK not initialized. Skipping logout.');
//       return;
//     }

//     try {
//       await TikTokEventsSdk.logout();
//       _logger.i('TikTok user logged out');
//     } catch (e, stackTrace) {
//       _logger.e(
//         'Failed to logout TikTok user',
//         error: e,
//         stackTrace: stackTrace,
//       );
//     }
//   }
// }
