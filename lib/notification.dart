import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;

class PushNotication {
  static final push = FirebaseMessaging.instance;
  static String? token;
  static String? iosAPNSToken;
  static int _messageCount = 0;

  //fcm 알림퍼미션
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
      print('토큰변경됨');
    }).onError((err) {});
  }

  //ios 토큰받기
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

  //안드로이드 토큰받기
  static Future<void> AndroidToken() async {
    try {
      token = await push.getToken();
      print('안드로이드토큰 $token');
    } catch (e) {
      print(e);
    }
  }

  static Future<void> sendPushMessage(
      {required String title, required String message}) async {
    final sender = '990003848885';
    final jsonCredentials = await rootBundle.loadString('asset/data/auth.json');
    final creds =
        await auth.ServiceAccountCredentials.fromJson(jsonCredentials);
    final client = await auth.clientViaServiceAccount(
        creds, ['https://www.googleapis.com/auth/cloud-platform']);

    String constructFCMPayload(String? token) {

      _messageCount++;
      return jsonEncode({
        'message': {
       //  'token': 'dNyWjRBAAkyqqWXkA5ZuIi:APA91bGFvPJ3d48Z98jhXh8ku0Q87fPVMfY_SHdr3R1neNH8cLbwU1gtRxkrCG2hrgyPV0OBM1DNTnMEKXKxYjsrOjhrnBngZm7uVe3E5tK3uKmu6aMfIVVECbPnk4Bp_aGVWmGfic5-',
          //'token': token,
          'topic': 'allDevices', // 모든 기기에 메시지를 전송
          'notification': {
            'body': '$message',
            'title': '$title',
          }
        }
      });
    }

    if (token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    final response = await client.post(
      Uri.parse('https://fcm.googleapis.com/v1/projects/$sender/messages:send'),
      // 발신자아이디
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: constructFCMPayload(token),
    );

    client.close();
    if (response.statusCode == 200) {
      print(response.statusCode);
      print('FCM request for device sent!');
    } else {
      print(response.statusCode);
      print(response.reasonPhrase);
      print(response.body);
    }
  }
}
