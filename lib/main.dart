import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:laundrylane/providers/card_provider.dart';
import 'package:laundrylane/services/push_message_handler.dart';
import 'package:laundrylane/src/app.dart';
import 'package:laundrylane/widgets/error_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  await GoogleSignIn.instance.initialize();
  initPushNotificationService();
  FirebaseMessaging.onBackgroundMessage(onPushBackgroundMessage);
  ErrorWidget.builder =
      (FlutterErrorDetails details) => ErrorScreen(details: details);
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://082e9ac99359472594dab5c93d2c4c88@o4508483665330176.ingest.us.sentry.io/4511505965776896';
      // Adds request headers and IP for users, for more info visit:
      // https://docs.sentry.io/platforms/dart/guides/flutter/data-management/data-collected/
      options.sendDefaultPii = true;
      options.enableLogs = true;
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
      // The sampling rate for profiling is relative to tracesSampleRate
      // Setting to 1.0 will profile 100% of sampled transactions:
      // ignore: experimental_member_use
      options.profilesSampleRate = 1.0;
      // Configure Session Replay
      options.replay.sessionSampleRate = 0.1;
      options.replay.onErrorSampleRate = 1.0;
    },
    appRunner:
        () => runApp(
          SentryWidget(
            child: ChangeNotifierProvider(
              create: (context) => CartProvider(),
              child: ProviderScope(
                child: MyApp(sharedPreferences: sharedPreferences),
              ),
            ),
          ),
        ),
  );
}
