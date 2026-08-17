import 'dart:async';
import 'dart:isolate';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:weeksalive/core/utils/logger.dart';

abstract class CrashlyticsRepository {
  Future<void> recordError(
    dynamic exception,
    StackTrace stack, {
    String? reason,
    Iterable<Object> information,
    bool printDetails,
    bool fatal,
  });

  Future<void> recordFlutterFatalError(FlutterErrorDetails details);

  Future<void> setCustomKey(String key, String value);

  Future<void> setUserId(String userId);

  Future<void> setCollectionEnabled(bool enabled);
}

class CrashlyticsRepositoryImpl implements CrashlyticsRepository {
  CrashlyticsRepositoryImpl({FirebaseCrashlytics? firebaseCrashlytics})
    : _firebaseCrashlytics =
          firebaseCrashlytics ?? FirebaseCrashlytics.instance;
  final FirebaseCrashlytics _firebaseCrashlytics;

  @override
  Future<void> recordError(
    dynamic exception,
    StackTrace stack, {
    String? reason,
    Iterable<Object> information = const [],
    bool printDetails = true,
    bool fatal = false,
  }) async {
    log.e("🔴 $exception");
    await _firebaseCrashlytics.recordError(
      exception,
      stack,
      reason: reason,
      information: information,
      printDetails: printDetails,
      fatal: fatal,
    );
  }

  @override
  Future<void> recordFlutterFatalError(FlutterErrorDetails details) {
    return _firebaseCrashlytics.recordFlutterFatalError(details);
  }

  @override
  Future<void> setCustomKey(String key, String value) async {
    await _firebaseCrashlytics.setCustomKey(key, value);
  }

  @override
  Future<void> setUserId(String userId) async {
    await _firebaseCrashlytics.setUserIdentifier(userId);
  }

  @override
  Future<void> setCollectionEnabled(bool enabled) {
    return _firebaseCrashlytics.setCrashlyticsCollectionEnabled(enabled);
  }
}

/// Forwards Flutter framework errors, uncaught async errors, and isolate errors
/// to [crashlytics]. Call once after Firebase is initialized and before [runApp].
void installCrashlyticsErrorHandlers(CrashlyticsRepository crashlytics) {
  FlutterError.onError = (details) {
    crashlytics.recordFlutterFatalError(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    crashlytics.recordError(error, stack, fatal: true);
    return true;
  };

  if (_isolateErrorListenerInstalled) return;
  _isolateErrorListenerInstalled = true;
  Isolate.current.addErrorListener(
    RawReceivePort((pair) {
      final List<dynamic> errorAndStack = pair as List<dynamic>;
      final stack = errorAndStack.last;
      unawaited(
        crashlytics.recordError(
          errorAndStack.first,
          stack is StackTrace ? stack : StackTrace.empty,
          fatal: true,
        ),
      );
    }).sendPort,
  );
}

bool _isolateErrorListenerInstalled = false;
