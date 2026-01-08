import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/product.dart';
import '../providers/product_provider.dart';

class ProductSearchDelegate extends SearchDelegate<Product?> {
  @override
  String get searchFieldLabel => 'Search products';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final provider = context.read<ProductProvider>();
    final results = provider.search(query);

    if (results.isEmpty) {
      return const Center(child: Text("No products found"));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final product = results[index];

        return ListTile(
          leading: product.image != null
              ? Image.network(product.image!, width: 50)
              : const Icon(Icons.image),
          title: Text(product.title),
          subtitle: Text("₹${product.price}"),
          onTap: () {
            close(context, product);
            Navigator.pushNamed(
              context,
              '/product-details',
              arguments: product,
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text("Search for products"));
    }

    final provider = context.read<ProductProvider>();
    final suggestions = provider.search(query).take(5).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final product = suggestions[index];

        return ListTile(
          title: Text(product.title),
          onTap: () {
            query = product.title;
            showResults(context);
          },
        );
      },
    );
  }
}
