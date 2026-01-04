import 'package:flutter/material.dart';
import 'package:laundrylane/src/payments/add_card.dart';
import 'package:tabler_icons/tabler_icons.dart';

class PaymentMethods extends StatelessWidget {
  const PaymentMethods({super.key});
  static const routeName = '/payment-methods';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Payment Methods"), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            TextButton.icon(
              style: ButtonStyle(
                fixedSize: WidgetStatePropertyAll(
                  Size(MediaQuery.of(context).size.width, 50),
                ),
                backgroundColor: WidgetStatePropertyAll(
                  Color.fromRGBO(241, 241, 250, 1),
                ),
              ),
              onPressed:
                  () => Navigator.of(context).pushNamed(AddCard.routeName),
              label: Text("Add Card"),
              icon: Icon(TablerIcons.plus),
            ),
          ],
        ),
      ),
    );
  }
}
