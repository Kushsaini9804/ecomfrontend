import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminOrderProvider with ChangeNotifier {
  List orders = [];
  bool loading = false;

  /// Fetch all pending/approved orders
  Future<void> fetchAllOrders(String token) async {
    loading = true;
    notifyListeners();

    try {
      final res = await http.get(
        // Uri.parse("http://10.127.96.237:5000/api/admin/orders/all-orders"),
        Uri.parse("https://ecommerce-backend-1-5jga.onrender.com/api/admin/orders/all-orders"),

        headers: {"Authorization": "Bearer $token"},
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body)['orders'] as List;
        orders = data;
      } else {
        orders = [];
      }
    } catch (e) {
      orders = [];
    }

    loading = false;
    notifyListeners();
  }

  /// Update order status and refresh orders
  Future<void> updateOrderStatus({
    required String orderId,
    required String status,
    required String token,
  }) async {
    try {
      loading = true;
      notifyListeners();

      final res = await http.put(
        // Uri.parse("http://10.127.96.237:5000/api/admin/orders/update-status"),
        Uri.parse("https://ecommerce-backend-1-5jga.onrender.com/api/admin/orders/update-status"),

        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"orderId": orderId, "status": status}),
      );

      if (res.statusCode == 200) {
        // refresh orders after update
        await fetchAllOrders(token);
      }
    } catch (e) {
      // handle error
    }

    loading = false;
    notifyListeners();
  }

  /// Clear orders (logout)
  void logout() {
    orders = [];
    loading = false;
    notifyListeners();
  }
}
