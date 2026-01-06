import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:laundrylane/models/payment_card.dart';
import 'package:laundrylane/src/apis/api_service.dart';
import 'package:laundrylane/src/payments/add_card.dart';
import 'package:string_extensions/string_extensions.dart';
import 'package:tabler_icons/tabler_icons.dart';

class PaymentMethods extends ConsumerWidget {
  const PaymentMethods({super.key});
  static const routeName = '/payment-methods';
  @override
  Widget build(BuildContext context, ref) {
    final cardsListener = ref.watch(cardsState);
    return Scaffold(
      appBar: AppBar(title: Text("Payment Methods"), centerTitle: true),
      body: SizedBox(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 24),
              cardsListener.when(
                data: (cards) {
                  return Column(
                    children:
                        cards
                            .map(
                              (card) => [
                                PaymentCardItem(card: card),
                                SizedBox(height: 16),
                              ],
                            )
                            .flattened
                            .toList(),
                  );
                },
                error: (_, __) => SizedBox(child: Text("Error")),
                loading: () => CircularProgressIndicator.adaptive(),
              ),
              SizedBox(height: 24),
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
                label: Text(
                  "Add New Card",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                icon: Icon(
                  TablerIcons.plus,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentCardItem extends StatelessWidget {
  const PaymentCardItem({super.key, required this.card});
  final PaymentCard card;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color.fromRGBO(71, 37, 103, 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Credit Card",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              Text(
                "**** ${card.number?.last(n: 4)}",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Text(
                card.name ?? "",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              Row(
                children: [
                  Icon(TablerIcons.brand_visa),
                  SizedBox(width: 12),
                  Text(
                    "12/23",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
