import 'package:shared_preferences/shared_preferences.dart';

/// İlk açılış onboarding kararını cihazda saklar.
class OnboardingPreferences {
  OnboardingPreferences._();

  static const String _hasSeenOnboardingKey = 'has_seen_onboarding';

  static Future<bool> hasSeenOnboarding() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_hasSeenOnboardingKey) ?? false;
  }

  static Future<void> markAsSeen() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_hasSeenOnboardingKey, true);
  }
}
