import 'package:flutter_test/flutter_test.dart';

import 'package:blogstore/features/catalog/domain/entities/catalog_filter.dart';
import 'package:blogstore/features/catalog/domain/entities/store_product.dart';
import 'package:blogstore/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:blogstore/features/catalog/domain/usecases/get_catalog_products.dart';
import 'package:blogstore/features/catalog/presentation/cubit/catalog_cubit.dart';

void main() {
  group('CatalogCubit', () {
    late FakeCatalogRepository repository;
    late GetCatalogProducts getProducts;
    late CatalogCubit cubit;

    const testProduct = StoreProduct(
      id: 'p1',
      name: 'Product 1',
      description: 'Desc 1',
      imageUrl: null,
      price: 10.0,
      currency: 'USD',
      sourceUrl: 'https://example.com/p1',
      serviceAreas: [],
    );

    setUp(() {
      repository = FakeCatalogRepository();
      getProducts = GetCatalogProducts(repository);
      cubit = CatalogCubit(getProducts);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is CatalogInitial', () {
      expect(cubit.stateValue, isA<CatalogInitial>());
    });

    test('emits CatalogLoaded state when products are fetched successfully', () async {
      repository.productsToReturn = [testProduct];

      await cubit.loadProducts();

      final state = cubit.stateValue;
      expect(state, isA<CatalogLoaded>());
      if (state is CatalogLoaded) {
        expect(state.products, hasLength(1));
        expect(state.products.first.id, 'p1');
      }
    });

    test('emits CatalogError state when loading throws an exception', () async {
      repository.shouldThrow = true;

      await cubit.loadProducts();

      final state = cubit.stateValue;
      expect(state, isA<CatalogError>());
      if (state is CatalogError) {
        expect(state.message, contains('Failed to fetch catalog'));
      }
    });
  });
}

class FakeCatalogRepository implements CatalogRepository {
  List<StoreProduct> productsToReturn = [];
  bool shouldThrow = false;

  @override
  Future<List<StoreProduct>> getProducts({
    CatalogFilter filter = const CatalogFilter(),
    bool forceRefresh = false,
  }) async {
    if (shouldThrow) {
      throw Exception('Failed to fetch catalog');
    }
    return productsToReturn;
  }
}
