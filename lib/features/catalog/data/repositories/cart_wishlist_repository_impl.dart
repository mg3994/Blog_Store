import 'package:drift/drift.dart';
import '../../domain/entities/cart_wishlist_entities.dart';
import '../../domain/repositories/cart_wishlist_repository.dart';
import '../../../infrastructure/database/drift/app_database.dart' hide CartItem, WishlistItem;

class CartRepositoryImpl implements ICartRepository {
  final AppDatabase db;

  CartRepositoryImpl({required this.db});

  @override
  Future<List<CartItem>> getCartItems() async {
    final rows = await db.select(db.cartItems).get();
    return rows
        .map((r) => CartItem(
              productId: r.productId,
              blogId: r.blogId,
              postId: r.postId,
              title: r.title,
              price: r.price,
              currency: r.currency,
              imageUrl: r.imageUrl,
              quantity: r.quantity,
              isAvailable: r.isAvailable,
            ))
        .toList();
  }

  @override
  Future<void> addToCart(CartItem item) async {
    await db.into(db.cartItems).insertOnConflictUpdate(
          CartItemsCompanion.insert(
            productId: item.productId,
            blogId: item.blogId,
            postId: item.postId,
            title: item.title,
            price: Value(item.price),
            currency: Value(item.currency),
            imageUrl: Value(item.imageUrl),
            quantity: Value(item.quantity),
            isAvailable: Value(item.isAvailable),
          ),
        );
  }

  @override
  Future<void> updateQuantity(String productId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(productId);
      return;
    }
    await (db.update(db.cartItems)..where((tbl) => tbl.productId.equals(productId)))
        .write(CartItemsCompanion(quantity: Value(quantity)));
  }

  @override
  Future<void> removeFromCart(String productId) async {
    await (db.delete(db.cartItems)..where((tbl) => tbl.productId.equals(productId))).go();
  }

  @override
  Future<void> clearCart() async {
    await db.delete(db.cartItems).go();
  }

  @override
  Future<List<CartItem>> verifyAndUpdateAvailability(
    Future<bool> Function(String blogId, String postId) checkAvailability,
  ) async {
    final items = await getCartItems();
    final updatedList = <CartItem>[];

    for (final item in items) {
      final available = await checkAvailability(item.blogId, item.postId);
      final updated = item.copyWith(isAvailable: available);
      updatedList.add(updated);

      await (db.update(db.cartItems)..where((tbl) => tbl.productId.equals(item.productId)))
          .write(CartItemsCompanion(isAvailable: Value(available)));
    }

    return updatedList;
  }
}

class WishlistRepositoryImpl implements IWishlistRepository {
  final AppDatabase db;

  WishlistRepositoryImpl({required this.db});

  @override
  Future<List<WishlistItem>> getWishlistItems() async {
    final rows = await db.select(db.wishlistItems).get();
    return rows
        .map((r) => WishlistItem(
              productId: r.productId,
              blogId: r.blogId,
              postId: r.postId,
              title: r.title,
              price: r.price,
              currency: r.currency,
              imageUrl: r.imageUrl,
            ))
        .toList();
  }

  @override
  Future<void> addToWishlist(WishlistItem item) async {
    await db.into(db.wishlistItems).insertOnConflictUpdate(
          WishlistItemsCompanion.insert(
            productId: item.productId,
            blogId: item.blogId,
            postId: item.postId,
            title: item.title,
            price: Value(item.price),
            currency: Value(item.currency),
            imageUrl: Value(item.imageUrl),
          ),
        );
  }

  @override
  Future<void> removeFromWishlist(String productId) async {
    await (db.delete(db.wishlistItems)..where((tbl) => tbl.productId.equals(productId))).go();
  }

  @override
  Future<bool> isInWishlist(String productId) async {
    final row = await (db.select(db.wishlistItems)..where((tbl) => tbl.productId.equals(productId))).getSingleOrNull();
    return row != null;
  }
}
