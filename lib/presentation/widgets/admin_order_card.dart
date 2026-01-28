import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_order_provider.dart';
import '../providers/auth_provider.dart';

class AdminOrderCard extends StatelessWidget {
  final Map order;

  const AdminOrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final token = context.read<AuthProvider>().token;
    final admin = context.read<AdminOrderProvider>();

    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order ID: ${order['_id']}",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text("User: ${order['userId']?['name'] ?? 'Deleted User'}"),
            Text("Email: ${order['userId']?['email'] ?? 'N/A'}"),
            const Divider(),
            ...order['items'].map<Widget>((item) {

              return ListTile(
              leading: Image.network(
                item['productId']?['image'] ?? '',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(
                item['productId']?['title'] ?? '',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Qty: ${item['qty']}"),
                  Text(
                    "Price: ₹${item['productId']?['price'] ?? 0}",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            );

            }).toList(),

            const Divider(),
            //total amoumt
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Amount",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "₹${order['totalAmount']}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),

            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(order['status'].toString().toUpperCase()),
                  backgroundColor: _statusColor(order['status']),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) async {
                    await admin.updateOrderStatus(
                      orderId: order['_id'],
                      status: value,
                      token: token,
                    );
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'Approved', child: Text('Approve')),
                    PopupMenuItem(value: 'Shipped', child: Text('Shipped')),
                    PopupMenuItem(value: 'Delivered', child: Text('Delivered')),
                    PopupMenuItem(value: 'Cancelled', child: Text('Cancel')),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.blue.shade100;
      case 'shipped':
        return Colors.orange.shade100;
      case 'delivered':
        return Colors.green.shade100;
      case 'cancelled':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade300;
    }
  }
}
