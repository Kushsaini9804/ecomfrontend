import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';
import '../../data/models/product.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  bool loading = false;

  String selectedCategory = "All";

  List<Product> get products => _products;

  Future<void> fetchProducts({String category = "All"}) async {
    loading = true;
    selectedCategory = category;
    notifyListeners();

    try {
      String endpoint = '/products/get-products';

      if (category != "All") {
        endpoint += '?category=$category';
      }

      final res = await ApiService.get(endpoint);

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

  /// ✅ For CategoryScreen
  void setCategory(String category) {
    fetchProducts(category: category);
  }

  /// ✅ FIX FOR SEARCH
  List<Product> search(String query) {
    if (query.isEmpty) return _products;

    return _products
        .where(
          (p) => p.title.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }
}

