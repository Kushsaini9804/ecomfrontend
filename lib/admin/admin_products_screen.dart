import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  List products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final res = await ApiService.get('/products/get-products');
    setState(() => products = res['data']);
  }

  Future<void> deleteProduct(String id) async {
    await ApiService.delete('/admin/products/$id');
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Products")),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (_, i) {
          final p = products[i];
          return ListTile(
            leading: Image.network(p['image'], width: 40),
            title: Text(p['title']),
            subtitle: Text("₹${p['price']}"),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => deleteProduct(p['_id']),
            ),
          );
        },
      ),
    );
  }
}
