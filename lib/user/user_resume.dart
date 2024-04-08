import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/1insa/Address.dart';
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
  String image = 'asset/img/face.png'; //팀명


  void _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  String email = '';
  String password = '';
  String name = '';
  String birthDay = '';
  String phoneNumber = '';
  String carNumber = ''; //자차번호
  String address = ''; //주소
  String career = ''; //운전경력
  String hobby = ''; //취미
  String footSize = ''; //발사이즈
  String tShirtSize = ''; //상의
  String pantsSize = ''; //하의
  String cm = ''; //키
  String kg = ''; //몸무게

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
              height: 1400.0,
              width: MediaQuery.of(context).size.width - 20,
              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
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
                        validator: (val) {
                          if (val!.isEmpty) {
                            return ' 생년월일을 입력바랍니다.';
                          }
                        },
                        onSaved: (val) {
                          setState(() {
                            birthDay = val;
                          });
                        },
                        hintText: '생년월일 예) 1999년 01월 14일',
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      CustomTextForm(
                        key: ValueKey(6),
                        onSaved: (val) {
                          setState(() {
                            carNumber = val!;
                          });
                        },
                        hintText: '차량번호 or 없음',
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      CustomTextForm(
                        key: ValueKey(7),
                        onSaved: (val) {
                          setState(() {
                            address = val!;
                          });
                        },
                        hintText: '주소 예)서울 강남구 대치동 434-1번지',
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      CustomTextForm(
                        key: ValueKey(8),
                        onSaved: (val) {
                          setState(() {
                            career = val!;
                          });
                        },
                        hintText: '운전경력 예) 5년',
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      CustomTextForm(
                        key: ValueKey(9),
                        onSaved: (val) {
                          setState(() {
                            hobby = val!;
                          });
                        },
                        hintText: '취미',
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      CustomTextForm(
                        key: ValueKey(10),
                        onSaved: (val) {
                          setState(() {
                            footSize = val!;
                          });
                        },
                        hintText: '발사이즈 예) 260',
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      CustomTextForm(
                        key: ValueKey(11),
                        onSaved: (val) {
                          setState(() {
                            tShirtSize = val!;
                          });
                        },
                        hintText: '상의사이즈 예) 100',
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      CustomTextForm(
                        key: ValueKey(12),
                        onSaved: (val) {
                          setState(() {
                            pantsSize = val!;
                          });
                        },
                        hintText: '하의사이즈 예) 32',
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      CustomTextForm(
                        key: ValueKey(13),
                        onSaved: (val) {
                          setState(() {
                            cm = val!;
                          });
                        },
                        hintText: '키 예) 175',
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      CustomTextForm(
                        key: ValueKey(14),
                        onSaved: (val) {
                          setState(() {
                            kg = val!;
                          });
                        },
                        hintText: '몸무게 예) 70',
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //돌아가기
                          ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: Colors.brown),
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
                            style:
                                ElevatedButton.styleFrom(primary: Colors.brown),
                            onPressed: () async {
                              _tryValidation();
                              try {
                                final newUser =
                                    await AUTH.createUserWithEmailAndPassword(
                                        email: email, password: password);

                                await FirebaseFirestore.instance
                                    .collection(USER)
                                    .doc(newUser.user!.uid)
                                    .set({
                                  'image': image,
                                  'email': email,
                                  'name': name,
                                  'birthDay': birthDay,
                                  'phoneNumber': phoneNumber,
                                  'carNumber': carNumber,
                                  'address': address,
                                  'career': career,
                                  'hobby': hobby,
                                  'footSize': footSize,
                                  'tShirtSize': tShirtSize,
                                  'pantsSize': pantsSize,
                                  'cm': cm,
                                  'kg': kg,
                                  'grade': 0,
                                  //등급
                                  'enterDay': FieldValue.serverTimestamp(),
                                  //입사일
                                });

                                await FirebaseFirestore.instance
                                    .collection(INSA)
                                    .doc(BOSNA)
                                    .collection(LIST)
                                    .doc(newUser.user!.uid)
                                    .set({
                                  'image': image,
                                  'name': name,  //이름
                                  'grade': '사원',
                                  'position': '드라이버',
                                  'enterDay': FieldValue.serverTimestamp(),

                                });
                                Navigator.pop(context);
                              } catch (e) {
                                print(e);
                              }
                            },
                            child: Text(
                              '이력서 제출',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
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
