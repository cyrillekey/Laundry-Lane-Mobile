import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/experimental/mutation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:laundrylane/models/auth_response.dart';
import 'package:laundrylane/src/apis/mutations.dart';
import 'package:laundrylane/src/home/home.dart';
import 'package:laundrylane/src/login/login.dart';
import 'package:laundrylane/utils/constants.dart';
import 'package:laundrylane/widgets/password_input.dart';
import 'package:laundrylane/widgets/progress_button.dart';
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
        child: SizedBox(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16),
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
                              onPressed: () async {
                                try {
                                  setLoadingState(true);
                                  TwitterAuthProvider authProvider =
                                      TwitterAuthProvider();
                                  UserCredential? userCredential;
                                  if (kIsWeb) {
                                    userCredential = await FirebaseAuth.instance
                                        .signInWithPopup(authProvider);
                                  } else {
                                    userCredential = await FirebaseAuth.instance
                                        .signInWithProvider(authProvider);
                                  }
                                  String? firebaseToken =
                                      await userCredential.user!.getIdToken();
                                  if (firebaseToken != null) {
                                    AuthResponse response = await socialLogin(
                                      firebaseToken,
                                    );
                                    if (response.success) {
                                      await saveToken(
                                        response.token!,
                                        response.id!,
                                      );
                                      setLoadingState(false);
                                      Navigator.of(
                                        context,
                                      ).pushNamedAndRemoveUntil(
                                        HomePage.routeName,
                                        (r) => false,
                                      );
                                    } else {
                                      setLoadingState(false);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(response.message),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  } else {
                                    setLoadingState(false);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Error! Could not login"),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }

                                  setLoadingState(false);
                                } catch (e) {
                                  setLoadingState(false);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Error! Could not login"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              label: Text(
                                "X(Twitter)",
                                style: GoogleFonts.almarai(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              icon: Icon(TablerIcons.brand_twitter, weight: 12),
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
                                        UserCredential userCredential =
                                            await FirebaseAuth.instance
                                                .signInWithCredential(
                                                  credential,
                                                );

                                        String? firebaseToken =
                                            await userCredential.user!
                                                .getIdToken();
                                        if (firebaseToken != null) {
                                          AuthResponse response =
                                              await socialLogin(firebaseToken);
                                          if (response.success) {
                                            await saveToken(
                                              response.token!,
                                              response.id!,
                                            );
                                            setLoadingState(false);
                                            Navigator.of(
                                              context,
                                            ).pushNamedAndRemoveUntil(
                                              HomePage.routeName,
                                              (r) => false,
                                            );
                                          } else {
                                            setLoadingState(false);
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(response.message),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        } else {
                                          setLoadingState(false);
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Error! Could not login",
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }

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
                SizedBox(height: 18),
                FormBuilderField<bool>(
                  name: "terms",
                  initialValue: false,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.isTrue(),
                  ]),
                  builder:
                      (field) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Checkbox.adaptive(
                                value: field.value,
                                onChanged: (value) => field.didChange(value),
                              ),
                              SizedBox(width: 2),
                              Expanded(
                                child: RichText(
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "I have read and agreed to the ",
                                      ),
                                      TextSpan(
                                        text: "Terms & Conditions",
                                        style: TextStyle(
                                          color: Color.fromRGBO(
                                            45,
                                            111,
                                            241,
                                            1,
                                          ),
                                        ),
                                      ),
                                      TextSpan(text: " and "),
                                      TextSpan(
                                        text: "Privacy Policy",
                                        style: TextStyle(
                                          color: Color.fromRGBO(
                                            45,
                                            111,
                                            241,
                                            1,
                                          ),
                                        ),
                                      ),
                                    ],
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (field.hasError) ...[
                            SizedBox(height: 6),
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(
                                field.errorText ?? "",
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(color: Colors.red, fontSize: 12),
                              ),
                            ),
                          ],
                        ],
                      ),
                ),
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
                        await saveToken(response.token!, response.id!);
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
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          TextSpan(text: "Already have an account?"),
                          TextSpan(
                            text: " Sign in",
                            style: Theme.of(
                              context,
                            ).textTheme.labelMedium?.copyWith(
                              color: Theme.of(context).primaryColor,
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
