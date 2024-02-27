import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';
import 'package:permission_handler/permission_handler.dart';

class Team1Telephony extends StatefulWidget {
  @override
  _SmsReceiverState createState() => _SmsReceiverState();
}

class _SmsReceiverState extends State<Team1Telephony> {
  Telephony telephony = Telephony.instance;

  @override
  void initState() {
    super.initState();
    requestSmsPermission();
  }

  Future<void> requestSmsPermission() async {
    final status = await Permission.sms.request();
    if (status.isGranted) {
      initSmsReceiver();
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('승인되지 않으면 자동출자 진행이 되지않음 -호경-'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('확인'),
                ),
              ],
            );
          });
      // 권한이 거부된 경우 사용자에게 메시지를 표시하여 필요한 권한을 요청
      // 직접 설정으로 이동하여 권한을 부여할 수 있도록 안내
    }
  }

  void initSmsReceiver() {
    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        // SMS가 도착하면 이 함수가 호출됩니다.
        String? phoneNumber = message.address;
        String? messageBody = message.body;
        // 여기서 메시지를 가공하고 필요한 작업을 수행합니다.
        print('Received SMS from $phoneNumber: $messageBody');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}