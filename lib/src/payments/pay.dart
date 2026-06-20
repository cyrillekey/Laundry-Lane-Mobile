import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:laundrylane/models/billing_address.dart';
import 'package:laundrylane/models/default_response.dart';
import 'package:laundrylane/models/payment_card.dart';
import 'package:laundrylane/providers/token_provider.dart';
import 'package:laundrylane/src/apis/api_service.dart';
import 'package:laundrylane/src/apis/mutations.dart';
import 'package:laundrylane/src/payments/widgets/payment_loading.dart';
import 'package:laundrylane/utils/constants.dart';
import 'package:laundrylane/utils/extenstions.dart';
import 'package:laundrylane/widgets/progress_button.dart';

class MakePayment extends ConsumerWidget {
  const MakePayment({super.key});
  static const routeName = '/make-payment';
  @override
  Widget build(BuildContext context, ref) {
    int id = ModalRoute.of(context)!.settings.arguments as int;
    final watchorderDetails = ref.watch(orderDetailsState(id));
    return PopScope(
      child: Scaffold(
        appBar: AppBar(title: const Text("Complete Payment")),
        body: watchorderDetails.when(
          data: (order) {
            if (order == null) {
              return const Center(child: Text("Order not found"));
            }
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 48),
                  Text("Total Amount"),
                  SizedBox(height: 12),
                  Text(
                    NumberFormat.currency(
                      decimalDigits: 2,
                      locale: "en_US",
                      name: "KES",
                    ).format(order.order.total),
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        TablerIcons.lock,
                        size: 20,
                        color: Color.fromRGBO(58, 154, 135, 1),
                      ),
                      SizedBox(width: 4),
                      Text(
                        "Secure Payment",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).unselectedWidgetColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          loading:
              () => const Center(child: CircularProgressIndicator.adaptive()),
          error: (error, stackTrace) => Center(child: Text(error.toString())),
        ),
        bottomSheet: PaymentSheet(),
      ),
    );
  }
}

class PaymentSheet extends ConsumerWidget {
  const PaymentSheet({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final watchBillingAddress = ref.watch(billingAddressState);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: watchBillingAddress.when(
        data: (address) {
          if (address == null) {
            return BilingAddressSheet();
          }
          return MakePaymentSheet(address: address);
        },
        loading:
            () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
      ),
    );
  }
}

class BilingAddressSheet extends StatefulHookConsumerWidget {
  const BilingAddressSheet({super.key});

  @override
  ConsumerState<BilingAddressSheet> createState() => BilingAddressSheetState();
}

