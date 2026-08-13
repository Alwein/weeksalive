import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:weeksalive/core/utils/logger.dart';
import 'package:weeksalive/data/analytics/analytics_events.dart';

/// Product analytics sink.
///
/// Analytics is never allowed to break the app: implementations swallow their
/// own failures and log them instead of propagating.
abstract interface class AnalyticsRepository {
  Future<void> capture(AnalyticsEvent event);

  /// Binds the current person to [installId], the same id given to RevenueCat
  /// as its app user id so server-side revenue events land on this person.
  Future<void> identify({
    required String installId,
    Map<String, Object> properties = const {},
    Map<String, Object> propertiesSetOnce = const {},
  });

  Future<void> setPersonProperties(Map<String, Object> properties);

  /// Registers a property attached to every subsequent event.
  Future<void> setGlobalProperty(String key, Object value);

  Future<void> reset();
}

class PostHogAnalyticsRepository implements AnalyticsRepository {
  PostHogAnalyticsRepository({Posthog? posthog}) : _posthog = posthog ?? Posthog();

  final Posthog _posthog;

  @override
  Future<void> capture(AnalyticsEvent event) async {
    await _guard(
      'capture ${event.name}',
      () => _posthog.capture(eventName: event.name, properties: event.properties),
    );
  }

  @override
  Future<void> identify({
    required String installId,
    Map<String, Object> properties = const {},
    Map<String, Object> propertiesSetOnce = const {},
  }) async {
    await _guard(
      'identify',
      () => _posthog.identify(
        userId: installId,
        userProperties: properties.isEmpty ? null : properties,
        userPropertiesSetOnce: propertiesSetOnce.isEmpty ? null : propertiesSetOnce,
      ),
    );
  }

  @override
  Future<void> setPersonProperties(Map<String, Object> properties) async {
    if (properties.isEmpty) return;
    await _guard(
      'setPersonProperties',
      () => _posthog.setPersonProperties(userPropertiesToSet: properties),
    );
  }

  @override
  Future<void> setGlobalProperty(String key, Object value) async {
    await _guard('register $key', () => _posthog.register(key, value));
  }

  @override
  Future<void> reset() async {
    await _guard('reset', () => _posthog.reset());
  }

  Future<void> _guard(String description, Future<void> Function() action) async {
    try {
      await action();
    } catch (e, st) {
      log.e('Analytics: $description failed', error: e, stackTrace: st);
    }
  }
}

/// Used when no PostHog key is configured, and as a safe default in tests.
class NoopAnalyticsRepository implements AnalyticsRepository {
  const NoopAnalyticsRepository();

  @override
  Future<void> capture(AnalyticsEvent event) async {}

  @override
  Future<void> identify({
    required String installId,
    Map<String, Object> properties = const {},
    Map<String, Object> propertiesSetOnce = const {},
  }) async {}

  @override
  Future<void> setPersonProperties(Map<String, Object> properties) async {}

  @override
  Future<void> setGlobalProperty(String key, Object value) async {}

  @override
  Future<void> reset() async {}
}
