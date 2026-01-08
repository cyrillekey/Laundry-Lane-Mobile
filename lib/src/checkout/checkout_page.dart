import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:jiffy/jiffy.dart';
import 'package:tabler_icons/tabler_icons.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});
  static const String routeName = "/checkout";

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final GlobalKey<FormBuilderState> reviewForm = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: reviewForm,
      child: Scaffold(
        appBar: AppBar(title: Text("Checkout"), centerTitle: true),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: TextButton(
          onPressed: () {
            if (reviewForm.currentState?.saveAndValidate() == true) {}
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
              "Continue",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12),
                FormBuilderField<String>(
                  name: "orderType",
                  initialValue: "Pickup",
                  validator: FormBuilderValidators.required(),
                  builder: (formBuiler) {
                    return Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => formBuiler.didChange("Pickup"),
                            child: Container(
                              height: 42,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color:
                                    formBuiler.value == "Pickup"
                                        ? Theme.of(context).primaryColor
                                        : Colors.white,
                                border: Border.all(
                                  width: 1,
                                  color: Color.fromRGBO(147, 147, 147, 1),
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(6),
                                  bottomLeft: Radius.circular(6),
                                ),
                              ),
                              child: Text(
                                "Pickup",
                                style: Theme.of(
                                  context,
                                ).textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color:
                                      formBuiler.value == "Pickup"
                                          ? Colors.white
                                          : Theme.of(
                                            context,
                                          ).textTheme.labelLarge?.color,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap:
                                () =>
                                    formBuiler.didChange("Pickup and Delivery"),
                            child: Container(
                              height: 42,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color:
                                    formBuiler.value == "Pickup and Delivery"
                                        ? Theme.of(context).primaryColor
                                        : null,
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromRGBO(147, 147, 147, 1),
                                  ),
                                  right: BorderSide(
                                    color: Color.fromRGBO(147, 147, 147, 1),
                                  ),
                                  top: BorderSide(
                                    color: Color.fromRGBO(147, 147, 147, 1),
                                  ),
                                ),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(6),
                                  bottomRight: Radius.circular(6),
                                ),
                              ),
                              child: Text(
                                "Pickup and Delivery",
                                style: Theme.of(
                                  context,
                                ).textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      formBuiler.value == "Pickup and Delivery"
                                          ? Colors.white
                                          : Theme.of(
                                            context,
                                          ).textTheme.labelLarge?.color,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 12),
                Divider(),
                SizedBox(height: 20),
                Text(
                  "Pickup Date & Time",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: FormBuilderField<DateTime>(
                        builder: (formBuilder) {
                          return InkWell(
                            onTap: () async {
                              DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(
                                  Duration(days: 30),
                                ),
                              );
                              formBuilder.didChange(date);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(width: 1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    TablerIcons.calendar,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    Jiffy.parseFromDateTime(
                                      formBuilder.value ?? DateTime.now(),
                                    ).format(pattern: "dd MMM yyyy"),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        name: "date",
                        initialValue: DateTime.now(),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: FormBuilderField<TimeOfDay>(
                        builder: (formBuilder) {
                          return InkWell(
                            onTap: () async {
                              TimeOfDay? date = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              formBuilder.didChange(date);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(width: 1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    TablerIcons.clock,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "${formBuilder.value?.hourOfPeriod}:${formBuilder.value?.minute} ${formBuilder.value?.period.name.toUpperCase()}",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        name: "time",
                        initialValue: TimeOfDay.now(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 26),
                Text(
                  "Delivery Days",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                SizedBox(height: 6),
                FormBuilderField<String?>(
                  builder: (formBuiler) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ServiceDay(
                              title: "Regular",
                              days: "(2-3) days",
                              price: "No extra fee",
                              formBuilderState: formBuiler,
                            ),
                            SizedBox(width: 8),
                            ServiceDay(
                              formBuilderState: formBuiler,
                              title: "Express",
                              days: "(1 day)",
                              price: "Exta Ksh 100 ",
                            ),
                            SizedBox(width: 8),
                            ServiceDay(
                              formBuilderState: formBuiler,
                              title: "Same Day",
                              days: "(8 hours)",
                              price: "Extra Ksh 200",
                            ),
                          ],
                        ),
                        if (formBuiler.hasError) ...[
                          SizedBox(height: 12),
                          Text(
                            formBuiler.errorText ?? "",
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ],
                      ],
                    );
                  },
                  name: "serviceDays",
                  validator: FormBuilderValidators.required(),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                SizedBox(height: 26),
                Text(
                  "Select Washing Preference",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                SizedBox(height: 12),
                FormBuilderField<String?>(
                  builder: (formBuilder) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WashItem(
                          formBuilder: formBuilder,
                          name: "mixed",
                          title: "Mixed Wash",
                          description:
                              "Light and heavy clothes will be washed togethor.",
                          icon: "assets/svgs/multiple-wash.svg",
                        ),
                        SizedBox(height: 2),
                        WashItem(
                          name: "separate",
                          formBuilder: formBuilder,
                          title: "Separate Wash",
                          description:
                              "Light and heavy clothes will be washed separately.",
                          icon: "assets/svgs/separate-wash.svg",
                        ),
                        if (formBuilder.hasError) ...[
                          SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              formBuilder.errorText!,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                  name: "washType",
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: FormBuilderValidators.required(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ServiceDay extends StatelessWidget {
  const ServiceDay({
    super.key,
    required this.title,
    required this.days,
    required this.price,
    required this.formBuilderState,
  });
  final FormFieldState<String?> formBuilderState;
  final String title;
  final String days;
  final String price;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => formBuilderState.didChange(title),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color:
                formBuilderState.value == title
                    ? Theme.of(context).primaryColor
                    : Color.fromRGBO(246, 246, 246, 1),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color:
                      formBuilderState.value == title
                          ? Colors.white
                          : Colors.black,
                ),
              ),
              SizedBox(height: 2),
              Text(
                days,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color:
                      formBuilderState.value == title
                          ? Colors.white
                          : Color.fromRGBO(132, 137, 147, 1),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2),
              Text(
                price,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color:
                      formBuilderState.value == title
                          ? Colors.white
                          : Color.fromRGBO(132, 137, 147, 1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WashItem extends StatelessWidget {
  const WashItem({
    super.key,
    required this.formBuilder,
    required this.name,
    required this.title,
    required this.description,
    required this.icon,
  });
  final FormFieldState<String?> formBuilder;
  final String name;
  final String title;
  final String description;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => formBuilder.didChange(name),
      child: Card.outlined(
        shape:
            formBuilder.value == name
                ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    width: 1.5,
                    color: Theme.of(context).primaryColor,
                  ),
                )
                : Theme.of(context).cardTheme.shape,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              SvgPicture.asset(icon, height: 36),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Color.fromRGBO(132, 137, 147, 1),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 4),
              Icon(
                formBuilder.value == name
                    ? TablerIcons.circle_dot_filled
                    : TablerIcons.circle,
                color:
                    formBuilder.value == name
                        ? Theme.of(context).primaryColor
                        : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
