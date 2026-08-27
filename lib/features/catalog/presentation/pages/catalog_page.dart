import 'package:bloc_signals_flutter/bloc_signals_flutter.dart'
    show BlocSignalBuilder;
import 'package:flutter/material.dart';

import '../../domain/entities/store_product.dart';
import '../../domain/usecases/get_catalog_products.dart';
import '../cubit/catalog_cubit.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({required this.getProducts, super.key});

  final GetCatalogProducts getProducts;

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  late final CatalogCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = CatalogCubit(widget.getProducts)..loadProducts();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Future<void> _refresh() => _cubit.loadProducts(forceRefresh: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store catalog'),
        actions: [
          IconButton(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh catalog',
          ),
        ],
      ),
      body: BlocSignalBuilder<CatalogCubit, CatalogState>(
        bloc: _cubit,
        builder: (context, state) => switch (state) {
          CatalogInitial() || CatalogLoading() =>
            const Center(child: CircularProgressIndicator()),
          CatalogError(:final message) => Center(
            child: Text('Could not load catalog: $message'),
          ),
          CatalogLoaded(:final products) => products.isEmpty
              ? const Center(child: Text('No products available.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: products.length,
                  itemBuilder: (context, index) =>
                      _ProductTile(product: products[index]),
                ),
        },
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product});

  final StoreProduct product;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: product.imageUrl == null
            ? const Icon(Icons.shopping_bag_outlined)
            : Image.network(product.imageUrl!, width: 56, fit: BoxFit.cover),
        title: Text(product.name),
        subtitle: Text(product.description),
        trailing: product.price == null
            ? null
            : Text('${product.currency ?? ''} ${product.price}'),
      ),
    );
  }
}
