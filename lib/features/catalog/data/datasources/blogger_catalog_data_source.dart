import '../../../../core/network/api_client.dart';
import '../../../../infrastructure/blogger/json_ld_product_parser.dart';
import '../models/store_product_model.dart';
import 'catalog_content_data_source.dart';

final class BloggerCatalogDataSource implements CatalogContentDataSource {
  const BloggerCatalogDataSource({
    required this.client,
    required this.path,
    this.parser = const JsonLdProductParser(),
  });

  final ApiClient client;
  final String path;
  final JsonLdProductParser parser;

  @override
  Future<List<StoreProductModel>> loadProducts() async {
    final data = await client.get(path);
    return parser.parse(data);
  }
}
