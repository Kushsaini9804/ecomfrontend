import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../widgets/invoice_button.dart';

import '../../data/models/order.dart';
import '../providers/order_provider.dart';
import '../widgets/order_status_stepper.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
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
        body: Center(
          child: Text(
            "No orders yet",
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: provider.orders.length,
        itemBuilder: (context, index) {
          final Order order = provider.orders[index];

          return Card(
            margin: const EdgeInsets.all(12),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔹 HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Order #${order.orderId.substring(order.orderId.length - 6)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        formatDate(order.createdAt),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Payment: ${order.paymentType}",
                    style: const TextStyle(fontSize: 13),
                  ),

                  const SizedBox(height: 10),

                  /// 🔹 STATUS TRACKING
                  OrderStatusStepper(status: order.status),

                  const Divider(),

                  /// 🔹 ITEMS
                  ...order.items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // /// IMAGE
                          // ClipRRect(
                          //   borderRadius: BorderRadius.circular(8),
                          //   child: Image.network(
                          //     item.image ?? '',
                          //     width: 70,
                          //     height: 70,
                          //     fit: BoxFit.cover,
                          //     errorBuilder: (_, __, ___) =>
                          //         const Icon(Icons.image, size: 60),
                          //   ),
                          // ),

                          // const SizedBox(width: 12),

                          /// DETAILS
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text("Qty: ${item.qty}"),
                                Text(
                                  "₹${item.price}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                  const Divider(),

                  /// 🔹 TOTAL
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Total: ₹${order.total}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InvoiceButton(order: order),
                    ],
                  ),

                  /// 🔹 ACTION BUTTONS (REAL ECOM)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (order.status == 'Pending' ||
                          order.status == 'Confirmed')
                        TextButton(
                          onPressed: () async {
                            await context
                                .read<OrderProvider>()
                                .cancelOrder(order.orderId);
                          },
                          child: const Text(
                            "Cancel Order",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),

                      if (order.status == 'Delivered')
                        TextButton(
                          onPressed: () async {
                            await context
                                .read<OrderProvider>()
                                .requestReturn(
                                  order.orderId,
                                  "Not satisfied",
                                );
                          },
                          child: const Text("Return"),
                        ),
                    ],
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
