import 'cart_item.dart';

abstract interface class CartRepository {
  Future<List<CartItem>> getCartItems();
  Future<void> addToCart(CartItem item);
  Future<void> removeFromCart(String id);
  Future<void> updateQuantity(String id, int quantity);
  Future<void> clearCart();
}
