import '../models/store_product_model.dart';

abstract interface class CatalogCacheDataSource {
  Future<List<StoreProductModel>> readProducts();

  Future<void> writeProducts(List<StoreProductModel> products);
}
