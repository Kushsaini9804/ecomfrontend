import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../providers/cart_provider.dart';
import '../../core/services/api_service.dart';

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

  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onPaymentError);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Map<String, dynamic> get _address => {
        'fullName': _fullName.text,
        'phone': _phone.text,
        'pincode': _pincode.text,
        'city': _city.text,
        'state': _state.text,
        'addressLine': _addressLine.text,
        'landmark': _landmark.text,
      };

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
              const Text(
                'Delivery Address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              _field(_fullName, 'Full Name *'),
              _field(_phone, 'Phone *', TextInputType.phone),
              _field(_pincode, 'Pincode *', TextInputType.number),
              _field(_city, 'City *'),
              _field(_state, 'State *'),
              _field(_addressLine, 'Flat / House No *'),
              _field(_landmark, 'Landmark'),

              const SizedBox(height: 20),

              const Text(
                'Payment Method',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              RadioListTile(
                value: 'cod',
                groupValue: paymentMethod,
                onChanged: (v) => setState(() => paymentMethod = v!),
                title: const Text('Cash on Delivery'),
              ),

              RadioListTile(
                value: 'online',
                groupValue: paymentMethod,
                onChanged: (v) => setState(() => paymentMethod = v!),
                title: const Text('Pay Online (Razorpay)'),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : () => _submit(cart),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.green,
                  ),
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Place Order ₹${cart.total.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String label,
      [TextInputType? type]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: c,
        keyboardType: type,
        validator: (v) =>
            label.contains('*') && (v == null || v.isEmpty) ? 'Required' : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Future<void> _submit(CartProvider cart) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    if (paymentMethod == 'cod') {
      await cart.placeOrder(_address, 'cod');
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/order-success');
      }
      setState(() => _loading = false);
    } else {
      await _startOnlinePayment(cart.total);
    }
  }

  Future<void> _startOnlinePayment(double amount) async {
    final order = await ApiService.post('/payment/create-order', {
      'amount': amount,
    });

    _razorpay.open({
      'key': 'RAZORPAY_KEY_ID',
      'amount': order['amount'],
      'order_id': order['id'],
      'name': 'Shop App',
      'currency': 'INR',
    });
  }

  Future<void> _onPaymentSuccess(PaymentSuccessResponse response) async {
    await ApiService.post('/payment/verify', {
      'razorpay_order_id': response.orderId,
      'razorpay_payment_id': response.paymentId,
      'razorpay_signature': response.signature,
    });

    await context.read<CartProvider>().placeOrder(_address, 'online');

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/order-success');
    }
  }

  void _onPaymentError(PaymentFailureResponse response) {
    setState(() => _loading = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Payment Failed')));
  }
}
