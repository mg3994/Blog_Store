import '../../features/catalog/domain/entities/location_model.dart';

class PowerSearchResult {
  final String textQuery;
  final List<String> labels;

  const PowerSearchResult({
    required this.textQuery,
    required this.labels,
  });
}

class PowerSearchParser {
  /// Parses query string containing `label:...` constructs separated by spaces or `|` pipe characters.
  static PowerSearchResult parse(String? rawQuery, {LocationModel? location}) {
    if (rawQuery == null || rawQuery.trim().isEmpty) {
      return const PowerSearchResult(textQuery: '', labels: []);
    }

    final labelRegex = RegExp(r'label:([^\s|]+)', caseSensitive: false);
    final matches = labelRegex.allMatches(rawQuery);
    final labels = <String>[];

    for (final match in matches) {
      final labelVal = match.group(1);
      if (labelVal != null && labelVal.isNotEmpty) {
        labels.add(labelVal);
      }
    }

    // Clean out label:... tags and pipe characters from free text query
    String cleanedText = rawQuery
        .replaceAll(labelRegex, '')
        .replaceAll('|', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    return PowerSearchResult(
      textQuery: cleanedText,
      labels: labels,
    );
  }
}
