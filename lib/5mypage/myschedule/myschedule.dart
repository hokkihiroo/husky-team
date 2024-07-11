import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MySchedule extends StatefulWidget {
  String team;

  String uid;

  MySchedule({super.key, required this.team, required this.uid});

  @override
  State<MySchedule> createState() => _MyScheduleState();
}

class _MyScheduleState extends State<MySchedule> {
  late int _currentYear;
  late int _currentMonth;
  late bool _isFirstHalf;

  int totalCount = 0; // 파베에 31일중 몇개가 인트값인지확인
  int weekDayCount = 0; //평일이 몇개인지확인용
  int weekEndCount = 0; //주말이 몇개인지확인용

  String scheduleTime = ''; // 누른 날짜의 출근시각
  String selectedDay = ''; // 선택된 날짜

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('나의 스케줄'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('insa')
            .doc(widget.team)
            .collection('schedule')
            .doc('1EjNGZtze07iY1WJKyvh')
            .collection('$_currentYear$_currentMonth')
            .doc('${widget.uid}')
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Column(
              children: [
                Center(
                  child: Text('선택한 날짜에 스케줄은 열리지 않았습니다 '),
                ),
                SizedBox(height: 50,),
                ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    child: Text(
                    '돌아가기'),),
              ],
            );
          }

          var document = snapshot.data!;

          List<int> dayss = List.generate(31, (index) => index + 1);
          List<int> numericTotal = []; //인트값 돌려서 여기에 담음 1부터31까지 숫자로되어있는거 전부담음
          List<int> numericWeekday = []; //1부터 31까지 평일인거 담음
          List<int> numericWeekend = []; //1부터 31까지 주말담음

          for (var day in dayss) {
            var value = document['$day'];
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

          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.arrow_back),
                      onPressed: _navigateToPreviousMonth,
                    ),
                    SizedBox(width: 4.0),
                    Text(
                      '$_currentYear년 $_currentMonth월 ${_isFirstHalf ? '상반기' : '하반기'}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 4.0),
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.arrow_forward),
                      onPressed: _navigateToNextMonth,
                    ),
                  ],
                ),
              ),
              Expanded(
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
                                Text(
                                  '${document['name']}',
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
                                  GestureDetector(
                                    onTap: () {
                                      scheduleTime = '${document['$day']}';
                                      selectedDay = '$day';
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return changeSchedule();
                                        },
                                      );
                                    },
                                    child: Text(
                                      '${document['$day']}',
                                      style: TextStyle(
                                        fontSize: 12, // Adjusted font size
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${document['name']}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 16),
                  Text(
                    '총: ${numericTotal[0]}일',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 16),
                  Text(
                    '평일: ${numericWeekday[0]}일',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 16),
                  Text(
                    '주말: ${numericWeekend[0]}일',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget changeSchedule() {
    return AlertDialog(
      title: Column(
        children: [
          Text('선택한 날짜: $selectedDay'),
          Text('현재상태: $scheduleTime'),
        ],
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('insa')
                      .doc('${widget.team}')
                      .collection('schedule')
                      .doc('1EjNGZtze07iY1WJKyvh')
                      .collection('$_currentYear$_currentMonth')
                      .doc('${widget.uid}')
                      .update({
                    '$selectedDay': '-', // 업데이트할 필드와 값
                  });
                  print('문서 업데이트가 성공했습니다.');

                  Navigator.pop(context);
                } catch (e) {
                  print('문서 업데이트 오류: $e');
                }
              },
              child: Text('근무 불가')),
          ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: Text('취소')),
        ],
      ),
    );
  }
}
