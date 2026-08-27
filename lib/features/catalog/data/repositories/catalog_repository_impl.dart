import '../../domain/entities/store_product.dart';
import '../../domain/entities/catalog_filter.dart';
import '../../domain/services/catalog_serviceability.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../datasources/catalog_cache_data_source.dart';
import '../datasources/catalog_content_data_source.dart';
import '../models/store_product_model.dart';

final class CatalogRepositoryImpl implements CatalogRepository {
  const CatalogRepositoryImpl(this._content, this._cache, this._serviceability);

  final CatalogContentDataSource _content;
  final CatalogCacheDataSource _cache;
  final CatalogServiceability _serviceability;

  @override
  Future<List<StoreProduct>> getProducts({
    CatalogFilter filter = const CatalogFilter(),
    bool forceRefresh = false,
  }) async {
    List<StoreProductModel> rawProducts = const [];

    if (!forceRefresh) {
      rawProducts = await _cache.readProducts(filter: filter);
    }

    if (rawProducts.isEmpty) {
      rawProducts = await _content.loadProducts(filter: filter);
      await _cache.writeProducts(rawProducts);
    }

    return _processProducts(rawProducts, filter);
  }

  List<StoreProduct> _processProducts(
    List<StoreProductModel> products,
    CatalogFilter filter,
  ) {
    final location = filter.location;
    final filtered = location == null
        ? products
        : products.where(
            (product) => _serviceability.isServiceable(
              areas: product.serviceAreas,
              location: location,
            ),
          );
    return filtered.map((product) => product.toEntity()).toList(growable: false);
  }
}
