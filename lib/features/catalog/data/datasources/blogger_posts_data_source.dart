import '../../domain/entities/catalog_filter.dart';
import '../../domain/entities/blogger_post.dart';

abstract interface class BloggerPostsDataSource {
  Future<List<BloggerPost>> fetchPosts(CatalogFilter filter);

  Future<BloggerPost?> fetchPost({required String postId});
}
