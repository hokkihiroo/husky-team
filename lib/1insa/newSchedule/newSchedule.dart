import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late int _currentYear;
  late int _currentMonth;
  bool _isFirstHalf = true;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentYear = now.year;
    _currentMonth = now.month;
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
    final days = _isFirstHalf ? List.generate(15, (index) => index + 1) : List.generate(lastDay - 15, (index) => index + 16);

    return Scaffold(
      appBar: AppBar(
        title: Text('스케쥴'),
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
                  '$_currentYear년 $_currentMonth월 ${_isFirstHalf ? '상' : '하'}',
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
                stream: FirebaseFirestore.instance.collection('schedules').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
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
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '  이름',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          for (var day in days)
                            Container(
                              width: MediaQuery.of(context).size.width / 16,
                              padding: EdgeInsets.all(3.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    getWeekday(day),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isHoliday(day) ? Colors.blue : getWeekdayColor(day),
                                    ),
                                  ),
                                  SizedBox(height: 7.0),
                                  Text(
                                    '$day',
                                    style: TextStyle(
                                      fontSize: 12, // Adjusted font size
                                      color: isHoliday(day) ? Colors.blue : getWeekdayColor(day),
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
        ],
      ),
    );
  }
}
