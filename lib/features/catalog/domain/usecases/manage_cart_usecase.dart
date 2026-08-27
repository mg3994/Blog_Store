import '../entities/cart_wishlist_entities.dart';
import '../repositories/cart_wishlist_repository.dart';

class ManageCartUseCase {
  final ICartRepository cartRepository;

  ManageCartUseCase({required this.cartRepository});

  Future<List<CartItem>> getCart() => cartRepository.getCartItems();

  Future<void> addItem(CartItem item) => cartRepository.addToCart(item);

  Future<void> updateQuantity(String productId, int quantity) => cartRepository.updateQuantity(productId, quantity);

  Future<void> removeItem(String productId) => cartRepository.removeFromCart(productId);

  Future<void> clearCart() => cartRepository.clearCart();

  Future<List<CartItem>> verifyCartAvailability(Future<bool> Function(String blogId, String postId) checkAvailability) {
    return cartRepository.verifyAndUpdateAvailability(checkAvailability);
  }
}
