import 'package:flutter/material.dart';

class MakePayment extends StatelessWidget {
  const MakePayment({super.key});
  static const routeName = '/make-payment';
  @override
  Widget build(BuildContext context) {
    // int id = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(title: const Text("Make Payment")),
      body: const Center(child: Text("Make Payment")),
      bottomSheet: Container(),
    );
  }
}
