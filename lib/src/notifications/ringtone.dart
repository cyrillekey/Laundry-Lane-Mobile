import 'package:flutter/services.dart';

class RingtoneService {
  static const MethodChannel _channel = MethodChannel('com.app.laundry_lane');
  static Future<void> playNotification() async {
    await _channel.invokeMethod('notificationSound');
  }

  static Future<void> stopNotification() async {
    await _channel.invokeMethod('stopNotification');
  }
}
