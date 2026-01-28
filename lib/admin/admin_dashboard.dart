import 'package:flutter/material.dart';
import 'package:mobile/presentation/providers/admin_order_provider.dart';
import 'package:mobile/presentation/providers/auth_provider.dart';
import 'package:mobile/presentation/screens/admin_orders_screen.dart';
import 'package:provider/provider.dart';
import 'admin_products_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AdminOrderProvider>();
    final auth = context.read<AuthProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Panel"),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          actions: [
          IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  title: const Text('Confirm Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop(); // ❌ Cancel
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () async {
                        Navigator.of(dialogContext).pop(); // close dialog

                        await auth.logout(context);
                        provider.logout();

                        Navigator.of(context)
                            .pushReplacementNamed('/login');
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                );
              },
            );
          },
        ),


        ],
      ),
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
