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
  int totalCount = 0; // 파베에 31일중 몇개가 인트값인지확인
  int weekDayCount = 0; //평일이 몇개인지확인용
  int weekEndCount = 0; //주말이 몇개인지확인용
  int maxEnterValue = 0; //한명추가시 최근enterDay값 추출해서 제일큰숫자 추출해서 넣음
  String addName = ''; //스케줄에 한명추가시 넣을이름
/////////////////////////////////////// 여기까지
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Center(child: Text('스케줄 설정'))),
            GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Center(child: Text('초기화 시키겠습니까?')),
                        content: Container(
                          constraints: BoxConstraints(
                            maxHeight: 120, // 최대 높이 설정
                          ),
                          child: Center(
                            child: Text(
                              '모든 멤버 스케줄이 초기화됩니다.\n(되돌릴 수 없습니다, 조심해야 해요)',
                              style: TextStyle(
                                fontSize: 16, // 텍스트 크기
                                fontWeight: FontWeight.w500, // 텍스트 굵기
                                color: Colors.black87, // 텍스트 색상
                                letterSpacing: 1.2, // 글자 간격
                              ),
                              textAlign: TextAlign.center, // 중앙 정렬
                            ),
                          ),
                        ),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop(); // 팝업 닫기

                                  try {
                                    QuerySnapshot querySnapshot =
                                        await FirebaseFirestore.instance
                                            .collection('insa')
                                            .doc(widget.teamId)
                                            .collection('list')
                                            .orderBy('enterDay')
                                            .get();

                                    querySnapshot.docs.forEach((doc) async {
                                      String name = doc['name']; // 'name' 필드 추출
                                      String userId = doc.id; // 'name' 필드 추출

                                      print(name); // 콘솔에 출력
                                      print(userId); // 콘솔에 출력
                                      enter++;

                                      await FirebaseFirestore.instance
                                          .collection('insa')
                                          .doc(widget.teamId)
                                          .collection('schedule')
                                          .doc('1EjNGZtze07iY1WJKyvh')
                                          .collection(
                                              '$_currentYear$_currentMonth')
                                          .doc(userId)
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
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  // 배경색을 빨간색으로 설정
                                  primary: Colors.white,
                                  // 텍스트 색상을 흰색으로 설정
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 12),
                                  // 버튼의 패딩 조정
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12), // 둥근 모서리
                                  ),
                                ),
                                child: Text(
                                  '초기화하기',
                                  style: TextStyle(
                                    fontSize: 16, // 텍스트 크기
                                    fontWeight: FontWeight.bold, // 텍스트 굵게
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // 팝업 닫기
                                  print('취소 버튼 클릭됨');
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  // 배경색을 회색으로 설정
                                  primary: Colors.black,
                                  // 텍스트 색상을 검정색으로 설정
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 12),
                                  // 버튼의 패딩 조정
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12), // 둥근 모서리
                                  ),
                                ),
                                child: Text(
                                  '취소하기',
                                  style: TextStyle(
                                    fontSize: 16, // 텍스트 크기
                                    fontWeight: FontWeight.bold, // 텍스트 굵게
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('초기화')),
          ],
        ),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
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
                  height: 670,
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
                                        GestureDetector(
                                          onTap: () {
                                            scheduleDocument = '${schedule.id}';
                                            selectedName =
                                                '${schedule['name']}';
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return deleteName();
                                              },
                                            );
                                          },
                                          child: Text(
                                            '${schedule['name']}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              // Adjusted font size
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 7,
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
                                          GestureDetector(
                                            onTap: () {
                                              // 여기에서 실행할 코드를 넣습니다.
                                              scheduleDocument =
                                                  '${schedule.id}';
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
                                                builder:
                                                    (BuildContext context) {
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
                                            height: 7,
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
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: bottomOneBar(),
    );
  }

  Widget addMember() {
    return AlertDialog(
      title: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              inputFormatters: [],
              maxLength: 3,
              decoration: InputDecoration(
                hintText: '이름 3자까지가능',
              ),
              onChanged: (value) {
                addName = value;
              },
            ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                        onPressed: () async {
                          try {
                            await FirebaseFirestore.instance
                                .collection('insa')
                                .doc(widget.teamId)
                                .collection('schedule')
                                .doc('1EjNGZtze07iY1WJKyvh')
                                .collection('$_currentYear$_currentMonth')
                                .doc()
                                .set({
                              'enter': maxEnterValue + 1,
                              'name': addName,
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
                            Navigator.pop(context);
                          } catch (e) {
                            print("추가하기 오류: $e");
                          }
                        },
                        child: Text('등록'))),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('취소'))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomOneBar() {
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
            width: 10,
          ),
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle:
                      TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                ),
                onPressed: () async {
                  try {
                    QuerySnapshot querySnapshot = await FirebaseFirestore
                        .instance
                        .collection('insa')
                        .doc(widget.teamId)
                        .collection('schedule')
                        .doc('1EjNGZtze07iY1WJKyvh')
                        .collection('$_currentYear$_currentMonth')
                        .get();

                    int maxValue = querySnapshot.docs
                        .map((doc) => doc['enter'] as int)
                        .reduce((value, element) =>
                            value > element ? value : element);
                    maxEnterValue = maxValue;
                    print(maxEnterValue);
                    print(maxEnterValue);
                    print(maxEnterValue);
                  } catch (e) {
                    print("최대 숫자 값구하기오류: $e");
                  }

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return addMember();
                    },
                  );
                },
                child: Text('추가'),
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

  Widget deleteName() {
    return AlertDialog(
      title: SingleChildScrollView(
        child: Column(
          children: [
            Text('$selectedName'),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                            .delete();

                        print('삭제성공.');

                        Navigator.pop(context);
                      } catch (e) {
                        print('문서 삭제 오류: $e');
                      }
                    },
                    child: Text('삭제하기')),
                SizedBox(
                  width: 30,
                ),
                ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Text('취소')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget changeSchedule() {
    return AlertDialog(
      title: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          '$selectedDay': 12, // 업데이트할 필드와 값
                        });
                        print('문서 업데이트가 성공했습니다.');

                        Navigator.pop(context);
                      } catch (e) {
                        print('문서 업데이트 오류: $e');
                      }
                    },
                    child: Text('12시')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          ],
        ),
      ),
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
