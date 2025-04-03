import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsRepository {
  AnalyticsRepository({FirebaseAnalytics? firebaseAnalytics})
      : _firebaseAnalytics = firebaseAnalytics ?? FirebaseAnalytics.instance;
  final FirebaseAnalytics _firebaseAnalytics;

  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    await _firebaseAnalytics.setUserProperty(name: name, value: value);
  }
}
