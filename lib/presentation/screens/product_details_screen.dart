import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/product.dart';
import '../providers/cart_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    final screenHeight = MediaQuery.of(context).size.height;

    final price = product.price;
    final discount = product.discount ?? 0;
    final finalPrice = price - ((price * discount) / 100);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// PRODUCT IMAGE
              SizedBox(
                height: screenHeight * 0.45,
                width: double.infinity,
                child: product.image != null && product.image!.isNotEmpty
                    ? Image.network(
                        product.image!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image, size: 80),
                      )
                    : Image.asset(
                        'assets/images/placeholder.png',
                        fit: BoxFit.cover,
                      ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TITLE
                    Text(
                      product.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// RATING
                    Row(
                      children: [
                        const Icon(Icons.star,
                            color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(product.rating.toString()),
                      ],
                    ),

                    const SizedBox(height: 10),

                    /// PRICE
                    Row(
                      children: [
                        Text(
                          "₹${finalPrice.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        if (discount > 0)
                          Text(
                            "₹$price",
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                        const SizedBox(width: 8),
                        if (discount > 0)
                          Text(
                            "$discount% OFF",
                            style: const TextStyle(color: Colors.green),
                          ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// COLORS
                    if (product.colors != null &&
                        product.colors!.isNotEmpty) ...[
                      const Text(
                        "Available Colors",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: product.colors!
                            .map((c) => Chip(label: Text(c)))
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                    ],

                    /// HIGHLIGHTS
                    if (product.highlights != null &&
                        product.highlights!.isNotEmpty) ...[
                      const Text(
                        "Highlights",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ...product.highlights!.map(
                        (h) => Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check, size: 16),
                            const SizedBox(width: 6),
                            Expanded(child: Text(h)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    /// DESCRIPTION
                    const Text(
                      "Description",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(product.description ?? "No description available"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      /// BOTTOM ACTIONS
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
          12,
          12,
          12,
          MediaQuery.of(context).padding.bottom + 12,
        ),
        child: Row(
          children: [
            /// ADD TO CART
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await cart.addToCart(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Added to cart")),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                },
                child: const Text("ADD TO CART"),
              ),
            ),

            const SizedBox(width: 12),

            /// BUY NOW (🔥 ONLY NAVIGATION)
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/address',
                    arguments: product, // ✅ REQUIRED
                  );
                },
                child: const Text("BUY NOW"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
