import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/user/user_auth.dart';
import 'package:team_husky/user/user_screen.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key, required this.name, required this.email});

  final String name;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('메일 : $email'),
              Text('이름 :$name'),
            ],
          ),
          SizedBox(height: 300,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return UserScreen();
                      },
                    ),
                  );
                },
                child: Text('로그아웃'),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
// AlertDialog를 반환하여 대화 상자 내용을 정의
                      return AlertDialog(
                        content: Text(
                            '모든 데이터가 소실되어 \n 더이상 앱사용이 불가합니다.\n 계속 하시겠습니까?'),
                        actions: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextButton(
                                  onPressed: () async {
                                    try {
                                      User? currentUser =
                                          FirebaseAuth.instance.currentUser;

                                      if (currentUser != null) {
                                        String userId = currentUser.uid;

                                        await FIRESTORE
                                            .collection(
                                                'user/KZwZFZ6RV8WKvynPHZDs/bonsa')
                                            .doc(userId)
                                            .delete();
                                        await currentUser.delete();
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return UserScreen();
                                            },
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      print('Error deleting user: $e');
                                    }
                                  },
                                  child: Text('퇴사하기'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextButton(
                                  onPressed: () {
// 대화 상자 닫기
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('취소'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('퇴사하기'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
