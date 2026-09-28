import 'package:jiffy/jiffy.dart';

/// Jiffy uses Norwegian Bokmål (`nb`) and has no `no` locale.
const _languageAliases = {'no': 'nb'};

/// A Jiffy locale code for [languageCode], or `en` when Jiffy has no match.
///
/// The app ships translations Jiffy cannot format (`vi`, `da`, `el`, `fi`,
/// `ro`). Passing those straight to [Jiffy.setLocale] throws.
String jiffyLocaleFor(String languageCode) {
  final candidate = (_languageAliases[languageCode] ?? languageCode).toLowerCase();
  if (Jiffy.getSupportedLocales().contains(candidate)) return candidate;
  return 'en';
}
