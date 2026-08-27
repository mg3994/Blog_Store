final class WishlistItem {
  const WishlistItem({
    required this.productId,
    required this.title,
    this.price,
    this.imageUrl,
  });

  final String productId;
  final String title;
  final double? price;
  final String? imageUrl;
}
