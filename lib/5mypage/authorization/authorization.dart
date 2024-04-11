import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/5mypage/authorization/authorization_card.dart';
import 'package:team_husky/5mypage/authorization/memberlist.dart';

class Authorization extends StatefulWidget {
  const Authorization({Key? key});

  @override
  State<Authorization> createState() => _AuthorizationState();
}

class _AuthorizationState extends State<Authorization> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '권한부여',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      backgroundColor: Colors.blueGrey,
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width - 20,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 5),
              ]),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    '등급을 변경하고 싶은 직원을 선택하세요',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8), // 텍스트 주변의 여백 조정
                          decoration: BoxDecoration(
                            border: Border.all(
                              // 테두리 스타일 설정
                              color: Colors.black, // 테두리 색상
                              width: 2, // 테두리 두께
                            ),
                            borderRadius:
                                BorderRadius.circular(8), // 테두리 모양을 둥글게 설정
                          ),
                          child: Text(
                            '일반직원',
                            style: TextStyle(
                              letterSpacing: 3.0,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        MemberList(
                          grade: 0,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8), // 텍스트 주변의 여백 조정
                          decoration: BoxDecoration(
                            border: Border.all(
                              // 테두리 스타일 설정
                              color: Colors.black, // 테두리 색상
                              width: 2, // 테두리 두께
                            ),
                            borderRadius:
                                BorderRadius.circular(8), // 테두리 모양을 둥글게 설정
                          ),
                          child: Text(
                            '관리자',
                            style: TextStyle(
                              letterSpacing: 3.0,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        MemberList(
                          grade: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              //이름이 두글자거나 다섯글자 이상이면 에러뜸
            ],
          ),
        ),
      ),
    );
  }
}
