import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundrylane/models/auth_response.dart';
import 'package:laundrylane/src/apis/mutations.dart';
import 'package:laundrylane/src/home/home.dart';
import 'package:laundrylane/utils/constants.dart';
import 'package:laundrylane/widgets/password_input.dart';
import 'package:laundrylane/widgets/progress_button.dart';

class ResetUpdatePassword extends StatefulWidget {
  const ResetUpdatePassword({super.key});
  static const routeName = '/reset_update_password';
  @override
  State<ResetUpdatePassword> createState() => _ResetUpdatePasswordState();
}

class _ResetUpdatePasswordState extends State<ResetUpdatePassword> {
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
                    "Update Password",
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
                    "Update your Laundry Lane account password",
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
                PasswordInput(name: "password"),
                SizedBox(height: 16),
                PasswordInput(name: "confirm_password"),
                SizedBox(height: 24),
                SizedBox(height: 24),
                ProgressButton(
                  onPress: () async {
                    if (formState.currentState?.saveAndValidate() == true) {
                      Map formData = formState.currentState!.value;

                      AuthResponse response = await updatePassword(
                        (ModalRoute.of(context)!.settings.arguments
                            as Map)["token"],
                        formData["password"],
                        formData["confirm_password"],
                      );

                      if (response.success) {
                        await saveToken(response.token!, response.id!);
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          HomePage.routeName,
                          (route) => false,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: Text(response.message),
                            elevation: 1,
                            backgroundColor:
                                response.success ? Colors.green : Colors.red,
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
