import 'package:flutter/material.dart';

class CheckoutReview extends StatefulWidget {
  const CheckoutReview({super.key});
  static const routeName = '/checkout-review';
  @override
  State<CheckoutReview> createState() => _CheckoutReviewState();
}

class _CheckoutReviewState extends State<CheckoutReview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Review"), centerTitle: true),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(child: Column(children: [])),
      ),
      bottomSheet: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20),
              TextButton(
                onPressed: () {},
                style: ButtonStyle(
                  fixedSize: WidgetStatePropertyAll(
                    Size(MediaQuery.of(context).size.width * 0.8, 50),
                  ),
                  backgroundColor: WidgetStatePropertyAll(
                    Color.fromRGBO(121, 20, 199, 1),
                  ),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "Place Order",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
