import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/layout/default_layout.dart';
import 'package:team_husky/user/custom_text_form.dart';
import 'package:team_husky/user/user_auth.dart';

class UserResume extends StatefulWidget {
  const UserResume({super.key});

  @override
  State<UserResume> createState() => _UserResumeState();
}

class _UserResumeState extends State<UserResume> {
  final _formKey = GlobalKey<FormState>();

  void _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  String email = '';
  String password = '';
  String name = '';
  String phoneNumber = '';
  String carNumber = '';
  String adress = '';

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: Colors.brown,
        title: '직원이력',
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
              height: 800.0,
              width: MediaQuery.of(context).size.width - 20,
              margin: EdgeInsets.only(top: 10,left: 10,right: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 5),
                  ]),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      CustomTextForm(
                        key: ValueKey(1),
                        validator: (val) {
                          if (val!.isEmpty || val.length < 1) {
                            return '이메일은 필수사항입니다.';
                          }

                          if (!RegExp(
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                              .hasMatch(val)) {
                            return '잘못된 이메일 형식입니다.';
                          }

                          return null;
                        },
                        onSaved: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                        hintText: '이메일',
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      CustomTextForm(
                        key: ValueKey(2),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return '비밀번호는 필수사항입니다.';
                          }

                          if (val.length < 6) {
                            return '6자 이상 입력해주세요!';
                          }
                          return null;
                        },
                        obscureText: true,
                        onSaved: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                        hintText: '비밀번호',
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      CustomTextForm(
                        key: ValueKey(3),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return '이름은 필수사항입니다.';
                          }

                          if (val.length < 2) {
                            return '이름은 두글자 이상 입력 해주셔야합니다.';
                          }

                          return null;
                        },
                        onSaved: (val) {
                          setState(() {
                            name = val;
                          });
                        },
                        hintText: '이름',
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      CustomTextForm(
                        key: ValueKey(4),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return '전화번호는 필수사항입니다.';
                          }
                        },
                        onSaved: (val) {
                          setState(() {
                            phoneNumber = val;
                          });
                        },
                        hintText: '전화번호',
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      CustomTextForm(
                        key: ValueKey(5),
                        onSaved: (val) {
                          setState(() {
                            carNumber = val!;
                          });
                        },
                        hintText: '차량번호입력',
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      CustomTextForm(
                        key: ValueKey(6),
                        onSaved: (val) {
                          setState(() {
                            adress = val!;
                          });
                        },
                        hintText: '주소',
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //돌아가기
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.brown),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              '돌아가기',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          //이력서 제출
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.brown),
                            onPressed:  () async {
                              _tryValidation();
                              try {
                                final newUser = await AUTH
                                    .createUserWithEmailAndPassword(
                                    email: email, password: password);

                                await FirebaseFirestore.instance
                                    .collection(BONSA)
                                    .doc(newUser.user!.uid)
                                    .set({
                                  'email': email,
                                  'name': name,
                                  'phoneNumber': phoneNumber,
                                  'carNumber': carNumber,
                                });
                                Navigator.pop(context);
                              } catch (e) {
                                print(e);
                              }
                            },
                            child: Text('이력서 제출',
                            style: TextStyle(
                              color: Colors.white,
                            ),),

                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
