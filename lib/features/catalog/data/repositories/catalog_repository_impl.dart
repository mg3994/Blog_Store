import '../../domain/entities/store_product.dart';
import '../../domain/entities/catalog_filter.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../datasources/catalog_cache_data_source.dart';
import '../datasources/catalog_content_data_source.dart';

final class CatalogRepositoryImpl implements CatalogRepository {
  const CatalogRepositoryImpl(this._content, this._cache);

  final CatalogContentDataSource _content;
  final CatalogCacheDataSource _cache;

  @override
  Future<List<StoreProduct>> getProducts({
    CatalogFilter filter = const CatalogFilter(),
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final cached = await _cache.readProducts(filter: filter);
      if (cached.isNotEmpty) {
        return cached
            .map((product) => product.toEntity())
            .toList(growable: false);
      }
    }

    final remote = await _content.loadProducts(filter: filter);
    await _cache.writeProducts(remote);
    return remote.map((product) => product.toEntity()).toList(growable: false);
  }
}
