import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/data/tiktok_events/tiktok_events_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('iOS init options', () {
    Map<String, dynamic> optionsAt(DateTime consentedAt) {
      return TikTokEventsRepository.iosOptionsFor(
        attConsentStatus: 'denied',
        consentedAt: consentedAt,
      ).toMap();
    }

    test('formats the consent timestamp the way the plugin validates it', () {
      // The plugin rejects the whole SDK initialization on any other shape, and
      // `toIso8601String` alone emits fractional seconds it refuses.
      final timestamp = optionsAt(DateTime.utc(2026, 9, 16, 15, 57, 6, 232, 983))['externalConsentTimestamp'];

      expect(timestamp, '2026-09-16T15:57:06Z');
      expect(timestamp, matches(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(Z|[+-]\d{2}:\d{2})$'));
    });

    test('states the consent timestamp in UTC', () {
      final options = optionsAt(DateTime.utc(2026, 1, 2, 3, 4, 5).toLocal());

      expect(options['externalConsentTimestamp'], '2026-01-02T03:04:05Z');
    });

    test('suppresses the SDK dialog so onboarding keeps the single ATT prompt', () {
      expect(optionsAt(DateTime.utc(2026))['displayAtt'], isFalse);
    });

    test('leaves automatic tracking on, without which installs are unattributed', () {
      final options = optionsAt(DateTime.utc(2026));

      expect(options['disableAutomaticTracking'], isFalse);
      expect(options['disableTracking'], isFalse);
      expect(options['disableSKAdNetworkSupport'], isFalse);
    });
  });

  group('initializeFromEnv', () {
    const channel = MethodChannel('tiktok_events_sdk');
    late List<MethodCall> calls;

    setUp(() {
      calls = [];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
        call,
      ) async {
        calls.add(call);
        if (call.method == 'isAlreadyInitialized') return false;
        return 'ok';
      });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
    });

    test('initializes with the app ids of both platforms', () async {
      final env = DotEnv()
        ..testLoad(
          fileInput: 'TIKTOK_IOS_APP_ID=6766545614\n'
              'TIKTOK_IOS_ID=7686138983100907541\n'
              'TIKTOK_ANDROID_APP_ID=com.weeksalive\n'
              'TIKTOK_ANDROID_ID=7686139200067977237\n',
        );

      final repository = TikTokEventsRepository();
      await repository.initializeFromEnv(env, isDebugMode: true);

      expect(repository.isInitialized, isTrue);
      expect(calls.map((call) => call.method), contains('initialize'));
    });

    test('stays silent rather than throwing when the TikTok app ids are missing', () async {
      final env = DotEnv()..testLoad(fileInput: 'TIKTOK_IOS_APP_ID=6766545614\n');

      final repository = TikTokEventsRepository();
      await repository.initializeFromEnv(env, isDebugMode: true);

      expect(repository.isInitialized, isFalse);
      expect(calls, isEmpty);
    });

    group('on iOS', () {
      setUp(() => debugDefaultTargetPlatformOverride = TargetPlatform.iOS);
      tearDown(() => debugDefaultTargetPlatformOverride = null);

      DotEnv configuredEnv() => DotEnv()
        ..testLoad(
          fileInput: 'TIKTOK_IOS_APP_ID=6766545614\n'
              'TIKTOK_IOS_ID=7686138983100907541\n'
              'TIKTOK_ANDROID_APP_ID=com.weeksalive\n'
              'TIKTOK_ANDROID_ID=7686139200067977237\n',
        );

      TikTokEventsRepository repositoryWithAtt(TrackingStatus status) {
        return TikTokEventsRepository(readAttStatus: () async => status);
      }

      test('holds the SDK back on a first launch until onboarding asks for ATT', () async {
        // Started now, the SDK would send the install before the prompt, with no
        // IDFA to attribute it to the ad that brought the user.
        final repository = repositoryWithAtt(TrackingStatus.notDetermined);
        await repository.initializeFromEnv(configuredEnv(), isDebugMode: true, isFirstLaunch: true);

        expect(repository.isInitialized, isFalse);
        expect(repository.isWaitingForAtt, isTrue);
        expect(calls, isEmpty);
      });

      test('starts and identifies the user once ATT is answered', () async {
        final repository = repositoryWithAtt(TrackingStatus.notDetermined);
        await repository.initializeFromEnv(
          configuredEnv(),
          isDebugMode: true,
          isFirstLaunch: true,
          externalId: 'install-id',
        );

        await repository.onAttResolved();

        expect(repository.isInitialized, isTrue);
        expect(repository.isWaitingForAtt, isFalse);
        expect(calls.map((call) => call.method), containsAllInOrder(['initialize', 'identify']));
        expect(calls.last.arguments['externalId'], 'install-id');
      });

      test('starts at launch when ATT was already answered', () async {
        final repository = repositoryWithAtt(TrackingStatus.authorized);
        await repository.initializeFromEnv(configuredEnv(), isDebugMode: true, isFirstLaunch: true);

        expect(repository.isInitialized, isTrue);
      });

      test('starts at launch after the first one, even without an ATT answer', () async {
        // Later launches no longer carry an install to lose, while holding the SDK
        // back would leave an onboarding that never reaches the prompt untracked.
        final repository = repositoryWithAtt(TrackingStatus.notDetermined);
        await repository.initializeFromEnv(configuredEnv(), isDebugMode: true);

        expect(repository.isInitialized, isTrue);
      });

      test('ignores an ATT answer when nothing was held back', () async {
        final repository = repositoryWithAtt(TrackingStatus.authorized);
        await repository.initializeFromEnv(configuredEnv(), isDebugMode: true);
        calls.clear();

        await repository.onAttResolved();

        expect(calls, isEmpty);
      });
    });
  });
}
