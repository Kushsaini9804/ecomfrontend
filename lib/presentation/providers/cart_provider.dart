// lib/presentation/providers/cart_provider.dart
import 'package:flutter/material.dart';
import '../../data/models/product.dart';
import '../../core/services/api_service.dart';

class CartItem {
  final Product product;
  int qty;

  CartItem({required this.product, this.qty = 1});
}

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];
  List<CartItem> get items => _items;

  double get total =>
      _items.fold(0, (sum, item) => sum + item.product.price * item.qty);

  // FETCH CART
  Future<void> fetchCart() async {
    try {
      final response = await ApiService.get('/cart/get-cart');

      final List<dynamic> cartItems = response["items"] ?? [];

      _items = cartItems.map((item) {
        final productJson = item["productId"];
        final product = Product.fromJson(productJson);
        return CartItem(product: product, qty: item["qty"] ?? 1);
      }).toList();

      notifyListeners();
    } catch (e) {
      debugPrint("Fetch cart error: $e");
      // For unauthenticated users, ensure cart is empty
      _items = [];
      notifyListeners();
    }
  }

  // ADD TO CART
  Future<void> addToCart(Product product) async {
    if (ApiService.authToken == null) {
      throw Exception("Please login to add items to cart");
    }
    try {
      await ApiService.post('/cart/add-to-cart', {
        'productId': product.id,
        'qty': 1,
      });

      await fetchCart();
    } catch (e) {
      debugPrint("Add to cart error: $e");
      throw Exception("Failed to add to cart: $e");
    }
  }



  // REMOVE ITEM
  Future<void> removeFromCart(String productId) async {
    try {
      await ApiService.post('/cart/remove-item', {
        'productId': productId,
      });

      await fetchCart();
    } catch (e) {
      debugPrint("Remove item error: $e");
    }
  }

  // PLACE ORDER
  Future<dynamic> placeOrder(
      Map<String, dynamic> address, String paymentMethod, [List<CartItem>? items]) async {
    try {
      final itemsToOrder = items ?? _items;
      final data = {
        'payment_type': paymentMethod.toUpperCase(),

            'address': {
            "fullName": address['fullName'],
            "phone": address['phone'],
            "pincode": address['pincode'],
            "city": address['city'],
            "state": address['state'],
            "addressLine": address['addressLine'],
            "landmark": address['landmark'],
          },

        'items': itemsToOrder.map((item) => {'product_id': item.product.id, 'qty': item.qty}).toList()
      };

      final response = await ApiService.post('/orders/create-order', data);

      if (items == null) {
        _items.clear();
        notifyListeners();
      }

      return response;
    } catch (e) {
      debugPrint("Place order error: $e");
      rethrow;
    }
  }
  Future<void> buyNow(
  Product product,
  Map<String, dynamic> address,
  String paymentMethod,
    ) async {
    final data = {
      'payment_type': paymentMethod.toUpperCase(),
      'address': address,
      'items': [{'product_id': product.id, 'qty': 1}]
    };

    final response = await ApiService.post('/orders/buy-now', data);

    if (response == null) {
      throw Exception('Buy now failed');
    }
  }

  //new changes
  Future<void> increaseQuantity(String productId) async {
    try {
      await ApiService.post('/cart/increase-item', {
        'productId': productId,
      });

      await fetchCart();
    } catch (e) {
      debugPrint("Increase item error: $e");
    }
    
  }

  Future<void> reduceQuantity(String productId) async {
  try {
      await ApiService.post('/cart/reduce-item', {
        'productId': productId,
      });

      await fetchCart();
    } catch (e) {
      debugPrint("reduce item error: $e");
    }

  }


  // CLEAR CART
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
