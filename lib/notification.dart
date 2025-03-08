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
    print('IOS 토큰받기 시작함');
    try {
      iosAPNSToken = await push.getAPNSToken();
      token = await push.getToken();

      print('📲 APNs 토큰: $iosAPNSToken');
      print('📲 FCM 토큰: $token');

      if (iosAPNSToken == null) {
        print("❌ APNs 토큰이 null입니다. 3초 후 재시도...");
        await Future.delayed(Duration(seconds: 3));
        iosAPNSToken = await push.getAPNSToken();
        print("📲 재시도 후 APNs 토큰: $iosAPNSToken");
      }
    } catch (e) {
      print("❌ 오류 발생: $e");
    }

    print('📲 IOS 토큰받기 끝');
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
