import 'package:flutter_test/flutter_test.dart';

import 'package:blogstore/shared/i18n/json_ld_localized_value_reader.dart';
import 'package:blogstore/shared/i18n/localized_text.dart';

void main() {
  group('LocalizedText', () {
    test('resolves requested language code', () {
      const text = LocalizedText({
        'en': 'Hello',
        'fr': 'Bonjour',
        'es': 'Hola',
      });

      expect(text.resolve('fr'), 'Bonjour');
      expect(text.resolve('es'), 'Hola');
    });

    test('falls back to default fallback language when requested language is missing', () {
      const text = LocalizedText({
        'en': 'Hello',
        'fr': 'Bonjour',
      });

      expect(text.resolve('de'), 'Hello');
    });

    test('falls back to first available value when fallback language is missing', () {
      const text = LocalizedText({
        'ja': 'Konnichiwa',
      });

      expect(text.resolve('de'), 'Konnichiwa');
    });

    test('returns empty string when map is empty', () {
      const text = LocalizedText({});

      expect(text.resolve('en'), '');
    });
  });

  group('JsonLdLocalizedValueReader', () {
    const reader = JsonLdLocalizedValueReader();

    test('reads plain string into undefined language entry', () {
      final result = reader.read('Simple string');
      expect(result.values['und'], 'Simple string');
      expect(result.resolve('en'), 'Simple string');
    });

    test('reads number into string value', () {
      final result = reader.read(42);
      expect(result.values['und'], '42');
    });

    test('reads JSON-LD map with @value and @language', () {
      final result = reader.read({'@value': 'Shirt', '@language': 'en'});
      expect(result.values['en'], 'Shirt');
    });

    test('reads list of JSON-LD localized value maps', () {
      final result = reader.read([
        {'@value': 'Book', '@language': 'en'},
        {'@value': 'Livre', '@language': 'fr'},
      ]);
      expect(result.values['en'], 'Book');
      expect(result.values['fr'], 'Livre');
      expect(result.resolve('fr'), 'Livre');
    });
  });
}
