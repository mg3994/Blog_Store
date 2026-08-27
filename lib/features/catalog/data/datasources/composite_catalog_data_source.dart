import '../../../../core/auth/access_token_provider.dart';
import '../models/store_product_model.dart';
import 'catalog_content_data_source.dart';

final class CompositeCatalogDataSource implements CatalogContentDataSource {
  const CompositeCatalogDataSource({
    required this.publicSource,
    required this.authenticatedSource,
    required this.sharedSource,
    required this.accessTokenProvider,
  });

  final CatalogContentDataSource publicSource;
  final CatalogContentDataSource authenticatedSource;
  final CatalogContentDataSource sharedSource;
  final AccessTokenProvider accessTokenProvider;

  @override
  Future<List<StoreProductModel>> loadProducts() async {
    final token = await accessTokenProvider.getAccessToken();
    final primary = token == null ? publicSource : authenticatedSource;
    final products = await primary.loadProducts();
    return products.isEmpty ? sharedSource.loadProducts() : products;
  }
}
