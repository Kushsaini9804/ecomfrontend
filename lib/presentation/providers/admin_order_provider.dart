import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';

class AdminOrderProvider extends ChangeNotifier {
  List orders = [];
  bool loading = false;

  Future<void> fetchAllOrders() async {
    loading = true;
    notifyListeners();

    try {
      final res = await ApiService.get('/admin/orders/all-orders');
      orders = res['orders'] ?? [];
    } catch (e) {
      orders = [];
    }

    loading = false;
    notifyListeners();
  }

  Future<void> updateStatus(String orderId, String status) async {
    await ApiService.put('/admin/orders/update-status', {
      "orderId": orderId,
      "status": status,
    });
    fetchAllOrders();
  }
}
