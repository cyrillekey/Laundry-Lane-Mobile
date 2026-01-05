import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:laundrylane/src/address/add_address.dart';
import 'package:laundrylane/src/cart/cart_page.dart';
import 'package:laundrylane/src/checkout/checkout_page.dart';
import 'package:laundrylane/src/forgot_password/forgot_password.dart';
import 'package:laundrylane/src/forgot_password/reset_otp.dart';
import 'package:laundrylane/src/forgot_password/reset_update_password.dart';
import 'package:laundrylane/src/home/home.dart';
import 'package:laundrylane/src/login/login.dart';
import 'package:laundrylane/src/notifications/notifications_view.dart';
import 'package:laundrylane/src/onboarding/onboarding_view.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:laundrylane/src/orders/order_details.dart';
import 'package:laundrylane/src/payments/add_card.dart';
import 'package:laundrylane/src/payments/payment_methods.dart';
import 'package:laundrylane/src/profile/update_profile.dart';
import 'package:laundrylane/src/request_order/service_select.dart';
import 'package:laundrylane/src/signup/signup.dart';
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

    return MaterialApp(
      navigatorKey: navigatorKey,
      initialRoute:
          token == null ? OnboardingView.routeName : HomePage.routeName,
      // theme: settingsController.themeMode == ThemeMode.light
      //     ? theme.light()
      //     : theme.dark(),

      // Providing a restorationScopeId allows the Navigator built by the
      // MaterialApp to restore the navigation stack when a user leaves and
      // returns to the app after it has been killed while running in the
      // background.
      // restorationScopeId: 'app',

      // Provide the generated AppLocalizations to the MaterialApp. This
      // allows descendant Widgets to display the correct translations
      // depending on the user's locale.
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
      theme: watchTheme == ThemeMode.light ? theme.light() : theme.dark(),
      title: "Laundry Lane",

      // Define a function to handle named routes in order to support
      // Flutter web url navigation and deep linking.
      onGenerateRoute: (RouteSettings routeSettings) {
        return MaterialPageRoute<void>(
          settings: routeSettings,
          builder: (BuildContext context) {
            switch (routeSettings.name) {
              case OnboardingView.routeName:
                return const OnboardingView();
              case HomePage.routeName:
                return HomePage();
              case NotificationsView.routeName:
                return NotificationsView();
              case ServiceSelect.routeName:
                return ServiceSelect();
              case SignupPage.routeName:
                return SignupPage();
              case LoginPage.routeName:
                return LoginPage();
              case ForgotPassword.routeName:
                return ForgotPassword();
              case OrderDetails.routeName:
                return OrderDetails();
              case AddAddressPage.routeName:
                return AddAddressPage();
              case AddCard.routeName:
                return AddCard();
              case PaymentMethods.routeName:
                return PaymentMethods();
              case CartPage.routeName:
                return CartPage();
              case CheckoutPage.routeName:
                return CheckoutPage();
              case PasswordResetOtp.routeName:
                return PasswordResetOtp();
              case ResetUpdatePassword.routeName:
                return ResetUpdatePassword();
              case UpdateProfile.routeName:
                return UpdateProfile();
              default:
                return const OnboardingView();
            }
          },
        );
      },
    );
  }
}
