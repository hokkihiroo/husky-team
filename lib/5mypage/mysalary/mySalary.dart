import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MySalary extends StatefulWidget {
  const MySalary({super.key});

  @override
  State<MySalary> createState() => _MySalaryState();
}

class _MySalaryState extends State<MySalary> {
  int amount = 1000000; // 금액 변수

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
      insertAddress = '${currentYear}년 ${currentMonth}월';
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
      insertAddress = '${currentYear}년 ${currentMonth}월';
    });
  }

  // 현재 달로 이동하는 함수
  void goToCurrentMonth() {
    setState(() {
      final now = DateTime.now();
      currentYear = now.year; // 현재 년도
      currentMonth = now.month; // 현재 월
      insertAddress = '${currentYear}년 ${currentMonth}월';
    });
  }

  String getQuarterLabel() {
    return '$currentYear년 ${currentMonth}월';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // 화면의 너비
    final screenHeight = MediaQuery.of(context).size.height; // 화면의 높이
    String formattedAmount = NumberFormat('#,###').format(amount);

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
            color: Colors.blueGrey,
            height: screenHeight * 0.8,
            width: screenWidth * 0.9,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _DateControl(
                    onPressLeft: _previousMonth,
                    onPressRight: _nextMonth,
                    onPressGoToday: goToCurrentMonth,
                    currentQuarterLabel: getQuarterLabel(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 60, // 이미지 컨테이너의 너비
                        height: 60, // 이미지 컨테이너의 높이
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          // 이미지의 모서리 둥글기
                          child: Image.asset(
                            'asset/img/salaryLogo.jpg', // 이미지 경로
                            fit: BoxFit.cover, // 이미지 크기 조정
                          ),
                        ),
                      ),
                      // 두 번째 컨테이너: 텍스트
                      Container(
                        height: 40,
                        width: 176,
                        color: Colors.yellow[100], // 연한 노랑 배경
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              '₩', // 동적으로 금액 표시
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.pink,
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              '${formattedAmount.toString()}', // 동적으로 금액 표시
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.pink,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        color: Color(0xFFefefef),
                        width: 70,
                        height: 20,
                        alignment: Alignment.center,
                        // 컨테이너 내에서 중앙 정렬
                        child: Text(
                          'Name',
                          style: TextStyle(
                            color: Colors.black, // 텍스트 색상 (필요에 따라 변경 가능)
                            fontSize: 14, // 텍스트 크기
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center, // 텍스트 중앙 정렬
                        ),
                      ),
                      Container(
                        color: Color(0xFFfff3cc),

                        width: 100,
                        height: 20,
                        alignment: Alignment.center,
                        // 컨테이너 내에서 중앙 정렬
                        child: Text(
                          '염호경',
                          style: TextStyle(
                            color: Colors.black, // 텍스트 색상 (필요에 따라 변경 가능)
                            fontSize: 14, // 텍스트 크기
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center, // 텍스트 중앙 정렬
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        color: Color(0xFFefefef),

                        width: 70,
                        height: 20,
                        alignment: Alignment.center,
                        // 컨테이너 내에서 중앙 정렬
                        child: Text(
                          'Weekday',
                          style: TextStyle(
                            color: Colors.black, // 텍스트 색상 (필요에 따라 변경 가능)
                            fontSize: 14, // 텍스트 크기
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center, // 텍스트 중앙 정렬
                        ),
                      ),
                      Container(
                        color: Color(0xFFfff3cc),

                        width: 100,
                        height: 20,
                        alignment: Alignment.center,
                        // 컨테이너 내에서 중앙 정렬
                        child: Text(
                          '14',
                          style: TextStyle(
                            color: Colors.black, // 텍스트 색상 (필요에 따라 변경 가능)
                            fontSize: 14, // 텍스트 크기
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center, // 텍스트 중앙 정렬
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        color: Color(0xFFefefef),
                        width: 70,
                        height: 20,
                        alignment: Alignment.center,
                        // 컨테이너 내에서 중앙 정렬
                        child: Text(
                          'Date of',
                          style: TextStyle(
                            color: Colors.black, // 텍스트 색상 (필요에 따라 변경 가능)
                            fontSize: 14, // 텍스트 크기
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center, // 텍스트 중앙 정렬
                        ),
                      ),
                      Container(
                        color: Color(0xFFfff3cc),

                        width: 100,
                        height: 20,
                        alignment: Alignment.center,
                        // 컨테이너 내에서 중앙 정렬
                        child: Text(
                          '2023-08-21',
                          style: TextStyle(
                            color: Colors.black, // 텍스트 색상 (필요에 따라 변경 가능)
                            fontSize: 14, // 텍스트 크기
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center, // 텍스트 중앙 정렬
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        color: Color(0xFFefefef),
                        width: 70,
                        height: 20,
                        alignment: Alignment.center,
                        // 컨테이너 내에서 중앙 정렬
                        child: Text(
                          'Weekend',
                          style: TextStyle(
                            color: Colors.black, // 텍스트 색상 (필요에 따라 변경 가능)
                            fontSize: 14, // 텍스트 크기
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center, // 텍스트 중앙 정렬
                        ),
                      ),
                      Container(
                        color: Color(0xFFfff3cc),

                        width: 100,
                        height: 20,
                        alignment: Alignment.center,
                        // 컨테이너 내에서 중앙 정렬
                        child: Text(
                          '8',
                          style: TextStyle(
                            color: Colors.black, // 텍스트 색상 (필요에 따라 변경 가능)
                            fontSize: 14, // 텍스트 크기
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center, // 텍스트 중앙 정렬
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        color: Color(0xFFd0dfe2),
                        width: 176,
                        height: 30,
                        alignment: Alignment.center,
                        // 컨테이너 내에서 중앙 정렬
                        child: Text(
                          'Payment',
                          style: TextStyle(
                            color: Colors.black, // 텍스트 색상 (필요에 따라 변경 가능)
                            fontSize: 14, // 텍스트 크기
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center, // 텍스트 중앙 정렬
                        ),
                      ),
                      Container(
                        color: Color(0xFFd0dfe2),
                        width: 176,
                        height: 30,
                        alignment: Alignment.center,
                        // 컨테이너 내에서 중앙 정렬
                        child: Text(
                          'Extra',
                          style: TextStyle(
                            color: Colors.black, // 텍스트 색상 (필요에 따라 변경 가능)
                            fontSize: 14, // 텍스트 크기
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center, // 텍스트 중앙 정렬
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 176,
                        height: 340,
                        color: Colors.purple,
                        child: Column(
                          children: [
                            Divider(
                              color: Colors.white, // 선 색상
                              thickness: 1.0, // 선 두께
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 176,
                        height: 340,
                        color: Colors.purple,
                        child: Column(
                          children: [],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white, // 배경색 (필요하면 조정)
        padding: const EdgeInsets.all(8.0), // 여백 설정
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // 이미지 가운데 정렬
          children: [
            Image.asset(
              'asset/img/huskybottom.jpg', // 이미지 경로
              height: 60, // 이미지 높이
              width: 200, // 이미지 너비
              fit: BoxFit.contain, // 이미지 크기 조정
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
