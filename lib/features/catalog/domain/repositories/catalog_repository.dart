import '../entities/store_product.dart';

abstract interface class CatalogRepository {
  Future<List<StoreProduct>> getProducts({bool forceRefresh = false});
}
