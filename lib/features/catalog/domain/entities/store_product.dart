final class StoreProduct {
  const StoreProduct({
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
}
