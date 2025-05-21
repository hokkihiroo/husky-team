import 'package:flutter/material.dart';
import 'package:team_husky/user/ResetPasswordPage.dart';
import 'package:team_husky/user/custom_text_form.dart';
import 'package:team_husky/user/user_auth.dart';
import 'package:team_husky/user/user_resume.dart';

import '../view/splash_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  String id = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'asset/img/logo.png',
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 250,
              child: Container(
                height: 280,
                width: MediaQuery.of(context).size.width - 40,
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 5,
                      ),
                    ]),
                child: Form(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 13.0),
                          child: CustomTextForm(
                            hintText: '아이디',
                            onChanged: (String value) {
                              id = value;
                            },
                            icon: Icon(
                              Icons.account_circle,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 13.0),
                          child: CustomTextForm(
                            hintText: '비밀번호 ',
                            onChanged: (String value) {
                              password = value;
                            },
                            obscureText: true,
                            icon: Icon(
                              Icons.lock_outlined,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(width: 10,),

                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                onPressed: () async {
                                  try {
                                    final newUser =
                                        await AUTH.signInWithEmailAndPassword(
                                      email: id,
                                      password: password,
                                    );
                                    if (newUser.user != null) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return SplashScreen();
                                          },
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                                child: Text(
                                  '로그인',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 5,),

                            Expanded(
                              child: ElevatedButton(
                                style:
                                ElevatedButton.styleFrom(backgroundColor: Colors.black),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return ResetPasswordPage();
                                    }),
                                  );

                                },
                                child: Text(
                                  '비밀번호 찾기',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10,),

                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            SizedBox(width: 10,),
                            Expanded(
                              child: ElevatedButton(
                                style:
                                    ElevatedButton.styleFrom(backgroundColor: Colors.black),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return UserResume();
                                    }),
                                  );
                                },
                                child: Text(
                                  '이력서작성',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10,),

                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 600,
              child: Container(
                width: MediaQuery.of(context).size.width - 40,
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        '해당 앱은 팀허스키 직원 전용앱입니다. \n Copyright © Team.HUSKY 2018',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text('아이디와 비밀번호를 확인하세요.'),
      actions: [
        TextButton(
          onPressed: () {
            // 여기에 버튼을 눌렀을 때 수행할 동작을 추가할 수 있습니다.
            Navigator.pop(context); // 다이얼로그 닫기
          },
          child: Text('닫기'),
        ),
      ],
    );
  }
}
