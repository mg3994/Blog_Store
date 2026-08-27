import 'package:drift/drift.dart';

import '../../../features/catalog/data/datasources/catalog_cache_data_source.dart';
import '../../../features/catalog/data/models/store_product_model.dart';
import 'app_database.dart';

final class DriftCatalogCache implements CatalogCacheDataSource {
  const DriftCatalogCache(this._database);

  final AppDatabase _database;

  @override
  Future<List<StoreProductModel>> readProducts() async {
    final rows = await _database.select(_database.cachedCatalogProducts).get();
    return rows
        .map(
          (row) => StoreProductModel(
            id: row.id,
            name: row.name,
            description: row.description,
            imageUrl: row.imageUrl,
            price: row.price,
            currency: row.currency,
            sourceUrl: row.sourceUrl,
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<void> writeProducts(List<StoreProductModel> products) async {
    await _database.batch((batch) {
      batch.deleteAll(_database.cachedCatalogProducts);
      batch.insertAll(
        _database.cachedCatalogProducts,
        products
            .map(
              (product) => CachedCatalogProductsCompanion.insert(
                id: product.id,
                name: product.name,
                description: product.description,
                imageUrl: Value(product.imageUrl),
                price: Value(product.price),
                currency: Value(product.currency),
                sourceUrl: product.sourceUrl,
              ),
            )
            .toList(growable: false),
      );
    });
  }
}
