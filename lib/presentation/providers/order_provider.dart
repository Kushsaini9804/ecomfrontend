// import 'package:flutter/material.dart';
// import '../../core/services/api_service.dart';

// // class OrderProvider extends ChangeNotifier {
// //   List<Map<String, dynamic>> _orders = [];
// //   bool _loading = false;

// //   List<Map<String, dynamic>> get orders => _orders;
// //   bool get loading => _loading;

// //   Future<void> fetchOrders() async {
// //     try {
// //       _loading = true;
// //       notifyListeners();

// //       final response = await ApiService.get('/orders/get-order');

// //       /// BACKEND RETURNS: { success: true, orders: [...] }
// //       final List list = response['orders'] ?? [];

// //       _orders = list.cast<Map<String, dynamic>>();
// //     } catch (e) {
// //       debugPrint("Fetch orders error: $e");
// //       _orders = [];
// //     } finally {
// //       _loading = false;
// //       notifyListeners();
// //     }
// //   }

// //   void clearOrders() {
// //     _orders = [];
// //     notifyListeners();
// //   }
// // }

// class OrderProvider extends ChangeNotifier {
//   List<Map<String, dynamic>> _orders = [];
//   bool _loading = false;

//   List<Map<String, dynamic>> get orders => _orders;
//   bool get loading => _loading;

//   Future<void> fetchOrders() async {
//     try {
//       _loading = true;
//       notifyListeners();

//       final response = await ApiService.get('/orders/get-order');
//       _orders = List<Map<String, dynamic>>.from(response['orders'] ?? []);
//     } catch (e) {
//       debugPrint("Fetch orders error: $e");
//       _orders = [];
//     } finally {
//       _loading = false;
//       notifyListeners();
//     }
//   }
// }

import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';
import '../../data/models/order.dart';

class OrderProvider extends ChangeNotifier {
  List<Order> _orders = [];
  bool _loading = false;

  List<Order> get orders => _orders;
  bool get loading => _loading;

  Future<void> fetchOrders() async {
    try {
      _loading = true;
      notifyListeners();

      final response = await ApiService.get('/orders/get-order');
      final List list = response['orders'] ?? [];

      _orders = list.map((e) => Order.fromJson(e)).toList();
    } catch (e) {
      debugPrint("Fetch orders error: $e");
      _orders = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

Future<void> cancelOrder(String orderId) async {
  await ApiService.patch('/orders/$orderId/cancel');
  await fetchOrders();
}

Future<void> requestReturn(String orderId, String reason) async {
  await ApiService.patch(
    '/orders/$orderId/return',
    body: { "reason": reason },
  );
  await fetchOrders();
}


}
