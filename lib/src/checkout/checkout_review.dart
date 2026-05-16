import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:laundrylane/models/checkout_model.dart';
import 'package:laundrylane/src/apis/api_service.dart';
import 'package:tabler_icons/tabler_icons.dart';

class CheckoutReview extends StatefulWidget {
  const CheckoutReview({super.key});
  static const routeName = '/checkout-review';
  @override
  State<CheckoutReview> createState() => _CheckoutReviewState();
}

class _CheckoutReviewState extends State<CheckoutReview> {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    final CheckoutModel checkoutModel =
        ModalRoute.of(context)?.settings.arguments as CheckoutModel;
    return Scaffold(
      appBar: AppBar(title: Text("Review"), centerTitle: true),
      body: FormBuilder(
        key: formKey,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AddressWidget(),
                if (checkoutModel.catalog.bulk == false) ...[
                  SizedBox(height: 20),
                  Text("Choose Payment Method"),
                  SizedBox(height: 12),
                  PaymentRadio(),
                ],
              ],
            ),
          ),
        ),
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

class PaymentRadio extends StatelessWidget {
  const PaymentRadio({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map> paymentMethods = [
      {
        "name": "Online Payment",
        "value": "ONLINE_PAYMENT",
        "description":
            "Pay online using M-Pesa,Airtel money or credit/debit card",
      },
      {
        "name": "Cash on Delivery",
        "value": "CASH_ON_DELIVERY",
        "description": "Make payment after delivery of your laundry",
      },
    ];
    return FormBuilderField<String>(
      name: "payment_method",
      builder: (formBuilderState) {
        return RadioGroup<String>(
          groupValue: formBuilderState.value ?? "ONLINE_PAYMENT",
          onChanged: (value) => formBuilderState.didChange(value),
          child: Column(
            children:
                paymentMethods
                    .map(
                      (item) => [
                        RadioListTile<String>(
                          horizontalTitleGap: 8,
                          minVerticalPadding: 12,
                          tileColor:
                              formBuilderState.value == item['value']
                                  ? Theme.of(
                                    context,
                                  ).primaryColor.withValues(alpha: 0.1)
                                  : Colors.transparent,
                          titleAlignment: ListTileTitleAlignment.top,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              width:
                                  formBuilderState.value == item['value']
                                      ? 1.5
                                      : 1,
                              color:
                                  formBuilderState.value == item['value']
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).unselectedWidgetColor,
                            ),
                          ),
                          value: item['value'],
                          title: Text(
                            item['name'],
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w400),
                          ),
                          subtitle: Text(item['description']),
                        ),
                        SizedBox(height: 12),
                      ],
                    )
                    .flattened
                    .toList(),
          ),
        );
      },
    );
  }
}

class AddressWidget extends ConsumerWidget {
  const AddressWidget({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final addressListener = ref.watch(addressState);
    return addressListener.when(
      data: (address) {
        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Delivery Address",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(
                      TablerIcons.truck_delivery,
                      color: Theme.of(context).primaryColor,
                      size: 24,
                    ),
                  ],
                ),
              ),
              Divider(),
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(address?.street ?? "")],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
      loading: () {
        return CircularProgressIndicator();
      },
      error: (error, stackTrace) {
        return Text(error.toString());
      },
    );
  }
}
