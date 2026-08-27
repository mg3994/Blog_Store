import 'dart:convert';

import '../../features/catalog/data/models/store_product_model.dart';

final class JsonLdProductParser {
  const JsonLdProductParser();

  List<StoreProductModel> parse(Object? source) {
    final documents = _decodeDocuments(source);
    final products = documents.expand(_findProducts);
    return products
        .map(_toModel)
        .whereType<StoreProductModel>()
        .toList(growable: false);
  }

  Iterable<Map<String, dynamic>> _decodeDocuments(Object? source) {
    if (source is Map<String, dynamic>) {
      return <Map<String, dynamic>>[source];
    }
    if (source is List<dynamic>) {
      return source.whereType<Map<String, dynamic>>();
    }
    if (source is! String) {
      return const <Map<String, dynamic>>[];
    }

    final scripts = RegExp(
      r'''<script[^>]*type=["']application/ld\+json["'][^>]*>(.*?)</script>''',
      caseSensitive: false,
      dotAll: true,
    ).allMatches(source).map((match) => match.group(1));
    final candidates = scripts.isEmpty
        ? <String>[source]
        : scripts.whereType<String>();

    return candidates
        .map((value) {
          try {
            return jsonDecode(value.trim());
          } on FormatException {
            return null;
          }
        })
        .expand((value) => value is List<dynamic> ? value : <Object?>[value])
        .whereType<Map<String, dynamic>>();
  }

  Iterable<Map<String, dynamic>> _findProducts(Map<String, dynamic> document) {
    final graph = document['@graph'];
    final values = graph is List<dynamic>
        ? graph.whereType<Map<String, dynamic>>()
        : <Map<String, dynamic>>[document];
    return values.where(_isProduct);
  }

  bool _isProduct(Map<String, dynamic> value) {
    final type = value['@type'];
    if (type is String) return type.toLowerCase() == 'product';
    if (type is List<dynamic>) {
      return type.any((item) => item.toString().toLowerCase() == 'product');
    }
    return false;
  }

  StoreProductModel? _toModel(Map<String, dynamic> value) {
    final name = value['name'];
    if (name is! String || name.trim().isEmpty) return null;

    final offer = value['offers'];
    final offerMap = offer is Map<String, dynamic>
        ? offer
        : offer is List<dynamic> && offer.firstOrNull is Map<String, dynamic>
        ? offer.first as Map<String, dynamic>
        : const <String, dynamic>{};
    final priceValue = offerMap['price'] ?? value['price'];
    final price = priceValue is num
        ? priceValue.toDouble()
        : double.tryParse('$priceValue');
    final image = value['image'];
    final imageUrl = image is String
        ? image
        : image is List<dynamic> && image.firstOrNull is String
        ? image.first as String
        : null;

    return StoreProductModel(
      id: '${value['sku'] ?? value['productID'] ?? value['url'] ?? name}',
      name: name,
      description: value['description'] as String? ?? '',
      imageUrl: imageUrl,
      price: price,
      currency: offerMap['priceCurrency'] as String?,
      sourceUrl: value['url'] as String? ?? '',
    );
  }
}
