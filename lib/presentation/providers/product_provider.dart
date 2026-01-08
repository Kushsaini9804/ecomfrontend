import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';
import '../../data/models/product.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  bool loading = false;

  List<Product> get products => _products;

  Future<void> fetchProducts() async {
    loading = true;
    notifyListeners();

    try {
      final res = await ApiService.get('/products/get-products');

      _products = (res['data'] as List)
          .map((e) => Product.fromJson(e))
          .toList();
    } catch (e) {
      debugPrint('Product fetch error: $e');
      _products = [];
    }

    loading = false;
    notifyListeners();
  }

  List<Product> search(String query) {
    if (query.isEmpty) return _products;

    return _products
        .where((p) =>
            p.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
