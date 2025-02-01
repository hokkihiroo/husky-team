import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/5mypage/updatePicture/licensePicture.dart';

class MyLicenseUpdate extends StatefulWidget {
  final String name;
  final String uid;
  final String team;
 final bool management ;

  const MyLicenseUpdate({
    super.key,
    required this.name,
    required this.uid,
    required this.team,
    required this.management,
  });

  @override
  State<MyLicenseUpdate> createState() => _LicenseUpdateState();
}

class _LicenseUpdateState extends State<MyLicenseUpdate> {
  File? pickedImage;
  DateTime selectedDate = DateTime.now(); // 선택된 날짜를 관리
  late int currentYear;
  late int currentQuarter; // 1~4분기로 관리
  late String insertAddress;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    currentYear = now.year;
    currentQuarter = getQuarterFromMonth(now.month);
    insertAddress = '${currentYear}_${currentQuarter}'; // 예: '2025_1'

    print(widget.name);
    print(widget.name);
    print(widget.team);
    print(widget.management);
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
      // currentYear과 currentQuarter 변경 후, currentYearAndQuarter 업데이트
      insertAddress = '${currentYear}_${currentQuarter}';
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
      // currentYear과 currentQuarter 변경 후, currentYearAndQuarter 업데이트
      insertAddress = '${currentYear}_${currentQuarter}';
    });
  }

  void goToCurrentQuarter() {
    setState(() {
      final now = DateTime.now();
      currentYear = now.year;
      currentQuarter = getQuarterFromMonth(now.month);
      insertAddress = '${currentYear}_${currentQuarter}';
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
          '${widget.name}님의 운전면허',
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
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
                    .collection(insertAddress)
                    .doc(widget.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('데이터를 불러오는 중 오류가 발생했습니다.'),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(
                      child: Text('해당 문서를 찾을 수 없습니다.'),
                    );
                  }

                  final data = snapshot.data!.data();
                    if (data == null) {
                    return const Center(
                      child: Text(
                        '이번분기 사진이 없습니다.',
                      ),
                    );
                  }

                  return Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width, // 화면 너비 제한
                    ),
                    height: 350, // 원하는 높이 설정
                    color: Colors.grey[200], // 회색 배경색
                    child: data == null || data['licenseUrl'] == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.photo,
                                  size: 50, color: Colors.grey), // 사진 아이콘
                              const SizedBox(height: 8),
                            ],
                          )
                        : GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullImageView(
                                      imageUrl: data['licenseUrl']),
                                ),
                              );
                            },
                            child: Hero(
                              tag: 'fullImage', // Hero 태그 설정
                              child: Image.network(
                                data['licenseUrl'], // 이미지 URL 사용
                                fit: BoxFit.cover, // 이미지를 가득 채움
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (context, error, stackTrace) =>
                                    Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.broken_image,
                                        size: 50, color: Colors.grey),
                                    const SizedBox(height: 8),
                                    const Text(
                                      '이미지를 불러올 수 없습니다',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  );
                }),
            const SizedBox(height: 20),
            Text(
              '눌러서 확대하세요',
              style: TextStyle(
                fontSize: 18,  // 텍스트 크기 설정
                fontWeight: FontWeight.bold,  // 텍스트 굵게
                color: Colors.white,  // 텍스트 색상
                letterSpacing: 1.5,  // 글자 간격 설정
                shadows: [
                  Shadow(
                    offset: Offset(1.0, 1.0), // 그림자 위치
                    blurRadius: 5.0,  // 그림자 흐림 정도
                    color: Colors.black.withOpacity(0.5), // 그림자 색상과 투명도
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 버튼 간격 균등 배치
          children: [
            // 텍스트 삭제하기 버튼
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black, // 버튼 배경색
                onPrimary: Colors.yellow, // 텍스트 및 버튼 효과 색상
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // 모서리 둥글기 조정
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // 버튼 크기 조정
                elevation: 5, // 그림자 효과
              ),
              child: const Text(
                '뒤로가기',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold, // 글자 두껍게
                  letterSpacing: 1.2, // 글자 간격
                ),
              ),
            ),

            // 사진 올리기 버튼
            if(!widget.management)
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: LicensePicture(
                        uid: widget.uid,
                        team: widget.team,
                        date: insertAddress,
                      ),
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black, // 버튼 배경색
                onPrimary: Colors.yellow, // 텍스트 및 버튼 효과 색상
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // 모서리 둥글기
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // 버튼 크기
                elevation: 5, // 그림자 효과
              ),
              child: const Text(
                '사진 올리기',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold, // 글자 두껍게
                  letterSpacing: 1.2, // 글자 간격
                ),
              ),
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
      body: DraggableScrollableSheet(
        initialChildSize: 1.0, // 처음에는 화면을 꽉 채운 상태
        minChildSize: 0.2, // 최소 드래그 크기
        maxChildSize: 1.0, // 최대 드래그 크기
        builder: (context, controller) {
          return GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.primaryDelta! > 0) {
                Navigator.of(context).pop(); // 아래로 드래그하여 뒤로 가기
              }
            },
            child: Center(
              child: Hero(
                tag: 'fullImage', // Hero 태그로 이미지 애니메이션 처리
                child: InteractiveViewer(
                  panEnabled: true, // 이미지를 드래그해서 이동
                  minScale: 0.5, // 최소 확대 비율
                  maxScale: 4.0, // 최대 확대 비율
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain, // 이미지가 화면에 맞게 확대/축소
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
