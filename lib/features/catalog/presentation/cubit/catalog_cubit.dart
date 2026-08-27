import 'package:bloc_signals_flutter/bloc_signals_flutter.dart' show CubitSignal;

import '../../domain/entities/catalog_filter.dart';
import '../../domain/entities/store_product.dart';
import '../../domain/usecases/get_catalog_products.dart';

sealed class CatalogState {
  const CatalogState();
}

final class CatalogInitial extends CatalogState {
  const CatalogInitial();
}

final class CatalogLoading extends CatalogState {
  const CatalogLoading();
}

final class CatalogLoaded extends CatalogState {
  const CatalogLoaded(this.products);

  final List<StoreProduct> products;
}

final class CatalogError extends CatalogState {
  const CatalogError(this.message);

  final String message;
}

class CatalogCubit extends CubitSignal<CatalogState> {
  CatalogCubit(this._getProducts)
      : super(initialState: const CatalogInitial());

  final GetCatalogProducts _getProducts;

  Future<void> loadProducts({
    CatalogFilter filter = const CatalogFilter(),
    bool forceRefresh = false,
  }) async {
    emit(const CatalogLoading());
    try {
      final products = await _getProducts(
        filter: filter,
        forceRefresh: forceRefresh,
      );
      emit(CatalogLoaded(products));
    } catch (error) {
      emit(CatalogError(error.toString()));
    }
  }
}
