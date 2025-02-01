import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:team_husky/5mypage/updatePicture/salaryPicture.dart';

class MySalary extends StatefulWidget {
  final String name;
  final String uid;
  final String team;
  final bool management;

  const MySalary({
    super.key,
    required this.name,
    required this.uid,
    required this.team,
    required this.management,
  });

  @override
  State<MySalary> createState() => _MySalaryState();
}

class _MySalaryState extends State<MySalary> {
  DateTime selectedDate = DateTime.now(); // 선택된 날짜를 관리
  late int currentYear;
  late int currentMonth;
  late String insertAddress;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    currentYear = now.year;
    currentMonth = now.month;
    insertAddress = '${currentYear}_${currentMonth}'; // 예: '2025_1'
  }

  // 이전 달로 이동하는 함수
  void _previousMonth() {
    setState(() {
      if (currentMonth == 1) {
        currentYear -= 1; // 이전 년도로 이동
        currentMonth = 12; // 12월로 설정
      } else {
        currentMonth -= 1; // 이전 달로 이동
      }
      // currentYear과 currentMonth 변경 후, insertAddress 업데이트
      insertAddress = '${currentYear}_${currentMonth}';
    });
  }

  void _nextMonth() {
    setState(() {
      // 현재 시스템 날짜 가져오기
      DateTime now = DateTime.now();

      // 현재 연도와 월이 현재 날짜 이상이면 이동을 막음
      if (currentYear == now.year && currentMonth >= now.month) {
        print("현재 날짜 이상으로 넘어갈 수 없습니다.");
        return; // 현재 월 이상으로 이동 불가
      }

      if (currentMonth == 12) {
        currentYear += 1; // 다음 년도로 이동
        currentMonth = 1; // 1월로 설정
      } else {
        currentMonth += 1; // 다음 달로 이동
      }

      // currentYear과 currentMonth 변경 후, insertAddress 업데이트
      insertAddress = '${currentYear}_${currentMonth}';
    });
  }

  // 현재 달로 이동하는 함수
  void goToCurrentMonth() {
    setState(() {
      final now = DateTime.now();
      currentYear = now.year; // 현재 년도
      currentMonth = now.month; // 현재 월
      insertAddress = '${currentYear}_${currentMonth}';
    });
  }

  String getQuarterLabel() {
    return '$currentYear년 ${currentMonth}월';
  }

  String getMonthLabel() {
    return '$currentMonth월';
  }

  String getMinusMonth() {
    int minusMonth = (currentMonth == 1) ? 12 : currentMonth - 1;
    return '$minusMonth월';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '나의 급여내역',
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
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: Container(
            color: Colors.white,
            height: 600,
            width: 360,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _DateControl(
                    onPressLeft: _previousMonth,
                    onPressRight: _nextMonth,
                    onPressGoToday: goToCurrentMonth,
                    currentQuarterLabel: getQuarterLabel(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('user')
                          .doc(widget.uid)
                          .collection('salary')
                          .doc('SJLmYrEd97eR6EaPX67b')
                          .collection(insertAddress)
                          .doc(widget.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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

                        if (data == null || data['licenseUrl'] == null) {
                          return Container(
                            height: 350, // 원하는 높이 설정
                            width: 320,
                            color: Colors.grey[200], // 회색 배경색
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.photo,
                                    size: 50, color: Colors.grey), // 사진 아이콘
                                const SizedBox(height: 8),

                                Center(
                                  child: Text(
                                    '${getMonthLabel()} 급여명세서가  없습니다.',
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return Container(
                          constraints: BoxConstraints(
                            maxWidth:
                                MediaQuery.of(context).size.width, // 화면 너비 제한
                          ),
                          height: 350, // 원하는 높이 설정
                          color: Colors.grey[200], // 회색 배경색
                          child: GestureDetector(
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
                      fontSize: 18,
                      // 텍스트 크기 설정
                      fontWeight: FontWeight.bold,
                      // 텍스트 굵게
                      color: Colors.white,
                      // 텍스트 색상
                      letterSpacing: 1.5,
                      // 글자 간격 설정
                      shadows: [
                        Shadow(
                          offset: Offset(1.0, 1.0), // 그림자 위치
                          blurRadius: 5.0, // 그림자 흐림 정도
                          color: Colors.black.withOpacity(0.5), // 그림자 색상과 투명도
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${getMinusMonth()} 한달간 고생많으셨습니다.'),
                      ],
                    ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 버튼 간격 균등 배치
          children: [
            // 텍스트 삭제하기 버튼
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                // 버튼 배경색
                onPrimary: Colors.yellow,
                // 텍스트 및 버튼 효과 색상
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // 모서리 둥글기 조정
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                // 버튼 크기 조정
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
            if (widget.management)
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: SalaryPicture(
                          uid: widget.uid,
                          team: widget.team,
                          date: insertAddress,
                        ),
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  // 버튼 배경색
                  onPrimary: Colors.yellow,
                  // 텍스트 및 버튼 효과 색상
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // 모서리 둥글기
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  // 버튼 크기
                  elevation: 5, // 그림자 효과
                ),
                child: const Text(
                  '급여 사진 올리기',
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
            '이번달',
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
