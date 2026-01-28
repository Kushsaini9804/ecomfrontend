import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  List orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final res = await ApiService.get('/admin/orders');
    setState(() => orders = res['orders']);
  }

  Future<void> updateStatus(String id, String status) async {
    await ApiService.patch('/admin/orders/$id/status', body: {
      "status": status
    });
    fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Orders"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,),

      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (_, i) {
          final o = orders[i];
          return Card(
            margin: const EdgeInsets.all(12),
            child: ListTile(
              title: Text("₹${o['total']} • ${o['status']}"),
              subtitle: Text(o['userId']['email']),
              trailing: DropdownButton<String>(
                value: o['status'],
                items: const [
                  DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                  DropdownMenuItem(value: 'Confirmed', child: Text('Confirmed')),
                  DropdownMenuItem(value: 'Shipped', child: Text('Shipped')),
                  DropdownMenuItem(value: 'Delivered', child: Text('Delivered')),
                ],
                onChanged: (v) => updateStatus(o['_id'], v!),
              ),
            ),
          );
        },
      ),
    );
  }
}
