import 'wishlist_item.dart';

abstract interface class WishlistRepository {
  Future<List<WishlistItem>> getWishlistItems();
  Future<void> addToWishlist(WishlistItem item);
  Future<void> removeFromWishlist(String productId);
  Future<bool> isInWishlist(String productId);
}
