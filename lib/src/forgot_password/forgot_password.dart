import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundrylane/widgets/progress_button.dart';
import 'package:tabler_icons/tabler_icons.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});
  static const String routeName = "/forgotpassword";

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormBuilderState> formState = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(250, 251, 252, 1),
      body: FormBuilder(
        key: formState,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 48),
                Center(
                  child: Container(
                    height: 80,
                    width: 80,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Color.fromRGBO(215, 224, 255, 1),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/icons/favicon.png"),

                          fit: BoxFit.fill,
                        ),
                      ),
                      height: 10,
                      width: 10,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Center(
                  child: Text(
                    "Reset Password",
                    style: GoogleFonts.almarai(
                      wordSpacing: 2.0,
                      fontSize: 32,
                      color: Color.fromRGBO(46, 73, 180, 1),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Center(
                  child: Text(
                    "Sign in to manage your laundry, track orders, and schedule pickups with ease.",
                    style: GoogleFonts.almarai(
                      fontSize: 16,
                      color: Color.fromRGBO(103, 107, 108, 1),
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 40),
                SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'email',
                  textInputAction: TextInputAction.next,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email(),
                  ]),
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: "Email address",
                    hintStyle: GoogleFonts.almarai(),
                    prefixIcon: Icon(TablerIcons.mail),
                    filled: true,
                    fillColor: Color.fromRGBO(245, 248, 254, 1),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(245, 248, 254, 1),
                        width: 1.5,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(245, 248, 254, 1),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(height: 24),
                SizedBox(height: 24),
                ProgressButton(
                  onPress: () async {
                    if (formState.currentState?.validate() == true) {
                      Map formData = formState.currentState!.value;
                      print(formData);
                    }
                  },
                  style: ButtonStyle(
                    fixedSize: WidgetStatePropertyAll(
                      Size(MediaQuery.of(context).size.width, 48),
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    backgroundColor: WidgetStatePropertyAll(
                      Color.fromRGBO(45, 111, 241, 1),
                    ),
                  ),
                  label: "Continue",
                  textStyle: GoogleFonts.almarai(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
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
