import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../features/catalog/domain/usecases/get_catalog_products.dart';
import '../features/catalog/presentation/pages/catalog_page.dart';
import '../generated/app_localizations.dart';

class BlogStoreApp extends StatelessWidget {
  const BlogStoreApp({required this.getProducts, super.key});

  final GetCatalogProducts getProducts;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlogStore',
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: CatalogPage(getProducts: getProducts),
    );
  }
}
