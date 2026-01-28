import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../../data/models/order.dart';

class InvoicePdf {
  static Future<File> generate(Order order) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [

              /// HEADER
              pw.Text(
                "INVOICE",
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 10),

              pw.Text("Order ID: ${order.orderId}"),
              pw.Text("Date: ${order.createdAt.toString().split(' ')[0]}"),
              pw.Text("Payment: ${order.paymentType}"),

              pw.Divider(),

              /// ADDRESS
              pw.Text("Delivery Address",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text(order.address.fullName),
              pw.Text(order.address.addressLine),
              pw.Text(
                  "${order.address.city}, ${order.address.state} - ${order.address.pincode}"),
              pw.Text("Phone: ${order.address.phone}"),

              pw.SizedBox(height: 16),

              /// ITEMS TABLE
              pw.Text("Items",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),

              pw.Table.fromTextArray(
                headers: ["Product", "Qty", "Price"],
                data: order.items.map((item) {
                  return [
                    item.title,
                    item.qty.toString(),
                    "₹${item.price}",
                  ];
                }).toList(),
              ),

              pw.Divider(),

              /// TOTAL
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  "Total: ₹${order.total}",
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/invoice_${order.orderId}.pdf");
    await file.writeAsBytes(await pdf.save());

    return file;
  }
}
