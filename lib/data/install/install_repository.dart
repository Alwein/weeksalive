import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// Install-scoped identity, created on the very first launch.
///
/// The app has no accounts and only persists a [User] once onboarding is over,
/// so this id is what ties pre-onboarding behaviour, the paywall and
/// RevenueCat's server-side revenue events to a single PostHog person. It is
/// used as both the PostHog distinct id and the RevenueCat app user id.
class InstallRepository {
  InstallRepository({required SharedPreferences preferences}) : _preferences = preferences;

  final SharedPreferences _preferences;

  static const String _installIdKey = 'install_id';
  static const String _onboardingAttemptKey = 'onboarding_attempt';

  bool get isFirstLaunch => _preferences.getString(_installIdKey) == null;

  Future<String> getOrCreateInstallId() async {
    final existing = _preferences.getString(_installIdKey);
    if (existing != null && existing.isNotEmpty) return existing;

    final installId = const Uuid().v4();
    await _preferences.setString(_installIdKey, installId);
    return installId;
  }

  /// Number of times onboarding has been started on this install.
  ///
  /// A user who does not subscribe cannot get past the paywall, and relaunching
  /// restarts onboarding from step one. Without this counter those retries look
  /// like new onboardings in the funnel.
  int get onboardingAttempt => _preferences.getInt(_onboardingAttemptKey) ?? 0;

  Future<int> incrementOnboardingAttempt() async {
    final next = onboardingAttempt + 1;
    await _preferences.setInt(_onboardingAttemptKey, next);
    return next;
  }
}
