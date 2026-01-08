import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    final auth = context.read<AuthProvider>();

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/product-details',
          arguments: product, // send product ID
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                product.image ?? "",
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, size: 80),
              ),
            ),

            // Product Title
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),

            // Product Price
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "₹${product.price}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Buttons row (prevent tap conflict)
            // Row(
            //   children: [
            //     Expanded(
            //       child: TextButton(
            //         onPressed: () async {
            //           try {
            //             await cart.addToCart(product);

            //             ScaffoldMessenger.of(context).showSnackBar(
            //               const SnackBar(content: Text("Added to cart")),
            //             );

            //             Navigator.pushNamed(context, "/cart");
            //           } catch (e) {
            //             ScaffoldMessenger.of(context).showSnackBar(
            //               SnackBar(content: Text("Failed: $e")),
            //             );
            //           }
            //         },
            //         child: const Text("Add Cart"),
            //       ),
            //     ),

            //     Expanded(
            //       child: TextButton(
            //         onPressed: () {
            //           Navigator.pushNamed(
            //             context,
            //             "/address",
            //             arguments: {'product': product},
            //           );
            //         },
            //         child: const Text("Buy Now"),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
