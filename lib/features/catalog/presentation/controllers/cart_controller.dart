import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import '../../domain/entities/cart_wishlist_entities.dart';
import '../../domain/usecases/manage_cart_usecase.dart';

class CartSignalState {
  final List<CartItem> items;
  final bool isLoading;
  final String? error;

  const CartSignalState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  double get totalAmount => items.fold(
        0.0,
        (sum, item) => sum + ((item.price ?? 0.0) * item.quantity),
      );

  CartSignalState copyWith({
    List<CartItem>? items,
    bool? isLoading,
    String? error,
  }) {
    return CartSignalState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class CartController extends SignalCubit<CartSignalState> {
  final ManageCartUseCase manageCartUseCase;

  CartController({required this.manageCartUseCase}) : super(const CartSignalState());

  Future<void> loadCartAndVerify(Future<bool> Function(String blogId, String postId) checkAvailability) async {
    emit(state.copyWith(isLoading: true));
    try {
      final updatedItems = await manageCartUseCase.verifyCartAvailability(checkAvailability);
      emit(state.copyWith(items: updatedItems, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> addItem(CartItem item) async {
    await manageCartUseCase.addItem(item);
    final current = await manageCartUseCase.getCart();
    emit(state.copyWith(items: current));
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    await manageCartUseCase.updateQuantity(productId, quantity);
    final current = await manageCartUseCase.getCart();
    emit(state.copyWith(items: current));
  }

  Future<void> removeItem(String productId) async {
    await manageCartUseCase.removeItem(productId);
    final current = await manageCartUseCase.getCart();
    emit(state.copyWith(items: current));
  }

  Future<void> clear() async {
    await manageCartUseCase.clearCart();
    emit(state.copyWith(items: []));
  }
}
