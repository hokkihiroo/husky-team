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
///////////////////////////////////////    개별업데이트시 필요한 내용
  String scheduleDocument = ''; //스케줄별 문서이름
  String scheduleTime = ''; // 누른 날짜의 출근시각
  String selectedDay = ''; // 선택된 날짜
  String selectedName = ''; // 선택된 이름
  int count = 0; // 파베에 31일중 몇개가 인트값인지확인
/////////////////////////////////////// 여기까지

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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('insa')
            .doc(widget.teamId)
            .collection('schedule')
            .doc('1EjNGZtze07iY1WJKyvh')
            .collection('$_currentYear$_currentMonth')
            .orderBy('enter')
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

          final schedules = snapshot.data!.docs;

          List<int> dayss = List.generate(31, (index) => index + 1);
          List<int> numericData = []; //인트값 돌려서 여기에 담음

          for (var schedule in schedules) {
            for (var day in dayss) {
              var value = schedule['$day'];
              if (value is int) {
                count++;
              }
            }
            numericData.add(count);
            count = 0;
          }

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
                                for (var schedule in schedules)
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
                                    Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            // 여기에서 실행할 코드를 넣습니다.
                                            scheduleDocument = '${schedule.id}';
                                            scheduleTime =
                                                '${schedule['$day']}';
                                            selectedDay = '$day';
                                            selectedName =
                                                '${schedule['name']}';
                                            print('$_currentMonth월 이고');
                                            print('문서이름은 $scheduleDocument');
                                            print('출근시각은 $scheduleTime시');
                                            print('날짜는 $selectedDay일');
                                            print('이름은 $selectedName');

                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return changeSchedule();
                                              },
                                            );
                                          },
                                          child: Text(
                                            '${schedule['$day']}',
                                            style: TextStyle(
                                              fontSize:
                                                  12, // Adjusted font size
                                            ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: schedules.map((value) {
                      return Column(
                        children: [
                          Text(
                            '${value['name']}',
                            style: TextStyle(
                              fontSize: 15,
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
                    children: numericData.map((value) {
                      return Column(
                        children: [
                          Text(
                            '$value ',
                            style: TextStyle(
                              fontSize: 15,
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
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
          );
        },
      ),
    );
  }

  Widget changeSchedule() {
    return AlertDialog(
      title: Column(
        children: [
          ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('insa')
                      .doc('${widget.teamId}')
                      .collection('schedule')
                      .doc('1EjNGZtze07iY1WJKyvh')
                      .collection('$_currentYear$_currentMonth')
                      .doc('$scheduleDocument')
                      .update({
                    '$selectedDay': 8, // 업데이트할 필드와 값
                  });
                  print('문서 업데이트가 성공했습니다.');

                  Navigator.pop(context);
                } catch (e) {
                  print('문서 업데이트 오류: $e');
                }
              },
              child: Text('8시')),
          ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('insa')
                      .doc('${widget.teamId}')
                      .collection('schedule')
                      .doc('1EjNGZtze07iY1WJKyvh')
                      .collection('$_currentYear$_currentMonth')
                      .doc('$scheduleDocument')
                      .update({
                    '$selectedDay': 9, // 업데이트할 필드와 값
                  });
                  print('문서 업데이트가 성공했습니다.');

                  Navigator.pop(context);
                } catch (e) {
                  print('문서 업데이트 오류: $e');
                }
              },
              child: Text('9시')),
          ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('insa')
                      .doc('${widget.teamId}')
                      .collection('schedule')
                      .doc('1EjNGZtze07iY1WJKyvh')
                      .collection('$_currentYear$_currentMonth')
                      .doc('$scheduleDocument')
                      .update({
                    '$selectedDay': 10, // 업데이트할 필드와 값
                  });
                  print('문서 업데이트가 성공했습니다.');

                  Navigator.pop(context);
                } catch (e) {
                  print('문서 업데이트 오류: $e');
                }
              },
              child: Text('10시')),
          ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('insa')
                      .doc('${widget.teamId}')
                      .collection('schedule')
                      .doc('1EjNGZtze07iY1WJKyvh')
                      .collection('$_currentYear$_currentMonth')
                      .doc('$scheduleDocument')
                      .update({
                    '$selectedDay': 11, // 업데이트할 필드와 값
                  });
                  print('문서 업데이트가 성공했습니다.');

                  Navigator.pop(context);
                } catch (e) {
                  print('문서 업데이트 오류: $e');
                }
              },
              child: Text('11시')),
          ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('insa')
                      .doc('${widget.teamId}')
                      .collection('schedule')
                      .doc('1EjNGZtze07iY1WJKyvh')
                      .collection('$_currentYear$_currentMonth')
                      .doc('$scheduleDocument')
                      .update({
                    '$selectedDay': 12, // 업데이트할 필드와 값
                  });
                  print('문서 업데이트가 성공했습니다.');

                  Navigator.pop(context);
                } catch (e) {
                  print('문서 업데이트 오류: $e');
                }
              },
              child: Text('12시')),
          ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('insa')
                      .doc('${widget.teamId}')
                      .collection('schedule')
                      .doc('1EjNGZtze07iY1WJKyvh')
                      .collection('$_currentYear$_currentMonth')
                      .doc('$scheduleDocument')
                      .update({
                    '$selectedDay': 'X', // 업데이트할 필드와 값
                  });
                  print('문서 업데이트가 성공했습니다.');

                  Navigator.pop(context);
                } catch (e) {
                  print('문서 업데이트 오류: $e');
                }
              },
              child: Text('X')),
        ],
      ),
    );
  }
}
