class CartItem {
  final String productId;
  final String blogId;
  final String postId;
  final String title;
  final double? price;
  final String? currency;
  final String? imageUrl;
  final int quantity;
  final bool isAvailable;

  const CartItem({
    required this.productId,
    required this.blogId,
    required this.postId,
    required this.title,
    this.price,
    this.currency,
    this.imageUrl,
    this.quantity = 1,
    this.isAvailable = true,
  });

  CartItem copyWith({
    String? productId,
    String? blogId,
    String? postId,
    String? title,
    double? price,
    String? currency,
    String? imageUrl,
    int? quantity,
    bool? isAvailable,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      blogId: blogId ?? this.blogId,
      postId: postId ?? this.postId,
      title: title ?? this.title,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}

class WishlistItem {
  final String productId;
  final String blogId;
  final String postId;
  final String title;
  final double? price;
  final String? currency;
  final String? imageUrl;

  const WishlistItem({
    required this.productId,
    required this.blogId,
    required this.postId,
    required this.title,
    this.price,
    this.currency,
    this.imageUrl,
  });
}
