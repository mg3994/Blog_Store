class OrderRequest {
  final String orderId;
  final List<CartItemPayload> items;
  final double totalAmount;
  final String currency;
  final String paymentMethod;
  final String? paymentTransactionId;
  final String shippingAddress;

  const OrderRequest({
    required this.orderId,
    required this.items,
    required this.totalAmount,
    required this.currency,
    required this.paymentMethod,
    this.paymentTransactionId,
    required this.shippingAddress,
  });

  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'items': items.map((i) => i.toJson()).toList(),
        'totalAmount': totalAmount,
        'currency': currency,
        'paymentMethod': paymentMethod,
        'paymentTransactionId': paymentTransactionId,
        'shippingAddress': shippingAddress,
      };
}

class CartItemPayload {
  final String productId;
  final String title;
  final int quantity;
  final double price;

  const CartItemPayload({
    required this.productId,
    required this.title,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'title': title,
        'quantity': quantity,
        'price': price,
      };
}

class OrderResponse {
  final bool success;
  final String orderId;
  final String? message;

  const OrderResponse({
    required this.success,
    required this.orderId,
    this.message,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) => OrderResponse(
        success: json['success'] as bool? ?? false,
        orderId: json['orderId'] as String? ?? '',
        message: json['message'] as String?,
      );
}
