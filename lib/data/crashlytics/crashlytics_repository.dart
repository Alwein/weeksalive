import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:weeksalive/core/utils/logger.dart';

abstract class CrashlyticsRepository {
  Future<void> recordError(
    dynamic exception,
    StackTrace stack, {
    String? reason,
    Iterable<Object> information,
    bool printDetails,
  });

  Future<void> setCustomKey(String key, String value);

  Future<void> setUserId(String userId);
}

class CrashlyticsRepositoryImpl implements CrashlyticsRepository {
  CrashlyticsRepositoryImpl({FirebaseCrashlytics? firebaseCrashlytics})
      : _firebaseCrashlytics = firebaseCrashlytics ?? FirebaseCrashlytics.instance;
  final FirebaseCrashlytics _firebaseCrashlytics;

  @override
  Future<void> recordError(
    dynamic exception,
    StackTrace stack, {
    String? reason,
    Iterable<Object> information = const [],
    bool printDetails = true,
  }) async {
    log.e("🔴 $exception");
    await _firebaseCrashlytics.recordError(exception, stack,
        reason: reason, information: information, printDetails: printDetails);
  }

  @override
  Future<void> setCustomKey(String key, String value) async {
    await _firebaseCrashlytics.setCustomKey(key, value);
  }

  @override
  Future<void> setUserId(String userId) async {
    await _firebaseCrashlytics.setUserIdentifier(userId);
  }
}
