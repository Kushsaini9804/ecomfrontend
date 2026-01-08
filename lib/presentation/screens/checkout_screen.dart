// lib/presentation/screens/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _phone = TextEditingController();
  final _pincode = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _addressLine = TextEditingController();
  final _landmark = TextEditingController();

  String paymentMethod = 'cod';
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PERSONAL INFO – ADDRESS FORM (REQUIRED)
              const Text('Delivery Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildField(_fullName, 'Full Name *'),
              _buildField(_phone, 'Phone *', keyboardType: TextInputType.phone),
              _buildField(_pincode, 'Pincode *', keyboardType: TextInputType.number),
              _buildField(_city, 'City *'),
              _buildField(_state, 'State *'),
              _buildField(_addressLine, 'Flat, House no., Building *'),
              _buildField(_landmark, 'Landmark (Optional)'),

              const SizedBox(height: 20),

              // PAYMENT OPTIONS
              const Text('Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              RadioListTile<String>(
                title: const Text('Cash on Delivery'),
                value: 'cod',
                groupValue: paymentMethod,
                onChanged: (v) => setState(() => paymentMethod = v!),
              ),
              RadioListTile<String>(
                title: const Text('Pay Online (UPI QR)'),
                value: 'online',
                groupValue: paymentMethod,
                onChanged: (v) => setState(() => paymentMethod = v!),
              ),

              if (paymentMethod == 'online')
                Center(
                  child: QrImageView(
                    data: 'upi://pay?pa=merchant@upi&am=${cart.total}&cu=INR&tn=ShopApp-Order',
                    size: 200,
                  ),
                ),

              const SizedBox(height: 20),

              // PLACE ORDER (SAVES TO ORDERS)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _placeOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text('Place Order - ₹${cart.total.toStringAsFixed(0)}'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label, {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        validator: (v) => label.contains('*') && (v == null || v.isEmpty) ? 'Required' : null,
      ),
    );
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      // PERSONAL INFO (ADDRESS) + PAYMENT
      final address = {
        'fullName': _fullName.text,
        'phone': _phone.text,
        'pincode': _pincode.text,
        'city': _city.text,
        'state': _state.text,
        'addressLine': _addressLine.text,
        'landmark': _landmark.text,
      };

      // CALL ORDER API (SAVES TO ORDERS)
      await context.read<CartProvider>().placeOrder(address, paymentMethod);

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/order-success',);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      setState(() => _loading = false);
    }
  }
}