import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/notification.dart';
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
  late String team;
  late String email;
  late int grade;
  late String birth;
  late String picUrl;

  @override
  void initState() {
    // Notice();
    super.initState();

    checkLoginStatus();
  }

  //   Notice() async {
  //   await FlutterLocalNotification.init();
  //   FlutterLocalNotification.requestNotificationPermission();
  // }

  Future<void> checkLoginStatus() async {
    await Future.delayed(Duration(seconds: 0)); // 일부러 1초 대기

    // FirebaseAuth 인스턴스를 사용하여 현재 로그인된 사용자 가져오기
    _user = FirebaseAuth.instance.currentUser;

    // 사용자가 로그인되어 있는지 확인
    if (_user != null) {
      try {
        String userID = _user!.uid;
        CollectionReference insa =
            await FirebaseFirestore.instance.collection('insa');

        // QuerySnapshot querySnapshot = await insa.get();
        // for (var doc in querySnapshot.docs) {
        //   // Get the list collection for each insa document
        //   CollectionReference listCollection =
        //       insa.doc(doc.id).collection('list');
        //   DocumentSnapshot subDocSnapshot =
        //       await listCollection.doc(userID).get();
        //
        //   // Check if the sub-document exists in the list collection
        //   if (subDocSnapshot.exists) {
        //     team = doc.id;
        //     print('Document ID: $team');
        //   }
        // }

        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection(myInfoAdress)
                .doc(_user!.uid)
                .get();
        if (snapshot.exists && snapshot.data() != null) {
          team =  snapshot.data()!['teamId'];
          name = snapshot.data()!['name'];
          email = snapshot.data()!['email'];
          grade = snapshot.data()!['grade'];
          birth = snapshot.data()!['birthDay'];
          picUrl = snapshot.data()?['picUrl'] ?? ''; // picUrl이 null이면 빈 문자열로 설정
     //     picUrl: picUrl ?? 'default_image_url', // 기본 URL 설정
        }
      } catch (e) {
        print('Error fetching data: $e');
        return null;
        // 여기에 이름이 존재 하지않는다면 무한루프에 빠지므로
        // 절대적으로 이름을 넣도록 해야함
      }
      print(_user!.email);
      print(_user!.uid);
      print('유저의 이름 $name');
      print('유저의 등급 $grade');
      // 사용자가 로그인된 경우
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MainView(
                  name: name,
                  email: email,
                  grade: grade,
                  team: team,
                  myUid: _user!.uid,
                  birthDay: birth,
                  picUrl: picUrl,
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
