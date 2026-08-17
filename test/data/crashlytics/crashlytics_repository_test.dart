import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weeksalive/data/crashlytics/crashlytics_repository.dart';

class _MockFirebaseCrashlytics extends Mock implements FirebaseCrashlytics {}

class _FakeCrashlyticsRepository implements CrashlyticsRepository {
  final flutterFatals = <FlutterErrorDetails>[];
  final recorded = <({Object? exception, StackTrace stack, bool fatal})>[];

  @override
  Future<void> recordError(
    dynamic exception,
    StackTrace stack, {
    String? reason,
    Iterable<Object> information = const [],
    bool printDetails = true,
    bool fatal = false,
  }) async {
    recorded.add((exception: exception, stack: stack, fatal: fatal));
  }

  @override
  Future<void> recordFlutterFatalError(FlutterErrorDetails details) async {
    flutterFatals.add(details);
  }

  @override
  Future<void> setCollectionEnabled(bool enabled) async {}

  @override
  Future<void> setCustomKey(String key, String value) async {}

  @override
  Future<void> setUserId(String userId) async {}
}

void main() {
  setUpAll(() {
    registerFallbackValue(StackTrace.empty);
    registerFallbackValue(
      FlutterErrorDetails(exception: Exception('fallback')),
    );
  });

  group('CrashlyticsRepositoryImpl', () {
    late _MockFirebaseCrashlytics firebase;
    late CrashlyticsRepositoryImpl repository;

    setUp(() {
      firebase = _MockFirebaseCrashlytics();
      repository = CrashlyticsRepositoryImpl(firebaseCrashlytics: firebase);
      when(
        () => firebase.recordError(
          any(),
          any(),
          reason: any(named: 'reason'),
          information: any(named: 'information'),
          printDetails: any(named: 'printDetails'),
          fatal: any(named: 'fatal'),
        ),
      ).thenAnswer((_) async {});
      when(
        () => firebase.recordFlutterFatalError(any()),
      ).thenAnswer((_) async {});
      when(() => firebase.setCustomKey(any(), any())).thenAnswer((_) async {});
      when(() => firebase.setUserIdentifier(any())).thenAnswer((_) async {});
      when(
        () => firebase.setCrashlyticsCollectionEnabled(any()),
      ).thenAnswer((_) async {});
    });

    test('recordError forwards a non-fatal by default', () async {
      final stack = StackTrace.current;
      await repository.recordError(StateError('boom'), stack, reason: 'test');

      verify(
        () => firebase.recordError(
          any(that: isA<StateError>()),
          stack,
          reason: 'test',
          information: const [],
          printDetails: true,
          fatal: false,
        ),
      ).called(1);
    });

    test('recordError can mark the event fatal', () async {
      final stack = StackTrace.current;
      await repository.recordError(StateError('boom'), stack, fatal: true);

      verify(
        () => firebase.recordError(
          any(),
          stack,
          reason: null,
          information: const [],
          printDetails: true,
          fatal: true,
        ),
      ).called(1);
    });

    test('setUserId and collection flag reach Crashlytics', () async {
      await repository.setUserId('install-123');
      await repository.setCollectionEnabled(false);
      await repository.setCustomKey('app_environment', 'debug');

      verify(() => firebase.setUserIdentifier('install-123')).called(1);
      verify(() => firebase.setCrashlyticsCollectionEnabled(false)).called(1);
      verify(() => firebase.setCustomKey('app_environment', 'debug')).called(1);
    });
  });

  group('installCrashlyticsErrorHandlers', () {
    late FlutterExceptionHandler? previousFlutterOnError;
    late bool Function(Object error, StackTrace stack)? previousPlatformOnError;
    late _FakeCrashlyticsRepository crashlytics;

    setUp(() {
      previousFlutterOnError = FlutterError.onError;
      previousPlatformOnError = PlatformDispatcher.instance.onError;
      crashlytics = _FakeCrashlyticsRepository();
      installCrashlyticsErrorHandlers(crashlytics);
    });

    tearDown(() {
      FlutterError.onError = previousFlutterOnError;
      PlatformDispatcher.instance.onError = previousPlatformOnError;
    });

    test('forwards Flutter framework errors as fatals', () {
      final details = FlutterErrorDetails(
        exception: StateError('widget boom'),
        stack: StackTrace.current,
      );

      FlutterError.onError!(details);

      expect(crashlytics.flutterFatals, hasLength(1));
      expect(crashlytics.flutterFatals.single.exception, details.exception);
    });

    test('forwards uncaught async errors as fatals', () {
      final error = StateError('async boom');
      final stack = StackTrace.current;

      final handled = PlatformDispatcher.instance.onError!(error, stack);

      expect(handled, isTrue);
      expect(crashlytics.recorded, hasLength(1));
      expect(crashlytics.recorded.single.exception, error);
      expect(crashlytics.recorded.single.stack, stack);
      expect(crashlytics.recorded.single.fatal, isTrue);
    });
  });
}
