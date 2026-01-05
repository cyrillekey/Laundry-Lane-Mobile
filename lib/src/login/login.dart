import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/experimental/mutation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:laundrylane/src/apis/mutations.dart';
import 'package:laundrylane/src/forgot_password/forgot_password.dart';
import 'package:laundrylane/src/home/home.dart';
import 'package:laundrylane/src/signup/signup.dart';
import 'package:laundrylane/widgets/password_input.dart';
import 'package:laundrylane/widgets/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tabler_icons/tabler_icons.dart';

class LoginPage extends StatefulHookConsumerWidget {
  static const String routeName = "/login";
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final GlobalKey<FormBuilderState> formState = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final watchLogin = ref.watch(loginMutation);
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
                    "Sign In",
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
                Row(
                  children: [
                    Expanded(
                      child: ProgressButton(
                        builder:
                            (isLoading, setLoadingState) => TextButton.icon(
                              style: ButtonStyle(
                                elevation: WidgetStatePropertyAll(0),
                                backgroundColor: WidgetStatePropertyAll(
                                  Theme.of(context).colorScheme.inversePrimary,
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
                                "Facebook",
                                style: GoogleFonts.almarai(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              icon: Icon(
                                TablerIcons.brand_facebook,
                                weight: 12,
                              ),
                            ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ProgressButton(
                      builder: (isLoading, setLoadingState) {
                        return Expanded(
                          child: TextButton.icon(
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                Theme.of(context).colorScheme.inversePrimary,
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
                            onPressed:
                                isLoading
                                    ? null
                                    : () async {
                                      setLoadingState(true);
                                      try {
                                        var googleUser =
                                            await GoogleSignIn.instance
                                                .authenticate();
                                        // Obtain the auth details from the request
                                        final GoogleSignInAuthentication
                                        googleAuth = googleUser.authentication;

                                        // Create a new credential
                                        final credential =
                                            GoogleAuthProvider.credential(
                                              idToken: googleAuth.idToken,
                                            );

                                        // Once signed in, return the UserCredential
                                        await FirebaseAuth.instance
                                            .signInWithCredential(credential);

                                        setLoadingState(false);
                                      } catch (e) {
                                        setLoadingState(false);
                                      }
                                    },
                            label:
                                isLoading
                                    ? CircularProgressIndicator.adaptive()
                                    : Text(
                                      "Google",
                                      style: GoogleFonts.almarai(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                            icon:
                                isLoading
                                    ? SizedBox.shrink()
                                    : Icon(TablerIcons.brand_google),
                          ),
                        );
                      },
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
                    // fillColor: Color.fromRGBO(245, 248, 254, 1),
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
                SizedBox(height: 24),
                PasswordInput(name: "password", showStrength: false),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap:
                          () => Navigator.of(
                            context,
                          ).pushNamed(ForgotPassword.routeName),
                      child: Text(
                        "Forgot password?",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          decorationStyle: TextDecorationStyle.solid,
                          decoration: TextDecoration.combine([
                            TextDecoration.underline,
                          ]),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                TextButton.icon(
                  iconAlignment: IconAlignment.start,
                  icon:
                      watchLogin is MutationPending
                          ? SizedBox(
                            height: 12,
                            width: 12,
                            child: CircularProgressIndicator.adaptive(
                              backgroundColor: Colors.white,
                            ),
                          )
                          : Icon(
                            TablerIcons.login,
                            color: Colors.white,
                            size: 26,
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
                      final response = await loginMutation.run(ref, (
                        tsx,
                      ) async {
                        final response = await login(
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

                        Navigator.of(context).pushNamedAndRemoveUntil(
                          HomePage.routeName,
                          (route) => route.isFirst,
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
                  label: Text(
                    "Sign In",
                    style: GoogleFonts.almarai(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),

                SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: InkWell(
                    onTap:
                        () => Navigator.of(
                          context,
                        ).pushNamed(SignupPage.routeName),
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.almarai(color: Colors.black),
                        children: [
                          TextSpan(text: "Dont have an account?"),
                          TextSpan(
                            text: " Sign up",
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
