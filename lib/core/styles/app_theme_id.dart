enum AppThemeId {
  system,
  dark,
  light,
  petale,
  pivoine,
  cafe,
  matcha,
  lavande,
  terracotta,
  ardoise;

  static const all = [system, dark, light, petale, cafe, lavande, matcha, pivoine, terracotta, ardoise];

  static const alwaysUnlocked = [system, dark, light, petale, cafe, lavande];

  bool get isAlwaysUnlocked => alwaysUnlocked.contains(this);

  String get storageKey => name;
}
