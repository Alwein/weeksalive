import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:weeksalive/core/utils/logger.dart';
import 'package:weeksalive/data/analytics/analytics_repository.dart';

/// Boots PostHog and binds the current person to [installId].
///
/// Debug builds report to `POSTHOG_API_KEY_DEV` when it points at a separate
/// project, and to the production project otherwise. Either way they carry
/// `app_environment: debug`, which is what production metrics filter on.
/// Returns a no-op sink when no usable key is configured, so the app runs
/// identically without analytics.
Future<AnalyticsRepository> initializeAnalytics({
  required DotEnv dotenv,
  required String installId,
  required bool isFirstLaunch,
  required bool isDebugMode,
}) async {
  final productionKey = dotenv.env['POSTHOG_API_KEY']?.trim() ?? '';
  final debugKey = dotenv.env['POSTHOG_API_KEY_DEV']?.trim() ?? '';
  final host = dotenv.env['POSTHOG_HOST']?.trim() ?? '';

  final usesDebugProject = isDebugMode && debugKey.isNotEmpty;
  final projectToken = usesDebugProject ? debugKey : productionKey;
  if (projectToken.isEmpty) {
    log.w('Analytics: no PostHog key configured, analytics disabled');
    return const NoopAnalyticsRepository();
  }

  final config = PostHogConfig(projectToken)
    ..host = host.isEmpty ? _euHost : host
    ..debug = isDebugMode
    ..captureApplicationLifecycleEvents = true
    ..personProfiles = PostHogPersonProfiles.identifiedOnly
    ..sessionReplay = true
    // Nothing in this app is meant to be read by us: reflections, photos and
    // the profile are all masked, leaving layout and interactions visible.
    ..sessionReplayConfig.maskAllTexts = true
    ..sessionReplayConfig.maskAllImages = true
    ..sessionReplayConfig.maskAllPlatformViews = true
    // Not used yet; both would add a request to every cold start.
    ..preloadFeatureFlags = false
    ..surveys = false;

  try {
    await Posthog().setup(config);
  } catch (e, st) {
    // Booting analytics happens on the critical path of app startup, so a
    // failure here has to cost analytics and nothing else.
    log.e('Analytics: PostHog setup failed, analytics disabled', error: e, stackTrace: st);
    return const NoopAnalyticsRepository();
  }

  final analytics = PostHogAnalyticsRepository();
  // Registered before anything is captured, so no event escapes without saying
  // which environment it came from.
  await analytics.setGlobalProperty('app_environment', isDebugMode ? 'debug' : 'production');
  await analytics.identify(
    installId: installId,
    propertiesSetOnce: {
      'install_id': installId,
      if (isFirstLaunch) 'first_seen_at': DateTime.now().toUtc().toIso8601String(),
    },
  );

  return analytics;
}

const String _euHost = 'https://eu.i.posthog.com';
