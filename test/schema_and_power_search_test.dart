import 'package:flutter_test/flutter_test.dart';
import 'package:blogstore/infrastructure/blogger/schema_override.dart';
import 'package:blogstore/features/catalog/domain/entities/resolved_id.dart';
import 'package:blogstore/infrastructure/blogger/power_search_parser.dart';
import 'package:blogstore/infrastructure/blogger/area_served_matcher.dart';
import 'package:blogstore/features/catalog/domain/entities/location_model.dart';
import 'package:blogstore/infrastructure/blogger/schema_i18n_resolver.dart';
import 'package:flutter/material.dart';

void main() {
  group('SchemaOverride Unit Tests', () {
    test('resolveId resolves absolute URL', () {
      final res = SchemaOverride.resolveId('123/456', 'https://example.com/schema.json');
      expect(res, equals(const ResolvedId(url: 'https://example.com/schema.json')));
    });

    test('resolveId resolves blogId/postId string', () {
      final res = SchemaOverride.resolveId('123/456', '789/101');
      expect(res, equals(const ResolvedId(blogId: '789', postId: '101')));
    });

    test('resolveId resolves relative postId against base context', () {
      final res = SchemaOverride.resolveId('12345/67890', '99999');
      expect(res, equals(const ResolvedId(blogId: '12345', postId: '99999')));
    });

    test('deepMerge merges properties with source override', () {
      final target = {
        'name': 'Original Product',
        'price': 100,
        'offers': {'availability': 'InStock'}
      };
      final source = {
        'price': 150,
        'offers': {'priceCurrency': 'USD'}
      };

      final merged = SchemaOverride.deepMerge(target, source);
      expect(merged['name'], equals('Original Product'));
      expect(merged['price'], equals(150));
      expect(merged['offers']['availability'], equals('InStock'));
      expect(merged['offers']['priceCurrency'], equals('USD'));
    });
  });

  group('PowerSearchParser Unit Tests', () {
    test('parses label:... syntax separated by space and pipe', () {
      final parsed = PowerSearchParser.parse('label:shoes|label:sports running sneakers');
      expect(parsed.labels, containsAll(['shoes', 'sports']));
      expect(parsed.textQuery, equals('running sneakers'));
    });
  });

  group('AreaServedMatcher Unit Tests', () {
    test('matches city correctly', () {
      final userLoc = const LocationModel(city: 'Gurugram', state: 'Haryana', country: 'India');
      final isMatch = AreaServedMatcher.isServiceable(
        areaServed: {'@type': 'City', 'name': 'Gurugram'},
        userLocation: userLoc,
      );
      expect(isMatch, isTrue);
    });

    test('matches country for nationwide products', () {
      final userLoc = const LocationModel(city: 'Gurugram', country: 'India');
      final isMatch = AreaServedMatcher.isServiceable(
        areaServed: {'@type': 'Country', 'name': 'India'},
        userLocation: userLoc,
      );
      expect(isMatch, isTrue);
    });
  });

  group('SchemaI18nResolver Unit Tests', () {
    test('extracts localized string according to locale', () {
      final field = [
        {'@value': 'The Count of Monte Cristo', '@language': 'en'},
        {'@value': 'Le Comte de Monte-Cristo', '@language': 'fr'}
      ];

      final frVal = SchemaI18nResolver.extractLocalizedString(field, locale: const Locale('fr'));
      expect(frVal, equals('Le Comte de Monte-Cristo'));

      final enVal = SchemaI18nResolver.extractLocalizedString(field, locale: const Locale('en'));
      expect(enVal, equals('The Count of Monte Cristo'));
    });
  });
}
