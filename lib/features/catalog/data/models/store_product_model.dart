import '../../domain/entities/store_product.dart';

final class StoreProductModel {
  const StoreProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.currency,
    required this.sourceUrl,
  });

  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final double? price;
  final String? currency;
  final String sourceUrl;

  StoreProduct toEntity() => StoreProduct(
    id: id,
    name: name,
    description: description,
    imageUrl: imageUrl,
    price: price,
    currency: currency,
    sourceUrl: sourceUrl,
  );
}
