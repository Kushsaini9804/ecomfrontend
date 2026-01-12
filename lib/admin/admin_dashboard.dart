import 'package:flutter/material.dart';
import 'package:mobile/presentation/screens/admin_orders_screen.dart';
import '';
import 'admin_products_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Panel")),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _card(context, "Orders", Icons.receipt, const AdminOrdersScreen()),
          _card(context, "Products", Icons.shopping_bag, const AdminProductsScreen()),
        ],
      ),
    );
  }

  Widget _card(BuildContext context, String title, IconData icon, Widget screen) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => screen),
      ),
      child: Card(
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.indigo),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
