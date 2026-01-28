import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';
import '../../data/models/order.dart';

class OrderProvider extends ChangeNotifier {
  bool loading = false;
  List<Order> orders = [];


  Future<void> fetchOrders() async {
  loading = true;
  notifyListeners();

  try {
    final res = await ApiService.get('/orders/get-order');

    final List list = res['data'] ?? [];

    orders = list.map((e) => Order.fromJson(e)).toList();
  } catch (e) {
    debugPrint("Fetch orders error: $e");
    orders = [];
  }

  loading = false;
  notifyListeners();
}



Future<void> cancelOrder(String orderId) async {
    await ApiService.patch('/orders/$orderId/cancel');
    await fetchOrders();
  }

  Future<void> requestReturn(String orderId, String reason) async {
    await ApiService.patch(
      '/orders/$orderId/return',
      body: {"reason": reason},
    );
    await fetchOrders();
  }
}