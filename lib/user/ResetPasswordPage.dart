import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _resetPassword() async {
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('비밀번호 재설정 이메일이 전송되었습니다!')),
      );

      Navigator.pop(context);


    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류가 발생했습니다: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('비밀번호 재설정')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: '이메일',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: _resetPassword,
              icon: Icon(Icons.email_outlined, size: 20.0, color: Colors.white),
              label: Text(
                '비밀번호 재설정 이메일 보내기 >>>',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // 버튼 배경색
                foregroundColor: Colors.white, // 버튼 텍스트 및 아이콘 색상
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // 둥근 모서리
                ),
                elevation: 5, // 버튼 그림자 효과
              ),
            ),

            SizedBox(
              height: 20,
            ),
            Text(
              '해당 이메일로 비밀번호 변경 링크가',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                height: 1.5, // 줄 간격 조정
              ),
            ),
            Text(
              ' 전송되며 링크를 눌러 비밀번호를 변경하여',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                height: 1.5, // 줄 간격 조정
              ),
            ),
            Text(
              '다시 로그인하세요.',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                height: 1.5, // 줄 간격 조정
              ),
            ),
          ],
        ),
      ),
    );
  }
}
