import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/5mypage/authorization/authorization.dart';
import 'package:team_husky/5mypage/management/management.dart';
import 'package:team_husky/user/user_auth.dart';
import 'package:team_husky/user/user_screen.dart';

class MyPage extends StatelessWidget {
  const MyPage(
      {super.key,
      required this.name,
      required this.email,
      required this.grade});

  final String name;
  final String email;
  final int grade;

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
          SizedBox(
            height: 20,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.black),
                onPressed: () {
                  if (grade == 0) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('접근 거부'),
                          content: Text('관리자 권한이 필요합니다.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('확인'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return Management(name: name,);
                      }),
                    );
                  }
                },
                child: Text(
                  '관리자페이지',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.black),
                onPressed: () {
                  if (grade != 2) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('접근 거부'),
                          content: Text('관리자 권한이 필요합니다.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('확인'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return Authorization();
                      }),
                    );
                  }
                },
                child: Text(
                  '관리자 권한설정',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 200,
          ),
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
//               ElevatedButton(
//                 onPressed: () {
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
// // AlertDialog를 반환하여 대화 상자 내용을 정의
//                       return AlertDialog(
//                         content: Text(
//                             '모든 데이터가 소실되어 \n 더이상 앱사용이 불가합니다.\n 계속 하시겠습니까?'),
//                         actions: [
//                           Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: TextButton(
//                                   onPressed: () async {
//                                     try {
//                                       User? currentUser =
//                                           FirebaseAuth.instance.currentUser;
//                                       print(currentUser);
//                                       print(currentUser);
//                                       print(currentUser);
//                                       print(currentUser);
//                                       if (currentUser != null) {
//                                         String userId = currentUser.uid;
//
//                                         await FIRESTORE
//                                             .collection('user')
//                                             .doc(userId)
//                                             .delete();
//
//                                         await currentUser.delete();
//                                         await FirebaseAuth.instance.signOut();
//                                         Navigator.pushReplacement(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) {
//                                               return UserScreen();
//                                             },
//                                           ),
//                                         );
//                                       }
//                                     } catch (e) {
//                                       print('Error deleting user: $e');
//                                     }
//                                   },
//                                   child: Text('퇴사하기'),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: TextButton(
//                                   onPressed: () {
// // 대화 상자 닫기
//                                     Navigator.of(context).pop();
//                                   },
//                                   child: Text('취소'),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 },
//                 child: Text('퇴사하기'),
//               ),
            ],
          ),
        ],
      ),
    );
  }
}
