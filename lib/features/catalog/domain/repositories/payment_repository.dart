import '../entities/order_models.dart';

abstract class IPaymentRepository {
  Future<OrderResponse> submitOrder(OrderRequest request);
}
