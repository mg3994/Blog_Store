import 'package:dio/dio.dart';
import '../../domain/entities/order.dart';

abstract interface class PaymentRepository {
  Future<OrderResponse> createOrder(OrderRequest request);
  Future<bool> recordPayment({
    required String orderId,
    required String paymentId,
    required PaymentMethod method,
  });
}

final class HonoPaymentRepository implements PaymentRepository {
  const HonoPaymentRepository({required this.dio});

  final Dio dio;

  static const String baseUrl = 'https://api.antinna.in/api/v1';

  @override
  Future<OrderResponse> createOrder(OrderRequest request) async {
    final response = await dio.post(
      '$baseUrl/orders',
      data: request.toJson(),
    );
    final data = response.data as Map<String, dynamic>;
    return OrderResponse(
      orderId: data['orderId'] as String? ?? 'ORD_${DateTime.now().millisecondsSinceEpoch}',
      status: data['status'] as String? ?? 'created',
      totalAmount: request.totalAmount,
      currency: request.currency,
    );
  }

  @override
  Future<bool> recordPayment({
    required String orderId,
    required String paymentId,
    required PaymentMethod method,
  }) async {
    final response = await dio.post(
      '$baseUrl/payments',
      data: {
        'orderId': orderId,
        'paymentId': paymentId,
        'method': method.name,
      },
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }
}
