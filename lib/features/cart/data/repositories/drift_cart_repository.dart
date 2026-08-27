import 'package:drift/drift.dart';
import '../../../../infrastructure/database/drift/app_database.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';

final class DriftCartRepository implements CartRepository {
  const DriftCartRepository(this.db);

  final AppDatabase db;

  @override
  Future<List<CartItem>> getCartItems() async {
    final rows = await db.select(db.cartItems).get();
    return rows
        .map(
          (r) => CartItem(
            id: r.id,
            productId: r.productId,
            title: r.title,
            price: r.price,
            currency: r.currency,
            imageUrl: r.imageUrl,
            quantity: r.quantity,
          ),
        )
        .toList();
  }

  @override
  Future<void> addToCart(CartItem item) async {
    await db.into(db.cartItems).insertOnConflictUpdate(
          CartItemsCompanion(
            id: Value(item.id),
            productId: Value(item.productId),
            title: Value(item.title),
            price: Value(item.price),
            currency: Value(item.currency),
            imageUrl: Value(item.imageUrl),
            quantity: Value(item.quantity),
          ),
        );
  }

  @override
  Future<void> removeFromCart(String id) async {
    await (db.delete(db.cartItems)..where((tbl) => tbl.id.equals(id))).go();
  }

  @override
  Future<void> updateQuantity(String id, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(id);
      return;
    }
    await (db.update(db.cartItems)..where((tbl) => tbl.id.equals(id))).write(
      CartItemsCompanion(quantity: Value(quantity)),
    );
  }

  @override
  Future<void> clearCart() async {
    await db.delete(db.cartItems).go();
  }
}
