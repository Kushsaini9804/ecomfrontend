import 'package:razorpay_flutter/razorpay_flutter.dart';
import '/core/services/api_service.dart';

class PaymentService {
  final Razorpay _razorpay = Razorpay();

  void init({
    required Function(String) onSuccess,
    required Function(String) onError,
  }) {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
        (res) => onSuccess(res.paymentId!));

    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
        (res) => onError(res.message ?? "Payment Failed"));
  }

  Future<void> pay(int amount) async {
    final order = await ApiService.post('/payment/create-order', {
      'amount': amount,
    });

    var options = {
      'key': 'rzp_test_xxxxx',
      'amount': order['amount'],
      'order_id': order['id'],
      'name': 'Ecommerce App',
      'currency': 'INR',
      'prefill': {'email': 'test@gmail.com'}
    };

    _razorpay.open(options);
  }

  void dispose() {
    _razorpay.clear();
  }
}
