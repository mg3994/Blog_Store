import 'cart_wishlist_entities.dart';

abstract class ICartRepository {
  Future<List<CartItem>> getCartItems();
  Future<void> addToCart(CartItem item);
  Future<void> updateQuantity(String productId, int quantity);
  Future<void> removeFromCart(String productId);
  Future<void> clearCart();
  Future<List<CartItem>> verifyAndUpdateAvailability(Future<bool> Function(String blogId, String postId) checkAvailability);
}

abstract class IWishlistRepository {
  Future<List<WishlistItem>> getWishlistItems();
  Future<void> addToWishlist(WishlistItem item);
  Future<void> removeFromWishlist(String productId);
  Future<bool> isInWishlist(String productId);
}
