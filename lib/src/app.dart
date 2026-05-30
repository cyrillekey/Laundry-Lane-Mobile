import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:laundrylane/models/user_model.dart';
import 'package:laundrylane/src/address/add_address.dart';
import 'package:laundrylane/src/address/address_list.dart';
import 'package:laundrylane/src/cart/cart_page.dart';
import 'package:laundrylane/src/checkout/checkout_page.dart';
import 'package:laundrylane/src/checkout/checkout_review.dart';
import 'package:laundrylane/src/forgot_password/forgot_password.dart';
import 'package:laundrylane/src/forgot_password/reset_otp.dart';
import 'package:laundrylane/src/forgot_password/reset_update_password.dart';
import 'package:laundrylane/src/home/home.dart';
import 'package:laundrylane/src/login/login.dart';
import 'package:laundrylane/src/notifications/notification_settings.dart';
import 'package:laundrylane/src/notifications/notifications_view.dart';
import 'package:laundrylane/src/onboarding/onboarding_view.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:laundrylane/src/orders/order_details.dart';
import 'package:laundrylane/src/payments/add_card.dart';
import 'package:laundrylane/src/payments/payment_methods.dart';
import 'package:laundrylane/src/profile/help_center.dart';
import 'package:laundrylane/src/profile/update_password.dart';
import 'package:laundrylane/src/profile/update_profile.dart';
import 'package:laundrylane/src/request_order/service_select.dart';
import 'package:laundrylane/src/signup/email_verify.dart';
import 'package:laundrylane/src/signup/signup.dart';
import 'package:laundrylane/src/stores/store_select.dart';
import 'package:laundrylane/theme/theme.dart';
import 'package:laundrylane/theme/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The Widget that configures your application.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends ConsumerWidget {
  const MyApp({super.key, required this.sharedPreferences});

  final SharedPreferences sharedPreferences;
  @override
  Widget build(BuildContext context, ref) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    String? token = (sharedPreferences.getString("token"));
    bool onboarded = (sharedPreferences.getBool("onboarded") == true);
    bool isThemeSet = sharedPreferences.getBool("isDark") != null;
    // Retrieves the default theme for the platform
    //TextTheme textTheme = Theme.of(context).textTheme;

    // Use with Google Fonts package to use downloadable fonts
    TextTheme textTheme = createTextTheme(
      context,
      "Noto Sans Hanunoo",
      "Open Sans Condensed",
    );

    MaterialTheme theme = MaterialTheme(textTheme);
    final watchTheme = ref.watch(themeProvider).value;
    // final storeId = sharedPreferences.get("store");
    final userString = sharedPreferences.getString('user');
    final user =
        userString == null ? null : UserModel.fromJson(jsonDecode(userString));

    return MaterialApp(
      navigatorKey: navigatorKey,
      initialRoute:
          onboarded == false
              ? OnboardingView.routeName
              : token == null
              ? LoginPage.routeName
              : user?.isVerified == false || user?.isVerified == null
              ? EmailVerifyPage.routeName
              : StoreSelectPage.routeName,

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
      ],

      // Use AppLocalizations to configure the correct application title
      // depending on the user's locale.
      //
      // The appTitle is defined in .arb files found in the localization
      // directory.
      onGenerateTitle: (BuildContext context) => "Laundry Lane",

      // Define a light and dark color theme. Then, read the user's
      // preferred ThemeMode (light, dark, or system default) from the
      // SettingsController to display the correct theme.
      themeMode: watchTheme,
      theme:
          isThemeSet == false
              ? MediaQuery.of(context).platformBrightness == Brightness.dark
                  ? theme.dark()
                  : theme.light()
              : watchTheme == ThemeMode.light
              ? theme.light()
              : theme.dark(),
      title: "Laundry Lane",
      routes: {
        OnboardingView.routeName: (context) => const OnboardingView(),
        HomePage.routeName: (context) => HomePage(),
        NotificationsView.routeName: (context) => const NotificationsView(),
        ServiceSelect.routeName: (context) => const ServiceSelect(),
        SignupPage.routeName: (context) => const SignupPage(),
        LoginPage.routeName: (context) => const LoginPage(),
        ForgotPassword.routeName: (context) => const ForgotPassword(),
        OrderDetails.routeName: (context) => const OrderDetails(),
        AddAddressPage.routeName: (context) => const AddAddressPage(),
        AddCard.routeName: (context) => const AddCard(),
        PaymentMethods.routeName: (context) => const PaymentMethods(),
        CartPage.routeName: (context) => const CartPage(),
        CheckoutPage.routeName: (context) => const CheckoutPage(),
        PasswordResetOtp.routeName: (context) => const PasswordResetOtp(),
        ResetUpdatePassword.routeName: (context) => const ResetUpdatePassword(),
        UpdateProfile.routeName: (context) => const UpdateProfile(),
        UpdatePassword.routeName: (context) => const UpdatePassword(),
        CheckoutReview.routeName: (context) => const CheckoutReview(),
        HelpCenter.routeName: (context) => const HelpCenter(),
        AddressList.routeName: (context) => const AddressList(),
        NotificationSettings.routeName:
            (context) => const NotificationSettings(),
        StoreSelectPage.routeName: (context) => const StoreSelectPage(),
        EmailVerifyPage.routeName: (context) => const EmailVerifyPage(),
      },

      // Define a function to handle named routes in order to support
      // Flutter web url navigation and deep linking.
    );
  }
}
