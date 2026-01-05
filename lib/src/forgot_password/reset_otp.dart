import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundrylane/models/default_response.dart';
import 'package:laundrylane/src/apis/mutations.dart';
import 'package:laundrylane/src/forgot_password/reset_update_password.dart';
import 'package:laundrylane/widgets/progress_button.dart';
import 'package:pinput/pinput.dart';

class PasswordResetOtp extends StatefulWidget {
  const PasswordResetOtp({super.key});
  static const String routeName = "/passwordresetotp";

  @override
  State<PasswordResetOtp> createState() => _PasswordResetOtpState();
}

class _PasswordResetOtpState extends State<PasswordResetOtp> {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  bool canReset = false;
  Timer? timer;
  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timer.tick == 60) {
        timer.cancel();
        setState(() {
          canReset = true;
        });
      } else {
        setState(() {});
      }
    });
    if (mounted) {
      setState(() {
        canReset = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(250, 251, 252, 1),
      body: FormBuilder(
        key: formKey,
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
                      height: 10,
                      width: 10,
                      alignment: Alignment.center,
                      child: SvgPicture.asset("assets/svgs/email.svg"),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Center(
                  child: Text(
                    "Enter OTP",
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
                    "Enter the otp we just sent to your registered email/phone number",
                    style: GoogleFonts.almarai(
                      fontSize: 16,
                      color: Color.fromRGBO(103, 107, 108, 1),
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 56),
                FormBuilderField<String>(
                  name: "otp",
                  builder:
                      (field) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Pinput(
                            length: 6,
                            onChanged: (value) => field.didChange(value),
                            enableIMEPersonalizedLearning: true,
                            forceErrorState: field.hasError,
                            keyboardType: TextInputType.number,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.equalLength(6),
                            ]),
                            errorPinTheme: PinTheme(
                              width: 56,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                border: Border.all(color: Colors.red),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                            ),

                            onSubmitted: (value) => field.didChange(value),
                            onCompleted: (value) => field.didChange(value),
                          ),
                        ],
                      ),
                  autovalidateMode: AutovalidateMode.onUnfocus,

                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.equalLength(6),
                  ]),
                ),

                SizedBox(height: 16),
                SizedBox(height: 24),
                SizedBox(height: 24),
                ProgressButton(
                  onPress: () async {
                    if (formKey.currentState?.saveAndValidate() == true) {
                      Map formData = formKey.currentState!.value;
                      DefaultResponse response = await verifyOTP(
                        ModalRoute.of(context)?.settings.arguments as String,
                        formData["otp"],
                      );
                      if (response.success) {
                        Navigator.of(context).popAndPushNamed(
                          ResetUpdatePassword.routeName,
                          arguments: {
                            "token": response.message,
                            "email":
                                ModalRoute.of(context)?.settings.arguments
                                    as String,
                          },
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: Text(response.message),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
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
                  label: "Reset password",
                  textStyle: GoogleFonts.almarai(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 24),
                ProgressButton(
                  builder:
                      (isLoading, setLoadingState) => InkWell(
                        onTap:
                            !canReset
                                ? null
                                : () async {
                                  setLoadingState(true);
                                  String email =
                                      ModalRoute.of(context)?.settings.arguments
                                          as String;
                                  DefaultResponse response =
                                      await requestPasswordReset(email);
                                  startTimer();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      content: Text(response.message),
                                      elevation: 1,
                                      backgroundColor:
                                          response.success
                                              ? Colors.green
                                              : Colors.red,
                                    ),
                                  );
                                  setLoadingState(false);
                                },
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyMedium,
                            children: [
                              TextSpan(text: "Didn't receive the code? "),
                              WidgetSpan(child: SizedBox(width: 1)),
                              isLoading
                                  ? WidgetSpan(
                                    child: CircularProgressIndicator.adaptive(),
                                  )
                                  : TextSpan(
                                    text:
                                        canReset
                                            ? "Resend OTP"
                                            : "Resend in ${60 - (timer?.tick ?? 0)} seconds",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                            ],
                          ),
                        ),
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
