import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../config/app_config.dart';
import '../core/auth/access_token_provider.dart';
import '../core/network/api_client.dart';
import '../core/network/api_scope.dart';
import '../core/network/scoped_api_client.dart';
import '../features/catalog/data/datasources/blogger_catalog_data_source.dart';
import '../features/catalog/data/datasources/catalog_content_data_source.dart';
import '../features/catalog/data/datasources/composite_catalog_data_source.dart';
import '../features/catalog/data/repositories/catalog_repository_impl.dart';
import '../features/catalog/domain/usecases/get_catalog_products.dart';
import '../features/catalog/domain/services/catalog_serviceability.dart';
import '../infrastructure/auth/firebase_access_token_provider.dart';
import '../infrastructure/database/drift/app_database.dart';
import '../infrastructure/database/drift/drift_catalog_cache.dart';

final class Dependencies {
  factory Dependencies.create() {
    final database = AppDatabase();
    final tokenProvider = FirebaseAccessTokenProvider(FirebaseAuth.instance);
    final publicClient = _client(AppConfig.publicApiBaseUrl);
    final authenticatedClient = _client(
      AppConfig.authenticatedApiBaseUrl,
      tokenProvider: tokenProvider,
    );
    final sharedClient = _client(AppConfig.sharedApiBaseUrl);
    final content = _catalogContentSource(
      publicClient: publicClient,
      authenticatedClient: authenticatedClient,
      sharedClient: sharedClient,
      tokenProvider: tokenProvider,
    );
    final cache = DriftCatalogCache(database);
    final repository = CatalogRepositoryImpl(
      content,
      cache,
      const CatalogServiceability(),
    );

    return Dependencies._(database, GetCatalogProducts(repository));
  }

  const Dependencies._(this.database, this.getCatalogProducts);

  final AppDatabase database;
  final GetCatalogProducts getCatalogProducts;

  Future<void> dispose() => database.close();

  static ApiClient _client(
    String baseUrl, {
    AccessTokenProvider? tokenProvider,
  }) {
    return ScopedApiClient(
      dio: Dio(BaseOptions(baseUrl: baseUrl)),
      scope: tokenProvider == null ? ApiScope.public : ApiScope.authenticated,
      accessTokenProvider: tokenProvider,
    );
  }

  static CatalogContentDataSource _catalogContentSource({
    required ApiClient publicClient,
    required ApiClient authenticatedClient,
    required ApiClient sharedClient,
    required AccessTokenProvider tokenProvider,
  }) {
    return CompositeCatalogDataSource(
      publicSource: BloggerCatalogDataSource(
        client: publicClient,
        path: AppConfig.publicCatalogPath,
        scope: ApiScope.public,
      ),
      authenticatedSource: BloggerCatalogDataSource(
        client: authenticatedClient,
        path: AppConfig.authenticatedCatalogPath,
        scope: ApiScope.authenticated,
      ),
      sharedSource: BloggerCatalogDataSource(
        client: sharedClient,
        path: AppConfig.sharedCatalogPath,
        scope: ApiScope.shared,
      ),
      accessTokenProvider: tokenProvider,
    );
  }
}
