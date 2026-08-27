import 'dart:ui';
import 'package:intl/intl.dart';

class SchemaI18nResolver {
  /// Extracts string value from standard string or localized `@value`/`@language` list based on app locale.
  static String? extractLocalizedString(dynamic field, {Locale locale = const Locale('en')}) {
    if (field == null) return null;
    if (field is String) return field;

    if (field is List) {
      String? fallbackValue;
      String? englishValue;
      final targetLang = locale.languageCode.toLowerCase();

      for (final item in field) {
        if (item is Map<String, dynamic>) {
          final val = item['@value']?.toString();
          final lang = item['@language']?.toString().toLowerCase();

          if (val != null) {
            fallbackValue ??= val;
            if (lang == targetLang) {
              return val;
            }
            if (lang == 'en') {
              englishValue = val;
            }
          }
        }
      }
      return englishValue ?? fallbackValue;
    }

    if (field is Map<String, dynamic>) {
      return field['@value']?.toString() ?? field['name']?.toString();
    }

    return field.toString();
  }

  /// Parses date-time string in any timezone and formats it in the user's local timezone.
  static String? formatToUserLocalTime(String? dateTimeStr, {String format = 'yyyy-MM-dd HH:mm'}) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return null;
    try {
      final parsedDate = DateTime.parse(dateTimeStr).toLocal();
      return DateFormat(format).format(parsedDate);
    } catch (_) {
      return dateTimeStr;
    }
  }
}
