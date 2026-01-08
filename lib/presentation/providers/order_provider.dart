import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';

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

//       /// BACKEND RETURNS: { success: true, orders: [...] }
//       final List list = response['orders'] ?? [];

//       _orders = list.cast<Map<String, dynamic>>();
//     } catch (e) {
//       debugPrint("Fetch orders error: $e");
//       _orders = [];
//     } finally {
//       _loading = false;
//       notifyListeners();
//     }
//   }

//   void clearOrders() {
//     _orders = [];
//     notifyListeners();
//   }
// }

class OrderProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _orders = [];
  bool _loading = false;

  List<Map<String, dynamic>> get orders => _orders;
  bool get loading => _loading;

  Future<void> fetchOrders() async {
    try {
      _loading = true;
      notifyListeners();

      final response = await ApiService.get('/orders/get-order');
      _orders = List<Map<String, dynamic>>.from(response['orders'] ?? []);
    } catch (e) {
      debugPrint("Fetch orders error: $e");
      _orders = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}