import 'package:flutter/material.dart';

class PaymentsList extends StatelessWidget {
  const PaymentsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24).copyWith(top: 12),
      child: Column(
        children: [
          SizedBox(height: 18),
          Text(
            "Payments",
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}
