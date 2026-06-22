package com.example.laundrylane
import  io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.media.RingtoneManager
import android.net.Uri


class MainActivity : FlutterFragmentActivity() {
    private var channel = "com.app.laundry_lane"
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,channel).setMethodCallHandler { call, result ->

            if (call.method == "incrementNotification") {
                // TODO implement increment dot notifications count
            } else if (call.method == "decrementNotification") {
                // TODO implement decrement notifications count
            }
             else if (call.method == "clearNotifications") {
                // TODO implement clear notifications count
             } else if (call.method == "notificationSound") {
                val notificationUri: Uri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
                val ringtone = RingtoneManager.getRingtone(this, notificationUri)
                ringtone.play();
            }
            else {
                result.notImplemented();
            }
        }
    }
}
