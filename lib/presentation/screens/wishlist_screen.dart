import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/wishlist_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wish = context.watch<WishlistProvider>();
    final products = context.watch<ProductProvider>().products;

    final wishedProducts = products
        .where((p) => wish.wishlistIds.contains(p.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: wishedProducts.isEmpty
          ? const Center(child: Text('No items in wishlist'))
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: wishedProducts.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (_, i) =>
                  ProductCard(product: wishedProducts[i]),
            ),
    );
  }
}
