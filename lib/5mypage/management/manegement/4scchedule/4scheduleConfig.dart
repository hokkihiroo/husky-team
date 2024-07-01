import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleConfig extends StatefulWidget {
  final String teamId;

  const ScheduleConfig({super.key, required this.teamId});

  @override
  State<ScheduleConfig> createState() => _ScheduleConfigState();
}

class _ScheduleConfigState extends State<ScheduleConfig> {
  late int _currentYear;
  late int _currentMonth;
  late bool _isFirstHalf;
  int enter = 0; //스케줄에서 인원 추가할때 순서정하려고 만든숫자

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
    if (weekday == '토' || weekday == '일') {
      return Colors.red;
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
        title: Text('스케줄 설정'),
        centerTitle: true,
      ),
      body: Column(
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('insa')
                    .doc(widget.teamId)
                    .collection('schedule')
                    .doc('1EjNGZtze07iY1WJKyvh')
                    .collection('$_currentYear$_currentMonth')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
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

                  final schedules = snapshot.data!.docs;

                  return ListView(
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
                                for (var schedule in schedules)
                                  Text(
                                    '${schedule['name']}',
                                    style: TextStyle(
                                      fontSize: 12, // Adjusted font size
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                SizedBox(height: 4.0),
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
                                          ? Colors.blue
                                          : getWeekdayColor(day),
                                    ),
                                  ),
                                  SizedBox(height: 7.0),
                                  Text(
                                    getWeekday(day),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isHoliday(day)
                                          ? Colors.blue
                                          : getWeekdayColor(day),
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  for (var schedule in schedules)
                                    GestureDetector(
                                      onTap: () {
                                        // 여기에서 실행할 코드를 넣습니다.
                                        print(
                                            'Schedule tapped: ${schedule['$day']}');
                                      },
                                      child: Text(
                                        '${schedule['$day']}',
                                        style: TextStyle(
                                          fontSize: 12, // Adjusted font size
                                        ),
                                      ),
                                    ),
                                  SizedBox(height: 4.0),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () async {
                  try {
                    QuerySnapshot querySnapshot = await FirebaseFirestore
                        .instance
                        .collection('insa')
                        .doc(widget.teamId)
                        .collection('list')
                        .orderBy('enterDay')
                        .get();

                    querySnapshot.docs.forEach((doc) async {
                      String name = doc['name']; // 'name' 필드 추출
                      print(name); // 콘솔에 출력
                      enter++;

                      await FirebaseFirestore.instance
                          .collection('insa')
                          .doc(widget.teamId)
                          .collection('schedule')
                          .doc('1EjNGZtze07iY1WJKyvh')
                          .collection('$_currentYear$_currentMonth')
                          .doc()
                          .set({
                        'enter': enter,
                        'name': name,
                        '1': 'X',
                        '2': 'X',
                        '3': 'X',
                        '4': 'X',
                        '5': 'X',
                        '6': 'X',
                        '7': 'X',
                        '8': 'X',
                        '9': 'X',
                        '10': 'X',
                        '11': 'X',
                        '12': 'X',
                        '13': 'X',
                        '14': 'X',
                        '15': 'X',
                        '16': 'X',
                        '17': 'X',
                        '18': 'X',
                        '19': 'X',
                        '20': 'X',
                        '21': 'X',
                        '22': 'X',
                        '23': 'X',
                        '24': 'X',
                        '25': 'X',
                        '26': 'X',
                        '27': 'X',
                        '28': 'X',
                        '29': 'X',
                        '30': 'X',
                        '31': 'X',
                      });
                    });
                  } catch (e) {
                    print("Error getting data: $e");
                  }
                  enter = 0;
                },
                child: Text('$_currentMonth월 인원추가하기'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
