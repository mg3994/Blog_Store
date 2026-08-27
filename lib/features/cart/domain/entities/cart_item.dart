final class CartItem {
  const CartItem({
    required this.id,
    required this.productId,
    required this.title,
    required this.price,
    required this.currency,
    this.imageUrl,
    this.quantity = 1,
    this.isAvailable = true,
  });

  final String id;
  final String productId;
  final String title;
  final double price;
  final String currency;
  final String? imageUrl;
  final int quantity;
  final bool isAvailable;

  CartItem copyWith({
    String? id,
    String? productId,
    String? title,
    double? price,
    String? currency,
    String? imageUrl,
    int? quantity,
    bool? isAvailable,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      title: title ?? this.title,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
