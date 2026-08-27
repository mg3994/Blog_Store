import 'package:flutter/material.dart';
import '../../domain/entities/cart_wishlist_entities.dart';

class CartPage extends StatelessWidget {
  final List<CartItem> cartItems;
  final double totalAmount;
  final Function(String productId, int quantity) onUpdateQuantity;
  final Function(String productId) onRemove;
  final VoidCallback onCheckout;

  const CartPage({
    super.key,
    required this.cartItems,
    required this.totalAmount,
    required this.onUpdateQuantity,
    required this.onRemove,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Text('Your cart is empty'),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: cartItems.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return ListTile(
                        leading: item.imageUrl != null
                            ? Image.network(item.imageUrl!, width: 50, height: 50, fit: BoxFit.cover)
                            : const Icon(Icons.shopping_bag, size: 40),
                        title: Text(item.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('\$${(item.price ?? 0.0).toStringAsFixed(2)}'),
                            if (!item.isAvailable)
                              const Text(
                                'Currently Unavailable / Out of Stock',
                                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                              ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () => onUpdateQuantity(item.productId, item.quantity - 1),
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () => onUpdateQuantity(item.productId, item.quantity + 1),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => onRemove(item.productId),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Total:', style: TextStyle(color: Colors.grey)),
                            Text(
                              '\$${totalAmount.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: cartItems.any((i) => !i.isAvailable) ? null : onCheckout,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: const Text('Checkout'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
