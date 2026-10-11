import 'package:app_badge_plus/app_badge_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:laundrylane/models/default_response.dart';
import 'package:laundrylane/src/apis/mutations.dart';
import 'package:laundrylane/src/app.dart';
import 'package:laundrylane/src/notifications/ringtone.dart';
import 'package:laundrylane/src/orders/order_details.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;

Future<String?> getToken() async {
  String? token = await messaging.getToken();
  return token;
}

void updateFcmToken() async {
  String? token = await getToken();
  if (token != null) {
    await setFcmToken(token);
  }
}

void initPushNotificationService() async {
  String? token = await getToken();

  if (token != null) {
    await setFcmToken(token);
  }

  FirebaseMessaging.onMessage.listen((message) {
    try {
      RingtoneService.playNotification();
    } on Exception catch (e) {
      Sentry.captureException(e);
    }
  });
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    PushNotificationData data = PushNotificationData.fromJson(message.data);
    if (data.type != null) {
      handleNotificationTap(data.type!, data.ref);
    }
  });
}

@pragma('vm:entry-point')
Future<void> onPushBackgroundMessage(RemoteMessage message) async {
  AppBadgePlus.updateBadge(1);
}

void handleNotificationTap(String type, String? ref) {
  switch (type) {
    case "ORDER_CREATED":
    case "ORDER_UPDATED":
      navigatorKey.currentState?.pushNamed(
        OrderDetails.routeName,
        arguments: ref,
      );
      AppBadgePlus.updateBadge(0);
      break;
    default:
  }
}
