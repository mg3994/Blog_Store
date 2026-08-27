import '../entities/order_models.dart';
import '../repositories/payment_repository.dart';

class CreateOrderUseCase {
  final IPaymentRepository paymentRepository;

  CreateOrderUseCase({required this.paymentRepository});

  Future<OrderResponse> execute(OrderRequest request) {
    return paymentRepository.submitOrder(request);
  }
}
