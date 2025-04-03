import 'package:shared_preferences/shared_preferences.dart';

class OnboardingRepository {
  final SharedPreferences _preferences;

  OnboardingRepository({required SharedPreferences preferences}) : _preferences = preferences;

  static const String _onboardingKey = 'onboarding_key';

  Future<bool> shouldShowOnboarding() async {
    return _preferences.getBool(_onboardingKey) ?? true;
  }

  Future<void> setOnboardingDone() async {
    await _preferences.setBool(_onboardingKey, false);
  }
}
