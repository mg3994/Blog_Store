import '../../domain/entities/order_models.dart';
import '../../domain/repositories/payment_repository.dart';
import '../../../infrastructure/network/hono_payment_api_client.dart';

class PaymentRepositoryImpl implements IPaymentRepository {
  final HonoPaymentApiClient client;

  PaymentRepositoryImpl({required this.client});

  @override
  Future<OrderResponse> submitOrder(OrderRequest request) {
    return client.createOrder(request);
  }
}
