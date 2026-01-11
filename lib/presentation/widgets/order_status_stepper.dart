import 'package:flutter/material.dart';

class OrderStatusStepper extends StatelessWidget {
  final String status;

  const OrderStatusStepper({super.key, required this.status});

  int get currentStep {
    switch (status) {
      case 'Placed':
        return 0;
      case 'Confirmed':
        return 1;
      case 'Shipped':
        return 2;
      case 'Out for Delivery':
        return 3;
      case 'Delivered':
        return 4;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stepper(
      physics: const NeverScrollableScrollPhysics(),
      currentStep: currentStep,
      controlsBuilder: (_, __) => const SizedBox(),
      steps: const [
        Step(title: Text("Order Placed"), content: SizedBox()),
        Step(title: Text("Confirmed"), content: SizedBox()),
        Step(title: Text("Shipped"), content: SizedBox()),
        Step(title: Text("Out for Delivery"), content: SizedBox()),
        Step(title: Text("Delivered"), content: SizedBox()),
      ],
    );
  }
}
