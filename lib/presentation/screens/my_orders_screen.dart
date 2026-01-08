import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/order_provider.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {

  String formatDate(String? date) {
    if (date == null) return '-';
    return DateFormat('dd MMM yyyy').format(DateTime.parse(date));
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<OrderProvider>().fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderProvider>();

    if (provider.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.orders.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No orders yet")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: ListView.builder(
        itemCount: provider.orders.length,
        itemBuilder: (context, index) {
          final order = provider.orders[index];
          final List items = order['items'] ?? [];

          return Card(
            margin: const EdgeInsets.all(12),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// ORDER HEADER
                  Text(
                    "Order ID: ${order['orderId']}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text("Ordered on: ${formatDate(order['createdAt'])}"),
                  // Text(
                  //   "Status: ${order['status']}",
                  //   style: const TextStyle(color: Colors.green),
                  // ),
                  
                  const Divider(),

                  /// ORDER ITEMS
                  ...items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          /// ✅ PRODUCT IMAGE
                          // ClipRRect(
                          //   borderRadius: BorderRadius.circular(8),
                          //   child: Image.network(
                          //     item['image'] ?? '',
                          //     width: 60,
                          //     height: 60,
                          //     fit: BoxFit.cover,
                          //     loadingBuilder: (context, child, progress) {
                          //       if (progress == null) return child;
                          //       return const SizedBox(
                          //         width: 60,
                          //         height: 60,
                          //         child: Center(
                          //           child: CircularProgressIndicator(strokeWidth: 2),
                          //         ),
                          //       );
                          //     },
                          //     errorBuilder: (_, __, ___) =>
                          //         const Icon(Icons.image, size: 60),
                          //   ),
                          // ),

                          // const SizedBox(width: 12),

                          /// PRODUCT DETAILS
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title'] ?? 'Product',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text("Qty: ${item['qty']}"),
                                Text("Price: ₹${item['price']}"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                  const Divider(),

                  /// TOTAL AMOUNT
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Total: ₹${order['total']}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
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
