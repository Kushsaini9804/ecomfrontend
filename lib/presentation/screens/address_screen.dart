import 'package:flutter/material.dart';
import 'package:mobile/presentation/providers/cart_provider.dart';
import 'package:mobile/presentation/providers/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/services/api_service.dart';
import '../../data/models/product.dart';

class AddressScreen extends StatefulWidget {
  final Product? product; // Product passed from BuyNow button
  const AddressScreen({super.key, this.product});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _phone = TextEditingController();
  final _pincode = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _addressLine = TextEditingController();
  final _landmark = TextEditingController();

  String _paymentMethod = 'cod';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    // _loadAddress(); // Commented out to avoid 400 error if backend doesn't have GET /address
  }

  @override
  void dispose() {
    _fullName.dispose();
    _phone.dispose();
    _pincode.dispose();
    _city.dispose();
    _state.dispose();
    _addressLine.dispose();
    _landmark.dispose();
    super.dispose();
  }

  Future<void> _loadAddress() async {
    try {
      final res = await ApiService.get('/address');
      if (res['data'] != null && (res['data'] as List).isNotEmpty) {
        final data = res['data'][0]; // Use first saved address
        _fullName.text = data['fullName'] ?? '';
        _phone.text = data['phone'] ?? '';
        _pincode.text = data['pincode'] ?? '';
        _city.text = data['city'] ?? '';
        _state.text = data['state'] ?? '';
        _addressLine.text = data['addressLine'] ?? '';
        _landmark.text = data['landmark'] ?? '';
      }
    } catch (e) {
      debugPrint('Load address error: $e');
    }
  }

  Widget _buildField(TextEditingController controller, String label,
      {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        validator: (v) =>
            label.contains('*') && (v == null || v.isEmpty) ? 'Required' : null,
      ),
    );
  }

  Future<void> _saveAddressAndPlaceOrder() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _loading = true);

  final address = {
    'fullName': _fullName.text.trim(),
    'phone': _phone.text.trim(),
    'pincode': _pincode.text.trim(),
    'city': _city.text.trim(),
    'state': _state.text.trim(),
    'addressLine': _addressLine.text.trim(),
    'landmark': _landmark.text.trim(),
  };


  try {
    // 1️⃣ Save address
    await ApiService.post('/address', address);

    final cartProvider = context.read<CartProvider>();

    // 🔥 BUY NOW (NO CART INVOLVED AT ALL)
    if (widget.product != null) {
      await cartProvider.buyNow(
        widget.product!,   // ✅ single product
        address,
        _paymentMethod,
      );
    } 
    // 🛒 CART CHECKOUT
    else {
      await cartProvider.placeOrder(
        address,
        _paymentMethod,
      );
    }

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/order-success');
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  } finally {
    if (mounted) setState(() => _loading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Address'),
        backgroundColor: Colors.indigo,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildField(_fullName, 'Full Name *'),
                    _buildField(_phone, 'Phone *', keyboardType: TextInputType.phone),
                    _buildField(_pincode, 'Pincode *', keyboardType: TextInputType.number),
                    _buildField(_city, 'City *'),
                    _buildField(_state, 'State *'),
                    _buildField(_addressLine, 'Flat, House no., Building *'),
                    _buildField(_landmark, 'Landmark (Optional)'),
                    const SizedBox(height: 20),

                    const Text(
                      'Payment Method',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    RadioListTile<String>(
                      title: const Text('Cash on Delivery'),
                      value: 'cod',
                      groupValue: _paymentMethod,
                      onChanged: (v) => setState(() => _paymentMethod = v!),
                    ),
                    RadioListTile<String>(
                      title: const Text('Pay Online (UPI QR)'),
                      value: 'online',
                      groupValue: _paymentMethod,
                      onChanged: (v) => setState(() => _paymentMethod = v!),
                    ),
                    if (_paymentMethod == 'online')
                      Center(
                        child: QrImageView(
                          data:
                              'upi://pay?pa=merchant@upi&am=0&cu=INR&tn=ShopApp-Order', // Can replace 0 with dynamic amount
                          size: 200,
                        ),
                      ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveAddressAndPlaceOrder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Color.fromARGB(255, 219, 216, 216),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        // child: Text(widget.product != null ? 'Place Order' : 'Save Address'),
                        child: const Text('Place Order'),

                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
