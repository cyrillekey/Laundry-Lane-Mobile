import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:laundrylane/models/payment_card.dart';
import 'package:laundrylane/src/apis/api_service.dart';
import 'package:laundrylane/src/apis/mutations.dart';
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
        height: MediaQuery.of(context).size.height,
        child: RefreshIndicator.adaptive(
          onRefresh: () async {
            ref.invalidate(cardsState);
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: 24),
                cardsListener.when(
                  data: (cards) {
                    if (cards.isEmpty) {
                      return Column(
                        children: [
                          SizedBox(height: 32),
                          SvgPicture.asset(
                            "assets/svgs/card-add-svgrepo-com.svg",
                            height: 80,
                          ),
                          SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "You don't have any payment methods yet",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.almarai(
                                fontSize: 17,
                                color: Color.fromRGBO(152, 152, 152, 1),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: 32),
                        ],
                      );
                    }
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
      ),
    );
  }
}

class PaymentCardItem extends ConsumerWidget {
  const PaymentCardItem({super.key, required this.card});
  final PaymentCard card;
  @override
  Widget build(BuildContext context, ref) {
    return Slidable(
      closeOnScroll: true,
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            autoClose: true,
            onPressed: (a) async {
              await deleteCard(cardId: card.id!);
              ref.invalidate(cardsState);
            },
            icon: TablerIcons.trash,
          ),
        ],
      ),
      child: Container(
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
                  "Debit Card",
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
                    Icon(
                      card.brand == "visa"
                          ? TablerIcons.brand_visa
                          : TablerIcons.brand_mastercard,
                      size: 28,
                    ),
                    SizedBox(width: 12),
                    Text(
                      "${card.expiryDate}",
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
      ),
    );
  }
}
