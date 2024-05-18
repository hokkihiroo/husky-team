import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class PushNotication {
  static final push = FirebaseMessaging.instance;
  static String? token;
  static String? iosAPNSToken;
  static int _messageCount = 0;

  static String constructFCMPayload(String? token) {
    _messageCount++;
    return jsonEncode({
      'token': token,
      'data': {
        'via': 'FlutterFire Cloud Messaging!!!',
        'count': _messageCount.toString(),
      },
      'notification': {
        'title': 'Hello FlutterFire!',
        'body': 'This notification (#$_messageCount) was created via FCM!',
      },
    });
  }

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
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      token =fcmToken;
      print('토큰변경됨');
      print(fcmToken);
      print(fcmToken);
      print(fcmToken);
      print('토큰변경됨');
    }).onError((err) {});
  }

  static Future<void> IosToken() async {
    try {
      iosAPNSToken = await push.getAPNSToken();
      token = await push.getToken();
      print('ios APNS 토큰 $iosAPNSToken');
      print('ios 토큰 $token');
    } catch (e) {
      print(e);
    }
  }

  static Future<void> AndroidToken() async {
    try {
      token = await push.getToken();
      print('안드로이드토큰 $token');
    } catch (e) {
      print(e);
    }
  }

  static Future<void> sendPushMessage() async {
    if (token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    try {
      await http.post(
        Uri.parse('https://api.rnfirebase.io/messaging/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: constructFCMPayload(token),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }
}
