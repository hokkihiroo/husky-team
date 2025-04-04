import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:team_husky/1insa/newSchedule/nameCard.dart';

class SchedulePage extends StatefulWidget {
  final String teamId;

  const SchedulePage({super.key, required this.teamId});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late int _currentYear;
  late int _currentMonth;
  late bool _isFirstHalf;

  int totalCount = 0; // 파베에 31일중 몇개가 인트값인지확인
  int weekDayCount = 0; //평일이 몇개인지확인용
  int weekEndCount = 0; //주말이 몇개인지확인용

  List<QueryDocumentSnapshot<Map<String, dynamic>>> globalSchedules = [];
  List<int> numericTotals = []; //인트값 돌려서 여기에 담음 1부터31까지 숫자로되어있는거 전부담음
  List<int> numericWeekdays = []; //1부터 31까지 평일인거 담음
  List<int> numericWeekends = []; //1부터 31까지 주말담음
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentYear = now.year;
    _currentMonth = now.month;
    _isFirstHalf = now.day <= 15;
  }

  void _navigateToPreviousMonth() {
    setState(() {
      if (_isFirstHalf) {
        if (_currentMonth == 1) {
          _currentYear--;
          _currentMonth = 12;
        } else {
          _currentMonth--;
        }
        _isFirstHalf = false;
      } else {
        _isFirstHalf = true;
      }
    });
  }

  void _navigateToNextMonth() {
    final now = DateTime.now();
    setState(() {
      if (_isFirstHalf) {
        _isFirstHalf = false;
      } else {
        if (_currentMonth == 12) {
          _currentYear++;
          _currentMonth = 1;
        } else {
          _currentMonth++;
        }
        _isFirstHalf = true;
      }
    });
  }

  String getWeekday(int day) {
    final date = DateTime(_currentYear, _currentMonth, day);
    final weekday = DateFormat('E', 'ko_KR').format(date);
    return weekday;
  }

  Color getWeekdayColor(int day) {
    final date = DateTime(_currentYear, _currentMonth, day);
    final weekday = DateFormat('E', 'ko_KR').format(date);
    if (weekday == '일') {
      return Colors.red;
    } else if (weekday == '토') {
      return Colors.blue;
    } else {
      return Colors.black;
    }
  }

  bool isHoliday(int day) {
    final holidays = [
      DateTime(_currentYear, 1, 1), // New Year's Day
      DateTime(_currentYear, 3, 1), // Independence Movement Day
      DateTime(_currentYear, 5, 5), // Children's Day
      DateTime(_currentYear, 6, 6), // Memorial Day
      DateTime(_currentYear, 8, 15), // Liberation Day
      DateTime(_currentYear, 10, 3), // National Foundation Day
      DateTime(_currentYear, 10, 9), // Hangul Proclamation Day
      DateTime(_currentYear, 12, 25), // Christmas
      // Add other holidays here
    ];
    return holidays.contains(DateTime(_currentYear, _currentMonth, day));
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final lastDay = DateTime(_currentYear, _currentMonth + 1, 0).day;
    final days = _isFirstHalf
        ? List.generate(15, (index) => index + 1)
        : List.generate(lastDay - 15, (index) => index + 16);

    return Scaffold(
      appBar: AppBar(
        title: Text('스케줄'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('insa')
            .doc(widget.teamId)
            .collection('schedule')
            .doc('1EjNGZtze07iY1WJKyvh')
            .collection('$_currentYear$_currentMonth')
            .orderBy('levelNumber')
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: Text('No data found'),
            );
          }

          globalSchedules = snapshot.data!.docs;

          List<int> dayss = List.generate(31, (index) => index + 1);
          List<int> numericTotal = []; //인트값 돌려서 여기에 담음 1부터31까지 숫자로되어있는거 전부담음
          List<int> numericWeekday = []; //1부터 31까지 평일인거 담음
          List<int> numericWeekend = []; //1부터 31까지 주말담음

          for (var schedule in globalSchedules) {
            for (var day in dayss) {
              var value = schedule['$day'];
              if (value is int) {
                totalCount++;
                String yoil = getWeekday(day);
                if (['월', '화', '수', '목', '금'].contains(yoil)) {
                  weekDayCount++;
                }
                if (['토', '일'].contains(yoil)) {
                  weekEndCount++;
                }
              }
            }
            numericTotal.add(totalCount);
            numericWeekday.add(weekDayCount);
            numericWeekend.add(weekEndCount);

            totalCount = 0;
            weekDayCount = 0;
            weekEndCount = 0;
          }

          numericTotals = numericTotal;
          numericWeekdays = numericWeekday;
          numericWeekends = numericWeekend;

          for (int number in numericTotal) {
            print('Element: $number');
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                _ControlFirst(
                  navigateToPreviousMonth: _navigateToPreviousMonth,
                  navigateToNextMonth: _navigateToNextMonth,
                  currentYear: _currentYear,
                  currentMonth: _currentMonth,
                  isFirstHalf: _isFirstHalf,
                ),
                Container(
                  height: 550,
                  width: MediaQuery.of(context).size.width,
                  child: SafeArea(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        SizedBox(
                          width: 4,
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(3.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ' $_currentMonth월',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 7.0),
                                  Text(
                                    '이름',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  for (var schedule in globalSchedules)
                                    Column(
                                      children: [
                                        Text(
                                          '${schedule['name']}',
                                          style: TextStyle(
                                            fontSize: 12, // Adjusted font size
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                            for (var day in days)
                              Container(
                                width: MediaQuery.of(context).size.width / 17,
                                padding: EdgeInsets.all(3.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$day',
                                      style: TextStyle(
                                        fontSize: 12, // Adjusted font size
                                        color: isHoliday(day)
                                            ? Colors.red
                                            : getWeekdayColor(day),
                                      ),
                                    ),
                                    SizedBox(height: 7.0),
                                    Text(
                                      getWeekday(day),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isHoliday(day)
                                            ? Colors.red
                                            : getWeekdayColor(day),
                                      ),
                                    ),
                                    SizedBox(height: 4.0),
                                    for (var schedule in globalSchedules)
                                      Column(
                                        children: [
                                          Text(
                                            '${schedule['$day']}',
                                            style: TextStyle(
                                              fontSize:
                                                  12, // Adjusted font size
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: bottomOne(),
    );
  }

  Widget bottomOne() {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 5,
          ),
          Expanded(
            flex: 3,
            child: SizedBox(
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle:
                      TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('개인별 근무일수'),
                        content: SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: globalSchedules.map((value) {
                                      return Column(
                                        children: [
                                          Text(
                                            '${value['name']}',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 6),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                  SizedBox(width: 16),
                                  Column(
                                    children: numericTotals.map((value) {
                                      return Column(
                                        children: [
                                          Text(
                                            '총: $value일',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                  SizedBox(width: 16),
                                  Column(
                                    children: numericWeekdays.map((value) {
                                      return Column(
                                        children: [
                                          Text(
                                            '평일: $value일',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                  SizedBox(width: 16),
                                  Column(
                                    children: numericWeekends.map((value) {
                                      return Column(
                                        children: [
                                          Text(
                                            '주말: $value일',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // 팝업 닫기
                                },
                                child: Text('취소'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // 팝업 닫기
                                  // 여기에 확인 버튼 클릭 시 실행할 코드를 추가하세요.
                                  print('확인 버튼 클릭됨');
                                },
                                child: Text('확인'),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('개인별 근무일수 확인'),
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
        ],
      ),
      color: Colors.white,
    );
  }
}

class _ControlFirst extends StatelessWidget {
  final VoidCallback navigateToPreviousMonth;
  final VoidCallback
      navigateToNextMonth; // 추가: _navigateToNextMonth도 final로 선언해야 합니다.
  final int currentYear;
  final int currentMonth;
  final bool isFirstHalf;

  const _ControlFirst({
    super.key,
    required this.navigateToPreviousMonth,
    required this.navigateToNextMonth, // 추가: 생성자에 _navigateToNextMonth 추가
    required this.currentYear, // 추가: 생성자에 _currentYear 추가
    required this.currentMonth, // 추가: 생성자에 _currentMonth 추가
    required this.isFirstHalf, // 추가: 생성자에 _isFirstHalf 추가
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(Icons.arrow_back),
            onPressed: navigateToPreviousMonth,
          ),
          SizedBox(width: 4.0),
          Text(
            '$currentYear년 $currentMonth월 ${isFirstHalf ? '상반기' : '하반기'}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 4.0),
          IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(Icons.arrow_forward),
            onPressed: navigateToNextMonth,
          ),
        ],
      ),
    );
  }
}
