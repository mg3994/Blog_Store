import 'package:flutter/material.dart';
import '../../domain/entities/cart_wishlist_entities.dart';

class CheckoutPage extends StatefulWidget {
  final List<CartItem> cartItems;
  final double totalAmount;
  final Function(String method, String address) onPlaceOrder;

  const CheckoutPage({
    super.key,
    required this.cartItems,
    required this.totalAmount,
    required this.onPlaceOrder,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _addressController = TextEditingController();
  String _selectedPaymentMethod = 'google_pay';

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Shipping Address', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _addressController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Enter full delivery address...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Text('Select Payment Method', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            RadioListTile<String>(
              title: const Text('Google Pay'),
              value: 'google_pay',
              groupValue: _selectedPaymentMethod,
              onChanged: (v) => setState(() => _selectedPaymentMethod = v!),
            ),
            RadioListTile<String>(
              title: const Text('Google Pay UPI'),
              value: 'gpay_upi',
              groupValue: _selectedPaymentMethod,
              onChanged: (v) => setState(() => _selectedPaymentMethod = v!),
            ),
            RadioListTile<String>(
              title: const Text('Apple Pay'),
              value: 'apple_pay',
              groupValue: _selectedPaymentMethod,
              onChanged: (v) => setState(() => _selectedPaymentMethod = v!),
            ),
            RadioListTile<String>(
              title: const Text('Cash on Delivery (COD)'),
              value: 'cod',
              groupValue: _selectedPaymentMethod,
              onChanged: (v) => setState(() => _selectedPaymentMethod = v!),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Amount:', style: TextStyle(fontSize: 16)),
                Text(
                  '\$${widget.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  if (_addressController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a shipping address')),
                    );
                    return;
                  }
                  widget.onPlaceOrder(
                    _selectedPaymentMethod,
                    _addressController.text.trim(),
                  );
                },
                child: const Text('Place Order'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