class BilingAddressSheetState extends ConsumerState<BilingAddressSheet> {
  FocusNode contactFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider).value;
    return FormBuilder(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: {
        "email": user?.email,
        "phone": user?.phone,
        "name": user?.name,
      },
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 18),
          Text(
            "Customer Information",
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color:
                    contactFocus.hasFocus == true
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).disabledColor,
              ),
            ),
            child: Column(
              children: [
                FormBuilderTextField(
                  name: "email",
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.email(),
                    FormBuilderValidators.required(),
                  ]),
                  focusNode: contactFocus,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration.collapsed(hintText: "Email"),
                ),
                SizedBox(height: 6),
                Divider(),
                SizedBox(height: 6),
                FormBuilderTextField(
                  name: "phone",
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration.collapsed(
                    hintText: "Phone Number",
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 18),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    addressFocus.hasFocus == true
                        ? Theme.of(context).colorScheme.outline
                        : Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: Column(
              children: [
                FormBuilderTextField(
                  name: "name",
                  validator: FormBuilderValidators.required(),
                  focusNode: addressFocus,
                  decoration: InputDecoration.collapsed(hintText: "Full Name"),
                ),
                SizedBox(height: 8),
                Divider(),
                SizedBox(height: 8),
                FormBuilderDropdown<String>(
                  name: "country",
                  validator: FormBuilderValidators.required(),
                  isDense: true,
                  style: Theme.of(context).textTheme.bodyLarge,
                  items:
                      countriesWithFlag
                          .map(
                            (country) => DropdownMenuItem(
                              value: country["country"],
                              child: Text(
                                "${country["flag"]} ${country["country"]}",
                              ),
                            ),
                          )
                          .toList(),
                  decoration: InputDecoration.collapsed(hintText: "Country"),
                ),
                SizedBox(height: 6),
                Divider(),
                SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: FormBuilderTextField(
                        name: "city",
                        validator: FormBuilderValidators.required(),
                        decoration: InputDecoration.collapsed(hintText: "City"),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: FormBuilderTextField(
                        name: "postalCode",
                        validator: FormBuilderValidators.required(),
                        decoration: InputDecoration.collapsed(
                          hintText: "Postal Code",
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Divider(),
                SizedBox(height: 6),
                FormBuilderTextField(
                  name: "street",
                  validator: FormBuilderValidators.required(),
                  decoration: InputDecoration.collapsed(
                    hintText: "Street Address",
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          SafeArea(
            child: ProgressButton(
              label: "Continue",
              onPress: () async {
                if (formKey.currentState?.saveAndValidate() == true) {
                  final formData = formKey.currentState?.value;
                  DefaultResponse response = await createBillingAddress(
                    formData!["email"],
                    formData['name'],
                    formData['street'],
                    formData['city'],
                    formData['city'],
                    formData['postalCode'],
                    formData['country'],
                    formData['phone'],
                    formData['taxId'],
                  );
                  if (response.success == true) {
                    ref.invalidate(billingAddressState);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(response.message),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(response.message),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                      );
                    }
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MakePaymentSheet extends StatefulWidget {
  const MakePaymentSheet({super.key, required this.address});
  final BillingAddress address;

  @override
  State<MakePaymentSheet> createState() => _MakePaymentSheetState();
}

class _MakePaymentSheetState extends State<MakePaymentSheet> {
  String? paymentMethod;
  final formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.address.recipientName,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "${widget.address.street ?? "N/A"}, ${widget.address.city}, ${widget.address.country}",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "${widget.address.email}, ${widget.address.phone ?? "N/A"}",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                InkWell(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                    child: Text(
                      "Edit",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              "Payment Method",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12),
            FormBuilderField(
              name: "paymentMethod",
              validator: FormBuilderValidators.required(
                errorText: "Please select payment method",
              ),
              builder: (formField) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        PaymentItem(
                          title: "Card",
                          id: "CARD",
                          icon: TablerIcons.credit_card_pay,
                          selected: paymentMethod == "CARD",
                          onPress: (id) {
                            setState(() => paymentMethod = id);
                            formField.didChange(id);
                          },
                        ),
                        SizedBox(width: 18),
                        PaymentItem(
                          icon: Icons.phone_android_rounded,
                          title: "Mobile Money",
                          id: "MOBILE",
                          selected: paymentMethod == "MOBILE",
                          onPress: (id) {
                            setState(() => paymentMethod = id);
                            formField.didChange(id);
                          },
                        ),
                      ],
                    ),
                    if (formField.hasError) ...[
                      SizedBox(height: 10),
                      Text(
                        formField.errorText!,
                        style: Theme.of(
                          context,
                        ).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
            SizedBox(height: 16),
            if (paymentMethod == "CARD") _CardPaymentForm(),
            if (paymentMethod == "MOBILE") _MobilePaymentForm(),
            SizedBox(height: 16),
            SafeArea(
              child: ProgressButton(
                onPress: () async {
                  if (formKey.currentState?.saveAndValidate() == true) {
                    final formData = formKey.currentState?.value;
                    int orderId =
                        ModalRoute.of(context)!.settings.arguments as int;
                    showModalBottomSheet(
                      context: context,
                      showDragHandle: true,
                      isScrollControlled: true,
                      isDismissible: false,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      builder:
                          (context) => CompletePaymentModal(
                            orderId: orderId,
                            phone: formData?['phone'],
                            cardId: formData?['cardId'],
                            paymentMethod: formData?['paymentMethod'],
                          ),
                    );
                  }
                },
                label: "Continue",
                size: Size(MediaQuery.of(context).size.width, 52),
              ),
            ),
            SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}

class PaymentItem extends StatelessWidget {
  const PaymentItem({
    super.key,
    required this.title,
    required this.selected,
    required this.onPress,
    required this.id,
    required this.icon,
  });
  final String id;
  final String title;
  final bool selected;
  final IconData icon;
  final void Function(String id) onPress;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onPress(id),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color:
                    selected == true
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 6),
                  Icon(
                    icon,
                    size: 24,
                    color:
                        selected == true
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurface,
                  ),
                  SizedBox(height: 12),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color:
                          selected == true
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 6),
                ],
              ),
            ),
            if (selected)
              Positioned(
                top: 12,
                right: 16,
                child: Icon(
                  TablerIcons.circle_check,
                  color:
                      selected == true
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurface,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MobilePaymentForm extends StatelessWidget {
  const _MobilePaymentForm();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          FormBuilderTextField(
            name: "phone",
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                errorText: "Please enter phone number",
              ),
              FormBuilderValidators.phoneNumber(
                regex: RegExp(r"^\d{9,10}[0-9]$"),
              ),
            ]),
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              hintText: "0712345678",
            ),
          ),
        ],
      ),
    );
  }
}

class _CardPaymentForm extends ConsumerWidget {
  const _CardPaymentForm();

  @override
  Widget build(BuildContext context, ref) {
    final watchCard = ref.watch(cardsState);
    return watchCard.when(
      data: (cards) {
        return FormBuilderField<int?>(
          name: "cardId",
          builder: (formField) {
            return RadioGroup<int?>(
              groupValue: formField.value,
              onChanged: (value) => formField.didChange(value),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: cards.length,
                separatorBuilder: (context, index) => SizedBox(height: 12),
                itemBuilder:
                    (context, index) => CardItem(
                      card: cards[index],
                      selected: formField.value == cards[index].id,
                      onPress: (id) => formField.didChange(id),
                    ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (error, stackTrace) => Center(child: Text(error.toString())),
    );
  }
}

class CardItem extends StatelessWidget {
  const CardItem({
    super.key,
    required this.card,
    required this.selected,
    required this.onPress,
  });
  final PaymentCard card;
  final bool selected;
  final void Function(int id) onPress;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => onPress(card.id!),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow:
              selected == true
                  ? [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary,
                      blurRadius: 2,
                      blurStyle: BlurStyle.outer,
                    ),
                  ]
                  : null,
          border: Border.all(
            color:
                selected == true
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).highlightColor,
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).highlightColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(
                card.brand == "visa"
                    ? "assets/icons/visa.png"
                    : "assets/icons/mastercard.png",
                height: 30,
                fit: BoxFit.fitHeight,
                width: 36,
              ),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      card.brand?.capitalize() ?? "N/A",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      "** ${card.number}",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2),
                Text(
                  "Expires ${card.expiryDate}",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).unselectedWidgetColor,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            Spacer(),
            Icon(
              selected != true
                  ? TablerIcons.circle
                  : TablerIcons.circle_dot_filled,
              color:
                  selected == true
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
            ),
            // Radio(value: card.id),
          ],
        ),
      ),
    );
  }
}
