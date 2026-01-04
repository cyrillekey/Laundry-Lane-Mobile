import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart' hide Provider, Consumer;
import 'package:laundrylane/models/catalog_model.dart';
import 'package:laundrylane/models/clothing_type.dart';
import 'package:laundrylane/providers/card_provider.dart';
import 'package:laundrylane/src/apis/api_service.dart';
import 'package:laundrylane/src/checkout/checkout_page.dart';
import 'package:laundrylane/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:tabler_icons/tabler_icons.dart';
import "package:collection/collection.dart";

class CartPage extends StatefulHookConsumerWidget {
  const CartPage({super.key});
  static const routeName = '/cart';

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  final PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );
  final ScrollController controller = ScrollController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    final Catalog service =
        ModalRoute.of(context)?.settings.arguments as Catalog;
    final clothingListener = ref.watch(clothingTypeState);

    return Scaffold(
      appBar: AppBar(title: Text("${service.name}"), centerTitle: true),

      body: clothingListener.when(
        data: (clothingTypes) {
          List<String> types =
              clothingTypes.map((e) => e.type!).toSet().toList();
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                SizedBox(
                  height: 72,
                  child: ListView.separated(
                    controller: controller,
                    itemBuilder:
                        (context, index) => InkWell(
                          onTap: () {
                            pageController.jumpToPage(index);
                            setState(() {});
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                types[index],
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 2),
                              Consumer<CartProvider>(
                                builder: (context, cart, child) {
                                  int count = cart.items
                                      .where((e) => e.type == types[index])
                                      .fold(0, (a, b) => a + b.quantity);
                                  if (count > 0) {
                                    return Text(
                                      "$count items",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelSmall?.copyWith(
                                        color: Color.fromRGBO(19, 116, 234, 1),
                                      ),
                                    );
                                  }
                                  return Text(
                                    "0 items",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelSmall?.copyWith(
                                      color: Color.fromRGBO(229, 176, 163, 1),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 6),
                              if (currentPage == index)
                                Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Color.fromRGBO(19, 116, 234, 1),
                                  ),
                                ),
                            ],
                          ),
                        ),
                    separatorBuilder: (context, index) => SizedBox(width: 24),
                    itemCount: types.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                SizedBox(height: 24),

                Expanded(
                  child: PageView.builder(
                    onPageChanged: (value) {
                      setState(() {
                        currentPage = value;
                      });
                    },
                    controller: pageController,
                    itemCount: (clothingTypes.length),
                    itemBuilder: (context, index) {
                      final subtypes =
                          clothingTypes
                              .where((e) => e.type == types[index])
                              .toList();
                      return ListView.separated(
                        itemBuilder:
                            (context, index) => CartItemWidget(
                              subtype: subtypes[index],
                              index: index,
                            ),
                        separatorBuilder: (_, __) => SizedBox(height: 12),
                        itemCount: subtypes.length,
                      );
                    },
                  ),
                ),
                SizedBox(height: 64),
              ],
            ),
          );
        },
        error: (_, __) => Center(child: Text("Error")),
        loading: () => Center(child: CircularProgressIndicator.adaptive()),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<CartProvider>(
                    builder: (context, cart, child) {
                      int quantity = cart.items.fold(
                        0,
                        (a, b) => a + b.quantity,
                      );
                      return Text(
                        "$quantity items",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      );
                    },
                  ),
                  Consumer<CartProvider>(
                    builder: (context, cart, chilf) {
                      var clothListener = ref.watch(clothingTypeState).value;
                      double totalPrice =
                          service.bulk == true
                              ? (service.price ?? 0.0)
                              : cart.items.fold(
                                0,
                                (a, b) =>
                                    a +
                                    b.quantity *
                                        (clothListener
                                                ?.firstWhereOrNull(
                                                  (e) => e.id == b.productId,
                                                )
                                                ?.price ??
                                            0),
                              );
                      return Text(
                        "Total: $totalPrice Ksh",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Consumer<CartProvider>(
              builder: (context, cart, child) {
                return TextButton(
                  onPressed:
                      cart.items.isEmpty
                          ? null
                          : () {
                            Navigator.of(
                              context,
                            ).pushNamed(CheckoutPage.routeName);
                          },
                  style: ButtonStyle(
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
                      "Go To Checkout",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({super.key, required this.subtype, required this.index});

  final ClothingType subtype;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 80,
      decoration: BoxDecoration(
        color: cartColors[index % cartColors.length],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${subtype.name}",
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 2),
              Text(
                "Ksh ${subtype.price} / item",
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Color.fromRGBO(132, 137, 147, 1),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Consumer<CartProvider>(
                  builder: (context, provider, child) {
                    int? quantity =
                        provider.items
                            .firstWhereOrNull((e) => e.productId == subtype.id)
                            ?.quantity;
                    return InkWell(
                      onTap:
                          quantity == null
                              ? null
                              : () {
                                if (quantity == 0) {
                                  Provider.of<CartProvider>(
                                    context,
                                    listen: false,
                                  ).removeItem(subtype.id!);
                                }
                                if (quantity > 0) {
                                  Provider.of<CartProvider>(
                                    context,
                                    listen: false,
                                  ).editItem(subtype.id!, quantity - 1);
                                }
                              },
                      child: Icon(TablerIcons.minus),
                    );
                  },
                ),
                SizedBox(width: 12),
                Consumer<CartProvider>(
                  builder: (context, provider, child) {
                    int quantity =
                        provider.items
                            .firstWhereOrNull((e) => e.productId == subtype.id)
                            ?.quantity ??
                        0;
                    return Text(
                      "$quantity",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    );
                  },
                ),
                SizedBox(width: 12),
                Consumer<CartProvider>(
                  builder: (context, provider, child) {
                    return InkWell(
                      child: Icon(TablerIcons.plus, size: 20),
                      onTap: () {
                        int quantity =
                            provider.items
                                .firstWhereOrNull(
                                  (e) => e.productId == subtype.id,
                                )
                                ?.quantity ??
                            0;
                        if (quantity == 0) {
                          provider.addItem(
                            CartItem(
                              productId: subtype.id!,
                              quantity: 1,
                              type: subtype.type!,
                            ),
                          );
                          // add to cart provider
                        } else {
                          provider.editItem(subtype.id!, quantity + 1);
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
