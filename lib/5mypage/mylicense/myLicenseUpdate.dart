import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/5mypage/updatePicture/licensePicture.dart';

class MyLicenseUpdate extends StatefulWidget {
  final String name;
  final String uid;
  final String team;

  const MyLicenseUpdate({
    super.key,
    required this.name,
    required this.uid,
    required this.team,
  });

  @override
  State<MyLicenseUpdate> createState() => _LicenseUpdateState();
}

class _LicenseUpdateState extends State<MyLicenseUpdate> {
  DateTime selectedDate = DateTime.now(); // 선택된 날짜를 관리
  late int currentYear;
  late int currentQuarter; // 1~4분기로 관리
  // late String insertAddress;
  File? pickedImage;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    currentYear = now.year;
    currentQuarter = getQuarterFromMonth(now.month);
  }

  int getQuarterFromMonth(int month) {
    if (month >= 1 && month <= 3) {
      return 1;
    } else if (month >= 4 && month <= 6) {
      return 2;
    } else if (month >= 7 && month <= 9) {
      return 3;
    } else {
      return 4;
    }
  }

  void _previousQuarter() {
    setState(() {
      if (currentQuarter == 1) {
        currentYear -= 1;
        currentQuarter = 4;
      } else {
        currentQuarter -= 1;
      }
    });
  }

  void _nextQuarter() {
    setState(() {
      if (currentQuarter == 4) {
        currentYear += 1;
        currentQuarter = 1;
      } else {
        currentQuarter += 1;
      }
    });
  }

  void goToCurrentQuarter() {
    setState(() {
      final now = DateTime.now();
      currentYear = now.year;
      currentQuarter = getQuarterFromMonth(now.month);
    });
  }

  String getQuarterLabel() {
    return '$currentYear년 ${currentQuarter}분기';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '나의 운전면허관리',
          style: TextStyle(
            color: Colors.white, // 텍스트를 흰색으로 변경
            fontWeight: FontWeight.bold, // 굵은 글씨
            fontSize: 20, // 텍스트 크기 증가
            letterSpacing: 1.2, // 글자 간격 추가
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        // 아이콘 색상 변경
        centerTitle: true,
        // 제목 중앙 정렬
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.black], // 그라데이션 색상
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3), // 그림자 색상
                offset: Offset(0, 4), // 그림자 위치
                blurRadius: 10, // 그림자 흐림 정도
              ),
            ],
          ),
        ),
        elevation: 0, // AppBar 그림자 제거
      ),
      body: Column(
        children: [
          _DateControl(
            onPressLeft: _previousQuarter,
            onPressRight: _nextQuarter,
            onPressGoToday: goToCurrentQuarter,
            currentQuarterLabel: getQuarterLabel(),
          ),
          SizedBox(
            height: 40,
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('user')
                  .doc(widget.uid)
                  .collection('${currentYear}_${currentQuarter}')
                  .doc(widget.uid)
                  .snapshots(),
              builder: (context, snapshot) {

                final data = snapshot.data!.data();

                return Container(
                  width: double.infinity, // 화면 너비를 꽉 채움
                  height: 350, // 원하는 높이 설정
                  color: Colors.grey[200], // 회색 배경색
                  child: data == null || data['licenseUrl'] == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.photo,
                                size: 50, color: Colors.grey), // 사진 아이콘
                            const SizedBox(height: 8),
                            const Text(
                              '이번 분기 사진이 없습니다',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          ],
                        )
                      : Image.network(
                    data['licenseUrl'], // 이미지 URL 사용
                          fit: BoxFit.cover, // 이미지를 가득 채움
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) => Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.broken_image,
                                  size: 50, color: Colors.grey),
                              const SizedBox(height: 8),
                              const Text(
                                '이미지를 불러올 수 없습니다',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                );
              }),
          const SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 버튼 간격 균등 배치
          children: [
            // 텍스트 삭제하기 버튼
            ElevatedButton(
              onPressed: () {
                print(currentYear);
                print(currentQuarter);
              },
              child: const Text('텍스트 삭제하기'),
            ),
            // 사진 올리기 버튼
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: LicensePicture(
                          uid: widget.uid,
                          team: widget.team,
                          date:'${currentYear}_${currentQuarter}'),
                    );
                  },
                );
              },
              child: const Text('사진 올리기'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateControl extends StatelessWidget {
  final VoidCallback onPressLeft;
  final VoidCallback onPressRight;
  final VoidCallback onPressGoToday;
  final String currentQuarterLabel;

  const _DateControl({
    super.key,
    required this.onPressLeft,
    required this.onPressRight,
    required this.onPressGoToday,
    required this.currentQuarterLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left_outlined, color: Colors.black),
          onPressed: onPressLeft,
        ),
        Text(
          currentQuarterLabel,
          style: const TextStyle(fontSize: 20),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right_outlined, color: Colors.black),
          onPressed: onPressRight,
        ),
        GestureDetector(
          onTap: onPressGoToday,
          child: const Text(
            '현재분기',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
      ],
    );
  }
}

class FullImageView extends StatelessWidget {
  final String imageUrl;

  FullImageView({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Center(
          child: Hero(
            tag: 'fullImage',
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
