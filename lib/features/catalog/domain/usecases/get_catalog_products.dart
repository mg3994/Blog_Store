import '../entities/store_product.dart';
import '../repositories/catalog_repository.dart';

final class GetCatalogProducts {
  const GetCatalogProducts(this._repository);

  final CatalogRepository _repository;

  Future<List<StoreProduct>> call({bool forceRefresh = false}) {
    return _repository.getProducts(forceRefresh: forceRefresh);
  }
}
