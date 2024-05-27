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

            PushNotication.sendPushMessage(title: '팀허스키 ', message: '공지가 등록되었습둥');


          },
          child: const Text("알림 보내기"),
        ),
      ),
    );
  }
}

