import 'package:weeksalive/data/analytics/analytics_events.dart';
import 'package:weeksalive/data/analytics/analytics_repository.dart';
import 'package:weeksalive/data/install/install_repository.dart';

/// Records everything sent to analytics so tests can assert on it.
class FakeAnalyticsRepository implements AnalyticsRepository {
  final List<AnalyticsEvent> captured = [];
  final List<Map<String, Object>> personProperties = [];
  final Map<String, Object> globalProperties = {};
  int resetCount = 0;
  String? identifiedAs;

  List<String> get capturedNames => [for (final event in captured) event.name];

  /// Properties of the first [name] event, or null if it was never captured.
  Map<String, Object>? propertiesOf(String name) {
    for (final event in captured) {
      if (event.name == name) return event.properties;
    }
    return null;
  }

  /// Every person property set so far, later values winning.
  Map<String, Object> get mergedPersonProperties => {
        for (final properties in personProperties) ...properties,
      };

  void clear() {
    captured.clear();
    personProperties.clear();
  }

  @override
  Future<void> capture(AnalyticsEvent event) async => captured.add(event);

  @override
  Future<void> identify({
    required String installId,
    Map<String, Object> properties = const {},
    Map<String, Object> propertiesSetOnce = const {},
  }) async {
    identifiedAs = installId;
    if (properties.isNotEmpty) personProperties.add(properties);
  }

  @override
  Future<void> setPersonProperties(Map<String, Object> properties) async =>
      personProperties.add(properties);

  @override
  Future<void> setGlobalProperty(String key, Object value) async => globalProperties[key] = value;

  @override
  Future<void> reset() async => resetCount++;
}

class FakeInstallRepository implements InstallRepository {
  FakeInstallRepository({this.installId = 'install-id', int onboardingAttempt = 0})
      : _onboardingAttempt = onboardingAttempt;

  final String installId;
  int _onboardingAttempt;

  @override
  bool get isFirstLaunch => false;

  @override
  Future<String> getOrCreateInstallId() async => installId;

  @override
  int get onboardingAttempt => _onboardingAttempt;

  @override
  Future<int> incrementOnboardingAttempt() async => ++_onboardingAttempt;
}
