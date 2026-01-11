import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../../data/models/order.dart';
import '../../core/utils/invoice_pdf.dart';

class InvoiceButton extends StatelessWidget {
  final Order order;

  const InvoiceButton({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: const Icon(Icons.picture_as_pdf),
      label: const Text("Invoice"),
      onPressed: () async {
        final file = await InvoicePdf.generate(order);
        await Printing.layoutPdf(
          onLayout: (_) => file.readAsBytesSync(),
        );
      },
    );
  }
}
