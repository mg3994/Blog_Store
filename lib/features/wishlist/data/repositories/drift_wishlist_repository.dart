import 'package:drift/drift.dart';
import '../../../../infrastructure/database/drift/app_database.dart';
import '../../domain/entities/wishlist_item.dart';
import '../../domain/repositories/wishlist_repository.dart';

final class DriftWishlistRepository implements WishlistRepository {
  const DriftWishlistRepository(this.db);

  final AppDatabase db;

  @override
  Future<List<WishlistItem>> getWishlistItems() async {
    final rows = await db.select(db.wishlistItems).get();
    return rows
        .map(
          (r) => WishlistItem(
            productId: r.productId,
            title: r.title,
            price: r.price,
            imageUrl: r.imageUrl,
          ),
        )
        .toList();
  }

  @override
  Future<void> addToWishlist(WishlistItem item) async {
    await db.into(db.wishlistItems).insertOnConflictUpdate(
          WishlistItemsCompanion(
            productId: Value(item.productId),
            title: Value(item.title),
            price: Value(item.price),
            imageUrl: Value(item.imageUrl),
          ),
        );
  }

  @override
  Future<void> removeFromWishlist(String productId) async {
    await (db.delete(db.wishlistItems)
          ..where((tbl) => tbl.productId.equals(productId)))
        .go();
  }

  @override
  Future<bool> isInWishlist(String productId) async {
    final query = db.select(db.wishlistItems)
      ..where((tbl) => tbl.productId.equals(productId));
    final item = await query.getSingleOrNull();
    return item != null;
  }
}
