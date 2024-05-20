import 'package:flutter/material.dart';

import '../notification.dart';

class Notication extends StatelessWidget {
  const Notication({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {

            PushNotication.sendPushMessage(title: '공지가 ', message: '등록됨요');


          },
          child: const Text("알림 보내기"),
        ),
      ),
    );
  }
}

