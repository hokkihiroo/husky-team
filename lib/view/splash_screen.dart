import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/user/user_screen.dart';
import 'package:team_husky/view/color.dart';
import 'package:team_husky/view/main_view.dart';

import 'adress.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late User? _user;
  late String name;

  @override
  void initState() {
    super.initState();

    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    await Future.delayed(Duration(seconds: 1)); // 일부러 1초 대기

    // FirebaseAuth 인스턴스를 사용하여 현재 로그인된 사용자 가져오기
    _user = FirebaseAuth.instance.currentUser;

    // 사용자가 로그인되어 있는지 확인
    if (_user != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection(myInfoAdress)
                .doc(_user!.uid)
                .get();
        if (snapshot.exists && snapshot.data() != null) {
          name = snapshot.data()!['name'];
        }
      } catch (e) {
        print('Error fetching data: $e');
        return null;
        // 여기에 이름이 존재 하지않는다면 무한루프에 빠지므로
        // 절대적으로 이름을 넣도록 해야함
      }
      print(_user!.email);
      print(_user!.uid);
      print(name);
      // 사용자가 로그인된 경우
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MainView(
                  name: name,
                )),
      );
    } else {
      // 사용자가 로그인되어 있지 않은 경우
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SPLASHCOLOR,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/img/splash.png',
              width: MediaQuery.of(context).size.width / 2,
            ),
            const SizedBox(
              height: 16,
            ),
            CircularProgressIndicator(
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
