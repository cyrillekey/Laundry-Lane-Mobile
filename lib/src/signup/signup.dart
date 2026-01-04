import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/experimental/mutation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:laundrylane/src/apis/mutations.dart';
import 'package:laundrylane/src/home/home.dart';
import 'package:laundrylane/src/login/login.dart';
import 'package:laundrylane/widgets/password_input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tabler_icons/tabler_icons.dart';

class SignupPage extends StatefulHookConsumerWidget {
  const SignupPage({super.key});
  static const String routeName = "/signup";

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final GlobalKey<FormBuilderState> formState = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    final watchSignup = ref.watch(signupMutation);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                    "Sign Up",
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
                    "Create an account to schedule pickups, track your laundry, and enjoy convenient, reliable cleaning.",
                    style: GoogleFonts.almarai(
                      fontSize: 16,
                      color: Color.fromRGBO(103, 107, 108, 1),
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        style: ButtonStyle(
                          elevation: WidgetStatePropertyAll(0),
                          backgroundColor: WidgetStatePropertyAll(
                            Color.fromRGBO(245, 248, 254, 1),
                          ),
                          fixedSize: WidgetStatePropertyAll(
                            Size(double.infinity, 46),
                          ),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        onPressed: () {},
                        label: Text(
                          "Facebook",
                          style: GoogleFonts.almarai(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        icon: Icon(TablerIcons.brand_facebook, weight: 12),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextButton.icon(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            Color.fromRGBO(245, 248, 254, 1),
                          ),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          fixedSize: WidgetStatePropertyAll(
                            Size(double.infinity, 46),
                          ),
                        ),
                        onPressed: () {},

                        label: Text(
                          "Google",
                          style: GoogleFonts.almarai(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        icon: Icon(TablerIcons.brand_google),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: Divider()),
                    SizedBox(width: 12),
                    Text("Or", style: GoogleFonts.almarai(fontSize: 16)),
                    SizedBox(width: 12),
                    Expanded(child: Divider()),
                  ],
                ),
                SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'name',
                  textInputAction: TextInputAction.next,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                  keyboardType: TextInputType.name,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: "Name",
                    hintStyle: GoogleFonts.almarai(),
                    prefixIcon: Icon(TablerIcons.user_circle),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(221, 223, 224, 1),
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(221, 223, 224, 1),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 18),
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(221, 223, 224, 1),
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(221, 223, 224, 1),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 18),
                PasswordInput(name: "password", showStrength: false),
                SizedBox(height: 36),
                TextButton.icon(
                  iconAlignment: IconAlignment.start,
                  icon:
                      watchSignup is MutationPending
                          ? SizedBox(
                            height: 12,
                            width: 12,
                            child: CircularProgressIndicator.adaptive(
                              backgroundColor: Colors.white,
                            ),
                          )
                          : Icon(
                            TablerIcons.logout,
                            color: Colors.white,
                            size: 24,
                          ),
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      Color.fromRGBO(45, 111, 241, 1),
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    fixedSize: WidgetStatePropertyAll(
                      Size(MediaQuery.of(context).size.width, 52),
                    ),
                  ),
                  onPressed: () async {
                    if (formState.currentState?.saveAndValidate() == true) {
                      Map values = formState.currentState!.value;
                      final response = await signupMutation.run(ref, (
                        tsx,
                      ) async {
                        final response = await signUp(
                          values['name'],
                          values['email'],
                          values['password'],
                        );
                        return response;
                      });
                      if (response.success && response.token != null) {
                        final sharedPreference =
                            await SharedPreferences.getInstance();
                        await sharedPreference.setString(
                          "token",
                          response.token!,
                        );
                        await sharedPreference.setInt("userId", response.id!);

                        Navigator.of(
                          context,
                        ).pushReplacementNamed(HomePage.routeName);
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
                  label: Text(
                    "Sign Up",
                    style: GoogleFonts.almarai(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: InkWell(
                    onTap:
                        () => Navigator.of(
                          context,
                        ).pushNamed(LoginPage.routeName),
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.almarai(color: Colors.black),
                        children: [
                          TextSpan(text: "Already have an account?"),
                          TextSpan(
                            text: " Sign in",
                            style: GoogleFonts.almarai(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
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
