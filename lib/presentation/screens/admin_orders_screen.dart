import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_order_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/admin_order_card.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final token = context.read<AuthProvider>().token;
      context.read<AdminOrderProvider>().fetchAllOrders(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AdminOrderProvider>();
    final auth = context.read<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Orders"),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : provider.orders.isEmpty
              ? const Center(child: Text("No orders available"))
              : ListView.builder(
                  itemCount: provider.orders.length,
                  itemBuilder: (_, i) =>
                      AdminOrderCard(order: provider.orders[i]),
                ),
    );
  }
}
