import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:team_husky/5mypage/updatePicture/salaryPicture.dart';

class MySalary extends StatefulWidget {
  final String name;
  final String uid;
  final String team;
  final bool management ;

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
  late int currentMonth; // 1~4분기로 관리
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
            color: Colors.blue,
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
                  primary: Colors.black, // 버튼 배경색
                  onPrimary: Colors.yellow, // 텍스트 및 버튼 효과 색상
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // 모서리 둥글기
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // 버튼 크기
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
