import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart' hide Consumer;
import 'package:intl/intl.dart';
import 'package:laundrylane/models/catalog_model.dart';
import 'package:laundrylane/models/checkout_model.dart';
import 'package:laundrylane/models/service_model.dart';
import 'package:laundrylane/providers/card_provider.dart';
import 'package:laundrylane/src/apis/api_service.dart';
import 'package:laundrylane/src/apis/mutations.dart';
import 'package:laundrylane/src/home/home.dart';
import 'package:laundrylane/src/notifications/service.dart';
import 'package:laundrylane/src/orders/order_details.dart';
import 'package:laundrylane/utils/helper_functions.dart';
import 'package:laundrylane/widgets/progress_button.dart';
import 'package:provider/provider.dart' show Consumer;
import 'package:shimmer/shimmer.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

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
      appBar: AppBar(title: Text("Review Order"), centerTitle: true),
      body: FormBuilder(
        key: formKey,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Subtotal(
                  catalog: checkoutModel.catalog,
                  serviceType: checkoutModel.serviceType,
                  weight: checkoutModel.weight ?? 1,
                ),
                SizedBox(height: 12),
                if (checkoutModel.orderType != OrderType.pickup) ...[
                  AddressWidget(),
                  SizedBox(height: 12),
                ],

                if (checkoutModel.catalog.bulk == false) ...[
                  SizedBox(height: 20),
                  Text("Choose Payment Method"),
                  SizedBox(height: 12),
                  PaymentRadio(),
                ],
                SizedBox(height: 12),
                FormBuilderTextField(
                  name: "instructions",
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: "Special Instructions",
                    floatingLabelAlignment: FloatingLabelAlignment.start,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(width: 1),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.12),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _OrderSubmitButton(
        checkoutModel: checkoutModel,
        formKey: formKey,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _OrderSubmitButton extends ConsumerWidget {
  const _OrderSubmitButton({
    required this.checkoutModel,
    required this.formKey,
  });
  final CheckoutModel checkoutModel;
  final GlobalKey<FormBuilderState> formKey;
  @override
  Widget build(BuildContext context, ref) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return ProgressButton(
          onPress: () async {
            if (formKey.currentState?.saveAndValidate() == true) {
              final address = ref.read(addressState).value;
              final response = await createOrderMutation(
                addressId: address!.id!,
                serviceTypeId: checkoutModel.serviceType.id,
                catalogId: checkoutModel.catalog.id!,
                type: checkoutModel.orderType.value,
                pickupDate: checkoutModel.pickupDate?.toString(),
                pickupTime: checkoutModel.pickupTime?.toString(),
                items: cart.items,
                deliveryWindow: checkoutModel.deliveryWindow,
                washType: checkoutModel.washingPreference,
                instructions: formKey.currentState?.value["instructions"],
                weight: checkoutModel.weight,
                paymentMethod: formKey.currentState?.value['payment_method'],
              );
              if (response.success) {
                if (context.mounted) {
                  ref.invalidate(ordersState);
                  ref.invalidate(ongoingOrderState);
                  ref.invalidate(notificationCountState);
                  ref.invalidate(notificationsState);
                  showModalBottomSheet(
                    context: context,
                    elevation: 1,
                    showDragHandle: true,
                    isDismissible: true,
                    builder: (context) => SuccessSheet(orderId: 1),
                  );
                }
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(response.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            }
          },
          style: ButtonStyle(
            fixedSize: WidgetStatePropertyAll(
              Size(MediaQuery.of(context).size.width * 0.8, 50),
            ),
            backgroundColor: WidgetStatePropertyAll(
              Color.fromRGBO(121, 20, 199, 1),
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            foregroundColor: WidgetStatePropertyAll(Colors.white),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "Place Order",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
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
        "value": "MOBILE",
        "description":
            "Pay online using M-Pesa,Airtel money or credit/debit card",
      },
      {
        "name": "Cash on Delivery",
        "value": "CASH",
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

class Subtotal extends ConsumerWidget {
  const Subtotal({
    super.key,
    required this.catalog,
    required this.serviceType,
    required this.weight,
  });
  final Catalog catalog;
  final num weight;
  final ServiceType serviceType;

  @override
  Widget build(BuildContext context, ref) {
    final zonesState = ref.watch(deliveryZoneState);
    final addressListener = ref.watch(addressState);
    return zonesState.when(
      data: (zones) {
        if (addressListener.isLoading == true) {
          return Shimmer.fromColors(
            baseColor: Theme.of(context).scaffoldBackgroundColor,
            highlightColor: Theme.of(context).highlightColor,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.5),
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.18,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          );
        }
        final address = addressListener.value;
        final zone = getDeliveryZone(
          zones,
          address?.latitude ?? 0,
          address?.longitude ?? 0,
        );
        return Consumer<CartProvider>(
          builder: (context, cart, child) {
            num cartTotal = cart.items.fold(
              0,
              (a, b) => a + b.quantity * b.price,
            );
            num subtotal =
                catalog.bulk == true
                    ? (catalog.price ?? 0) * weight
                    : cartTotal;
            num serviceFee = serviceType.price;

            num deliveryFee = zone?.price ?? 0;
            num total = subtotal + serviceFee;
            return Card.outlined(
              child: Column(
                children: [
                  SizedBox(height: 24),
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text(
                          "Items Subtotal:",
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        Text(
                          NumberFormat.currency(
                            symbol: "Ksh ",
                            name: "KSH",
                            decimalDigits: 2,
                          ).format(subtotal),
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text(
                          "Service Fee:",
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        Text(
                          NumberFormat.currency(
                            symbol: "Ksh ",
                            name: "KSH",
                            decimalDigits: 2,
                          ).format(serviceFee),
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text(
                          "Delivery Fee:",
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        Text(
                          NumberFormat.currency(
                            symbol: "Ksh ",
                            name: "KSH",
                            decimalDigits: 2,
                          ).format(deliveryFee),
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                  Divider(),
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Subtotal",
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Spacer(),
                        Text(
                          "Ksh ${total.toStringAsFixed(2)}",
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
      error:
          (error, stackTrace) => Shimmer.fromColors(
            baseColor: Theme.of(context).scaffoldBackgroundColor,
            highlightColor: Theme.of(context).highlightColor,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.5),
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.18,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
      loading:
          () => Shimmer.fromColors(
            baseColor: Theme.of(context).scaffoldBackgroundColor,
            highlightColor: Theme.of(context).highlightColor,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.5),
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.18,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
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
        return Card.outlined(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
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
                      size: 23,
                    ),
                  ],
                ),
              ),
              Divider(),
              SizedBox(height: 16),
              FutureBuilder(
                future: reverseGeocode(
                  LatLng(address!.latitude!, address.longitude!),
                ),
                builder: (context, asyncSnapshot) {
                  final reverseAddress = asyncSnapshot.data;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          address.recipientName ?? "",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 2),
                        Text(reverseAddress?.properties?.addressLine2 ?? ""),
                        Text(
                          "${reverseAddress?.properties?.name}",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "${reverseAddress?.properties?.city} - ${reverseAddress?.properties?.state}",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          reverseAddress?.properties?.country ?? "",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  );
                },
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

class SuccessSheet extends StatelessWidget {
  const SuccessSheet({super.key, required this.orderId});
  final int orderId;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/svgs/success.svg", height: 140, width: 140),
          SizedBox(height: 16),
          Text(
            "Your order has been placed",
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 20),
          Text(
            "Your order has been placed successfully. You will receive a notification once the order is processed and cleaning started.",
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ProgressButton(
            onPress: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamedAndRemoveUntil(
                OrderDetails.routeName,
                ModalRoute.withName(HomePage.routeName),
                arguments: orderId,
              );
            },
            child: Text(
              "View Order",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
