// lib/presentation/screens/product_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../providers/product_provider.dart';
import '../widgets/product_card.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final categories = ["All", "Shoes", "Clothing", "Electronics"];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
      
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();

    return Column(
      children: [
        /// 🔹 CATEGORY BAR
        SizedBox(
          height: 48,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, i) {
              final cat = categories[i];
              final selected = provider.selectedCategory == cat;

              return ChoiceChip(
                label: Text(cat),
                selected: selected,
                backgroundColor: Colors.indigo,

                onSelected: (_) {
                  provider.fetchProducts(category: cat);
                },
                selectedColor: Colors.indigo,
                labelStyle: TextStyle(
                  color: selected ? Colors.white : Colors.black,
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemCount: categories.length,
          ),
        ),

        const SizedBox(height: 8),

        /// 🔹 PRODUCT GRID
        Expanded(
          child: provider.loading
              ? _buildShimmer()
              : provider.products.isEmpty
                  ? const Center(child: Text("No products available"))
                  : RefreshIndicator(
                      onRefresh: provider.fetchProducts,
                      color: Colors.indigo,
                      child: GridView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: provider.products.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.68,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemBuilder: (_, i) =>
                            ProductCard(product: provider.products[i]),
                      ),
                    ),
        ),
      ],
    );
  }

  Widget _buildShimmer() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.62,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (_, i) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
