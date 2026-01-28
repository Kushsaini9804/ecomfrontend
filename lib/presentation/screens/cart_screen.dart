import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item_tile.dart';

class CartScreen extends StatefulWidget {
  final String userId;
  const CartScreen({super.key, required this.userId});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch cart only when navigating to cart screen
      Provider.of<CartProvider>(context, listen: false).fetchCart();
    });
  }

@override
Widget build(BuildContext context) {
  final cart = context.watch<CartProvider>();

  /// 🔹 Height of glass navbar + safe spacing
  const double bottomNavHeight = 90;

  return Scaffold(
    appBar: AppBar(title: const Text("My Cart"),
    backgroundColor: Colors.indigo,
    foregroundColor: Colors.white,
    ),

    body: cart.items.isEmpty
        ? const Center(child: Text("Cart is empty"))
        : Column(
            children: [
              /// 🛒 CART ITEMS
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: bottomNavHeight),
                  itemCount: cart.items.length,
                  itemBuilder: (_, i) {
                    final item = cart.items[i];
                    return CartItemTile(
                      product: item.product,
                      qty: item.qty,
                    );
                  },
                ),
              ),

              /// 💰 TOTAL + CHECKOUT (FIXED ABOVE NAVBAR)
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Total: ₹ ${cart.total.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 14,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/checkout');
                        },
                        child: const Text("Checkout"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
  );
}
}