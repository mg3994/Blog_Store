import 'package:flutter_test/flutter_test.dart';

import 'package:blogstore/core/network/api_client.dart';
import 'package:blogstore/core/network/api_scope.dart';
import 'package:blogstore/features/catalog/data/datasources/blogger_catalog_data_source.dart';
import 'package:blogstore/features/catalog/domain/entities/catalog_filter.dart';

void main() {
  group('BloggerCatalogDataSource', () {
    test('parses public JSON feed entries with $t content', () async {
      final fakeClient = FakeApiClient(
        response: {
          'feed': {
            'entry': [
              {
                'content': {
                  '\$t': '{"@type":"Product","name":"Feed Item","offers":{"price":50.0}}'
                }
              }
            ]
          }
        },
      );

      final dataSource = BloggerCatalogDataSource(
        client: fakeClient,
        path: '/test/posts',
        scope: ApiScope.public,
      );

      final products = await dataSource.loadProducts(
        filter: const CatalogFilter(),
      );

      expect(products, hasLength(1));
      expect(products.first.name, 'Feed Item');
      expect(products.first.price, 50.0);
    });

    test('parses v3 REST items with string content', () async {
      final fakeClient = FakeApiClient(
        response: {
          'items': [
            {
              'content': '{"@type":"Product","name":"V3 Item","offers":{"price":75.0}}'
            }
          ]
        },
      );

      final dataSource = BloggerCatalogDataSource(
        client: fakeClient,
        path: '/blogs/123/posts',
        scope: ApiScope.authenticated,
      );

      final products = await dataSource.loadProducts(
        filter: const CatalogFilter(),
      );

      expect(products, hasLength(1));
      expect(products.first.name, 'V3 Item');
      expect(products.first.price, 75.0);
    });
  });
}

class FakeApiClient implements ApiClient {
  FakeApiClient({required this.response});

  final Object response;

  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return response;
  }
}
