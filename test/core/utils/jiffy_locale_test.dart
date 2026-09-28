import 'package:flutter_test/flutter_test.dart';
import 'package:jiffy/jiffy.dart';
import 'package:weeksalive/core/utils/jiffy_locale.dart';

void main() {
  group('jiffyLocaleFor', () {
    test('keeps locales Jiffy supports', () {
      expect(jiffyLocaleFor('fr'), 'fr');
      expect(jiffyLocaleFor('en'), 'en');
    });

    test('maps Norwegian to Bokmål', () {
      expect(jiffyLocaleFor('no'), 'nb');
    });

    test('falls back to English for locales Jiffy does not ship', () {
      expect(jiffyLocaleFor('vi'), 'en');
      expect(jiffyLocaleFor('da'), 'en');
      expect(jiffyLocaleFor('el'), 'en');
      expect(jiffyLocaleFor('fi'), 'en');
      expect(jiffyLocaleFor('ro'), 'en');
    });

    test('the fallback can be applied without throwing', () async {
      await Jiffy.setLocale(jiffyLocaleFor('vi'));
    });
  });
}
