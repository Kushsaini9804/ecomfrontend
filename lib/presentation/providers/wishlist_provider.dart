import 'package:flutter/material.dart';
import '../../data/models/product.dart';
import '../../core/services/api_service.dart';

class WishlistProvider extends ChangeNotifier {
  /// 🔥 STORE ONLY IDS
  final Set<String> _wishlistIds = {};

  Set<String> get wishlistIds => _wishlistIds;

  /// Used by UI
  bool isWished(String productId) {
    return _wishlistIds.contains(productId);
  }

  /// ✅ FETCH FROM DB (PER USER, MULTIPLE ITEMS)
  Future<void> fetchWishlist() async {
    try {
      final res = await ApiService.get('/wishlist/get-wishlist');
      final List data = res['wishlist'] ?? [];

      _wishlistIds
        ..clear()
        ..addAll(
          data.map((e) => e['productId']['_id'].toString()),
        );

      notifyListeners();
    } catch (_) {
      _wishlistIds.clear();
      notifyListeners();
    }
  }

  /// ✅ TOGGLE (NO STATE LOSS)
  Future<void> toggleWishlist(Product product) async {
    final res = await ApiService.post(
      '/wishlist/toggle',
      {'productId': product.id},
    );

    final wished = res['wished'] == true;

    if (wished) {
      _wishlistIds.add(product.id);
    } else {
      _wishlistIds.remove(product.id);
    }

    notifyListeners();
  }

  /// 🔥 CLEAR ONLY ON LOGOUT
  void clearWishlist() {
    _wishlistIds.clear();
    notifyListeners();
  }
}
