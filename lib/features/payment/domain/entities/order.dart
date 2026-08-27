enum PaymentMethod {
  applePay,
  googlePay,
  upi,
  cashOnDelivery,
}

final class OrderRequest {
  const OrderRequest({
    required this.items,
    required this.totalAmount,
    required this.currency,
    required this.shippingAddress,
    required this.paymentMethod,
  });

  final List<Map<String, dynamic>> items;
  final double totalAmount;
  final String currency;
  final String shippingAddress;
  final PaymentMethod paymentMethod;

  Map<String, dynamic> toJson() => {
        'items': items,
        'totalAmount': totalAmount,
        'currency': currency,
        'shippingAddress': shippingAddress,
        'paymentMethod': paymentMethod.name,
      };
}

final class OrderResponse {
  const OrderResponse({
    required this.orderId,
    required this.status,
    required this.totalAmount,
    required this.currency,
  });

  final String orderId;
  final String status;
  final double totalAmount;
  final String currency;
}
