import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:laundrylane/src/apis/mutations.dart';

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
    print('onMessage: $message');
  });
}

Future<void> onPushBackgroundMessage(RemoteMessage message) async {
  print('onPushBackgroundMessage: $message');
}
