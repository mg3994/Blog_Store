import '../models/store_product_model.dart';

abstract interface class CatalogContentDataSource {
  Future<List<StoreProductModel>> loadProducts();
}
