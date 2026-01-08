import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:laundrylane/models/default_response.dart';
import 'package:laundrylane/src/apis/api_service.dart';
import 'package:laundrylane/src/apis/mutations.dart';
import 'package:laundrylane/widgets/progress_button.dart';
import 'package:paystack_flutter_sdk/paystack_flutter_sdk.dart';
import 'package:tabler_icons/tabler_icons.dart';

class AddCard extends StatefulHookConsumerWidget {
  const AddCard({super.key});
  static const routeName = '/add-card';

  @override
  ConsumerState<AddCard> createState() => _AddCardState();
}

class _AddCardState extends ConsumerState<AddCard> {
  final GlobalKey<FormBuilderState> formState = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Card"),
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: FormBuilder(
        key: formState,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 32),
              InkWell(
                onTap: () {},
                child: DottedBorder(
                  options: RoundedRectDottedBorderOptions(
                    radius: Radius.circular(8),
                    color: Color.fromRGBO(95, 90, 142, 1),
                  ),

                  child: Container(
                    height: 76,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(241, 241, 250, 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(TablerIcons.scan),
                        SizedBox(width: 10),
                        Text(
                          "Scan your card",
                          style: GoogleFonts.almarai(
                            color: Color.fromRGBO(95, 90, 142, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32),
              Row(
                children: [
                  Expanded(child: Divider()),
                  SizedBox(width: 12),
                  Text(
                    "OR",
                    style: GoogleFonts.almarai(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(134, 135, 139, 1),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(child: Divider()),
                ],
              ),
              SizedBox(height: 24),
              Text(
                "Enter your cards details",
                style: GoogleFonts.almarai(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 24),
              Text(
                "Card number",
                style: GoogleFonts.almarai(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Container(
                alignment: Alignment.center,
                height: 50,
                child: FormBuilderTextField(
                  name: "card_number",
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.creditCard(),
                  ]),
                  valueTransformer:
                      (value) => value.toString().replaceAll(" ", ""),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    prefixIcon: Icon(TablerIcons.brand_mastercard),
                    errorStyle: TextStyle(fontSize: 0.01),
                    hintText: "Card Number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(226, 226, 226, 1),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Expiry Date", style: GoogleFonts.almarai()),
                        SizedBox(height: 8),
                        Container(
                          height: 50,
                          alignment: Alignment.center,
                          child: FormBuilderTextField(
                            name: "expiry_date",
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.creditCardExpirationDate(),
                            ]),
                            decoration: InputDecoration(
                              errorStyle: TextStyle(fontSize: 0.01),
                              hintText: "MM/YY",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(226, 226, 226, 1),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("CVV", style: GoogleFonts.almarai()),
                        SizedBox(height: 8),
                        Container(
                          height: 50,
                          alignment: Alignment.center,
                          child: FormBuilderTextField(
                            name: "cvv",
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.creditCardCVC(),
                            ]),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "3 digit pin",
                              errorStyle: TextStyle(fontSize: 0.01),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(226, 226, 226, 1),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text("Card Holder", style: GoogleFonts.almarai()),
              SizedBox(height: 8),
              Container(
                height: 50,
                alignment: Alignment.center,
                child: FormBuilderTextField(
                  name: "name",
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: "Enter your name",
                    errorStyle: TextStyle(fontSize: 0.01),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(226, 226, 226, 1),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              FormBuilderField<bool>(
                builder: (builder) {
                  return Row(
                    children: [
                      Checkbox.adaptive(
                        value: builder.value ?? false,
                        onChanged: (value) => builder.didChange(value),
                      ),
                      Text(
                        "Save credit card information",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  );
                },
                name: "save_creditcard",
              ),
              FormBuilderField<bool>(
                validator: FormBuilderValidators.isTrue(),
                builder: (builder) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox.adaptive(
                            value: builder.value ?? false,
                            onChanged: (value) => builder.didChange(value),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.labelLarge,
                                children: [
                                  TextSpan(
                                    text:
                                        "I have read carefully and agreed to the ",
                                  ),
                                  TextSpan(
                                    text: "Terms & Conditions",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelLarge?.copyWith(
                                      color: Color.fromRGBO(6, 11, 156, 1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (builder.hasError) ...[
                        SizedBox(height: 12),
                        Text(
                          builder.errorText!,
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ],
                  );
                },
                name: "terms",
              ),
              SizedBox(height: 12),
              ProgressButton(
                onPress: () async {
                  if (formState.currentState!.saveAndValidate()) {
                    Map values = formState.currentState!.value;
                    AddCardResponse response = await addUserCard(
                      cardNumber: values['card_number'],
                      cvv: values['cvv'],
                      expiry: values['expiry_date'],
                      holderName: values['name'],
                      isDefault: values['save_creditcard'] == true,
                    );
                    if (response.success == true) {
                      var paystack = Paystack();
                      await paystack.initialize(response.publickey!, false);
                      await paystack.launch(response.accessToken!);
                      ref.invalidate(cardsState);
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(response.message),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                style: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                  backgroundColor: WidgetStatePropertyAll(
                    Color.fromRGBO(6, 11, 156, 1),
                  ),
                  fixedSize: WidgetStatePropertyAll(
                    Size(MediaQuery.of(context).size.width, 46),
                  ),
                ),
                label: "Save",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
