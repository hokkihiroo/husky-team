import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/5mypage/authorization/authorization.dart';
import 'package:team_husky/5mypage/management/management.dart';
import 'package:team_husky/5mypage/mylicense/myLicenseUpdate.dart';
import 'package:team_husky/5mypage/myschedule/myschedule.dart';
import 'package:team_husky/user/user_screen.dart';

import 'mysalary/mySalary.dart';
import 'updatePicture/mypicture.dart';

class MyPage extends StatefulWidget {
  const MyPage({
    super.key,
    required this.name,
    required this.uid,
    required this.team,
    required this.email,
    required this.grade,
    required this.birthDay,
    required this.picUrl,
  });

  final String name;
  final String uid;
  final String team;
  final String email;
  final int grade;
  final String birthDay;
  final String picUrl;

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120), // AppBar 높이 설정
        child: AppBar(
          backgroundColor: Colors.black45, // AppBar 배경색
          elevation: 4,
          flexibleSpace: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                // 사진 섹션
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: MyPicture(
                            uid: widget.uid,
                            team: widget.team,
                          ),
                        );
                      },
                    );
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    backgroundImage:
                        (widget.picUrl != null && widget.picUrl.isNotEmpty)
                            ? NetworkImage(widget.picUrl)
                            : null,
                    child: (widget.picUrl != null && widget.picUrl.isNotEmpty)
                        ? null
                        : const Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.white,
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                // 텍스트 정보 섹션
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "이름: ${widget.name}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.logout,
                              color: Colors.white,
                            ),
                            tooltip: "로그아웃",
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const UserScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "생년월일 : ${widget.birthDay}",
                        style: const TextStyle(
                            fontSize: 14, color: Colors.white70),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "메일 : ${widget.email}",
                        style: const TextStyle(
                            fontSize: 14, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 나의 스케줄 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyLicenseUpdate(
                                name: widget.name,
                                uid: widget.uid,
                                team: widget.team,
                                management: true,
                              )),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        // 텍스트를 왼쪽으로 정렬
                        children: const [
                          Icon(Icons.car_repair_outlined), // 아이콘
                          SizedBox(width: 8), // 아이콘과 텍스트 사이의 간격
                          Text('운전면허증'), // 텍스트
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MySchedule(
                              team: widget.team,
                              uid: widget.uid,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        // 텍스트를 왼쪽으로 정렬
                        children: const [
                          Icon(Icons.schedule), // 아이콘
                          SizedBox(width: 8), // 아이콘과 텍스트 사이의 간격
                          Text('나의스케줄'), // 텍스트
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MySalary(
                                name: widget.name,
                                uid: widget.uid,
                                team: widget.team,
                                management: true,

                              )),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        // 텍스트를 왼쪽으로 정렬
                        children: const [
                          Icon(Icons.paid_outlined), // 아이콘
                          SizedBox(width: 8), // 아이콘과 텍스트 사이의 간격
                          Text('급여명세서'), // 텍스트
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        showContentDialog(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        // 텍스트를 왼쪽으로 정렬
                        children: const [
                          Icon(Icons.edit), // 아이콘
                          SizedBox(width: 8), // 아이콘과 텍스트 사이의 간격
                          Text('근로계약서'), // 텍스트
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (widget.grade == 1 || widget.grade == 2)
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Management(name: widget.name),
                              ),
                            );
                          },
                          child: const Text('관리자 페이지'),
                        ),
                        const SizedBox(height: 16),
                        if (widget.grade == 2)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Authorization(),
                                ),
                              );
                            },
                            child: const Text('관리자 권한 설정'),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('(주) 팀허스키', style: TextStyle(fontSize: 14)),
            SizedBox(
              width: 10,
            ),
            Text('Copyright © Team.HUSKY 2018', style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  void showContentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림'),
          content: const Text('준비중입니다'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }
}
