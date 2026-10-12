import 'package:jiffy/jiffy.dart';

/// Jiffy uses Norwegian Bokmål (`nb`) and has no `no` locale. Its `zh` is
/// Traditional Chinese ("幾秒前"); the app ships Simplified, which is `zh_cn`.
const _languageAliases = {'no': 'nb', 'zh': 'zh_cn'};

/// A Jiffy locale code for [languageCode], or `en` when Jiffy has no match.
///
/// The app ships translations Jiffy cannot format (`vi`, `da`, `el`, `fi`,
/// `ro`). Passing those straight to [Jiffy.setLocale] throws.
String jiffyLocaleFor(String languageCode) {
  final candidate = (_languageAliases[languageCode] ?? languageCode).toLowerCase();
  if (Jiffy.getSupportedLocales().contains(candidate)) return candidate;
  return 'en';
}
