import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_new_badger/flutter_new_badger.dart';
import 'package:laundrylane/models/default_response.dart';
import 'package:laundrylane/src/apis/mutations.dart';
import 'package:laundrylane/src/app.dart';
import 'package:laundrylane/src/orders/order_details.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

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
  await flutterLocalNotificationsPlugin.initialize(
    settings: InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: IOSInitializationSettings(),
      macOS: DarwinInitializationSettings(),
    ),
  );

  FirebaseMessaging.onMessage.listen((message) {
    FlutterNewBadger.incrementBadgeCount();
    PushNotificationData data = PushNotificationData.fromJson(message.data);
    flutterLocalNotificationsPlugin.show(
      id: 0,
      title: data.title,
      body: data.message,
      payload: data.ref.toString(),
    );
  });
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    PushNotificationData data = PushNotificationData.fromJson(message.data);
    handleNotificationTap(data.type, data.ref);
  });
}

@pragma('vm:entry-point')
Future<void> onPushBackgroundMessage(RemoteMessage message) async {
  FlutterNewBadger.incrementBadgeCount();
}

void handleNotificationTap(String type, String? ref) {
  switch (type) {
    case "ORDER_CREATED":
    case "ORDER_UPDATED":
      navigatorKey.currentState?.pushNamed(
        OrderDetails.routeName,
        arguments: ref,
      );
      FlutterNewBadger.decrementBadgeCount();
      break;
    default:
  }
}
