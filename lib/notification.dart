import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotication {
  static final push = FirebaseMessaging.instance;
  static String? androidToken;
  static String? iosAPNSToken;
  static String? iosToken;

  static Future<void> Init() async {
    await push.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  static Future<void> IosToken() async {
    try {
      iosAPNSToken = await push.getAPNSToken();
      iosToken = await push.getToken();
      print('ios APNS 토큰 $iosAPNSToken');
      print('ios 토큰 $iosToken');
    } catch (e) {
      print(e);
    }
  }

  static Future<void> AndroidToken() async {
    try {
      androidToken = await push.getToken();
      print('안드로이드토큰 $androidToken');
    } catch (e) {
      print(e);
    }
  }
}
