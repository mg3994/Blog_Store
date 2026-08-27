import 'package:flutter_test/flutter_test.dart';

import 'package:blogstore/features/catalog/data/datasources/catalog_cache_data_source.dart';
import 'package:blogstore/features/catalog/data/datasources/catalog_content_data_source.dart';
import 'package:blogstore/features/catalog/data/models/store_product_model.dart';
import 'package:blogstore/features/catalog/data/repositories/catalog_repository_impl.dart';
import 'package:blogstore/features/catalog/domain/entities/catalog_filter.dart';
import 'package:blogstore/features/catalog/domain/entities/service_area.dart';
import 'package:blogstore/features/catalog/domain/entities/user_location.dart';
import 'package:blogstore/features/catalog/domain/services/catalog_serviceability.dart';

void main() {
  group('CatalogRepositoryImpl', () {
    late FakeCatalogContentDataSource contentSource;
    late FakeCatalogCacheDataSource cacheSource;
    late CatalogServiceability serviceability;
    late CatalogRepositoryImpl repository;

    const testProduct = StoreProductModel(
      id: 'prod_1',
      name: 'Test Product',
      description: 'Test Description',
      imageUrl: 'https://example.com/img.png',
      price: 100.0,
      currency: 'USD',
      sourceUrl: 'https://example.com/prod/1',
      serviceAreas: [ServiceArea(type: 'Country', name: 'India')],
    );

    setUp(() {
      contentSource = FakeCatalogContentDataSource();
      cacheSource = FakeCatalogCacheDataSource();
      serviceability = const CatalogServiceability();
      repository = CatalogRepositoryImpl(contentSource, cacheSource, serviceability);
    });

    test('returns cached products when cache is non-empty and forceRefresh is false', () async {
      cacheSource.products = [testProduct];
      contentSource.products = [];

      final products = await repository.getProducts();

      expect(products, hasLength(1));
      expect(products.first.id, 'prod_1');
      expect(contentSource.loadCalledCount, 0);
    });

    test('fetches remote products and writes to cache when cache is empty', () async {
      cacheSource.products = [];
      contentSource.products = [testProduct];

      final products = await repository.getProducts();

      expect(products, hasLength(1));
      expect(products.first.id, 'prod_1');
      expect(contentSource.loadCalledCount, 1);
      expect(cacheSource.products, hasLength(1));
    });

    test('bypasses cache when forceRefresh is true', () async {
      cacheSource.products = [testProduct];
      contentSource.products = [testProduct];

      final products = await repository.getProducts(forceRefresh: true);

      expect(products, hasLength(1));
      expect(contentSource.loadCalledCount, 1);
    });

    test('filters products by user location serviceability', () async {
      cacheSource.products = [testProduct];

      const filterMatching = CatalogFilter(
        location: UserLocation(country: 'India'),
      );
      final productsMatching = await repository.getProducts(filter: filterMatching);
      expect(productsMatching, hasLength(1));

      const filterNonMatching = CatalogFilter(
        location: UserLocation(country: 'USA'),
      );
      final productsNonMatching = await repository.getProducts(filter: filterNonMatching);
      expect(productsNonMatching, isEmpty);
    });
  });
}

class FakeCatalogContentDataSource implements CatalogContentDataSource {
  List<StoreProductModel> products = [];
  int loadCalledCount = 0;

  @override
  Future<List<StoreProductModel>> loadProducts({required CatalogFilter filter}) async {
    loadCalledCount++;
    return products;
  }
}

class FakeCatalogCacheDataSource implements CatalogCacheDataSource {
  List<StoreProductModel> products = [];

  @override
  Future<List<StoreProductModel>> readProducts({required CatalogFilter filter}) async {
    return products;
  }

  @override
  Future<void> writeProducts(List<StoreProductModel> newProducts) async {
    products = List.from(newProducts);
  }
}
