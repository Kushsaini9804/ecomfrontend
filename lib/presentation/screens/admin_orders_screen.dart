import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_order_provider.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  final statuses = [
    'Pending',
    'Confirmed',
    'Shipped',
    'Delivered',
    'Cancelled'
  ];

  @override
  void initState() {
    super.initState();
    context.read<AdminOrderProvider>().fetchAllOrders();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AdminOrderProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Admin Orders')),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: provider.orders.length,
              itemBuilder: (_, i) {
                final order = provider.orders[i];

                return Card(
                  margin: const EdgeInsets.all(12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Order ID: ${order['_id']}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("User: ${order['userId']['email']}"),
                        Text("Total: ₹${order['total']}"),

                        const SizedBox(height: 8),

                        DropdownButton<String>(
                          value: order['status'],
                          isExpanded: true,
                          items: statuses
                              .map((s) => DropdownMenuItem(
                                    value: s,
                                    child: Text(s),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            provider.updateStatus(order['_id'], value!);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
