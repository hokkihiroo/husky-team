import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:table_calendar/table_calendar.dart';

import 'team2_adress_const.dart';
import 'team2_car_card.dart';

class CarList extends StatefulWidget {
  const CarList({super.key});

  @override
  State<CarList> createState() => _CarListState();
}

class _CarListState extends State<CarList> {
  DateTime selectedDate = DateTime.now();
  String DBAdress = formatTodayDate();

// -------------------------------------------------------------
  DateTime _focusedDay = DateTime.now(); // 이부분은 날짜 선택에 대한 변수라 손대지말자
  DateTime? _selectedDay;

  //어제로 이동
  void _previousDay() {
    final goToOneDayAgo = selectedDate.subtract(Duration(days: 1));
    final year = goToOneDayAgo.year.toString();
    final month = goToOneDayAgo.month.toString().padLeft(2, '0');
    final day = goToOneDayAgo.day.toString().padLeft(2, '0');
    setState(() {
      selectedDate = goToOneDayAgo;
      DBAdress = year + month + day;
    });
  }

  //다음날로 이동
  void _nextDay() {
    final today = DateTime.now();
    final nextDay = selectedDate.add(Duration(days: 1));
    final year = nextDay.year.toString();
    final month = nextDay.month.toString().padLeft(2, '0');
    final day = nextDay.day.toString().padLeft(2, '0');

    setState(() {
      if (nextDay.isBefore(today)) {
        setState(() {
          selectedDate = nextDay;
          DBAdress = year + month + day;
        });
      }
    });
  }

  //원하는 날짜로 이동
  void goToday() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("날짜 선택"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Container(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("이동할 날짜를 선택하세요."),
                      SizedBox(height: 12),
                      SizedBox(
                        height: 400, // ✅ 고정 높이로 설정 (이게 핵심!)
                        child: TableCalendar(
                          locale: 'ko_KR',
                          firstDay: DateTime.utc(2000, 1, 1),
                          lastDay: DateTime.utc(2100, 12, 31),
                          focusedDay: _focusedDay,
                          selectedDayPredicate: (day) =>
                              isSameDay(_selectedDay, day),
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });
                          },
                          calendarStyle: CalendarStyle(
                            todayDecoration: BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                            selectedDecoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            weekendTextStyle: TextStyle(color: Colors.red),
                          ),
                          headerStyle: HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: Text("선택한 날짜로 이동"),
                  onPressed: () {
                    if (selectedDate != null) {
                      setState(() {
                        selectedDate = _selectedDay!;
                        final year = selectedDate.year.toString();
                        final month =
                            selectedDate.month.toString().padLeft(2, '0');
                        final day = selectedDate.day.toString().padLeft(2, '0');
                        DBAdress = year + month + day;
                        Navigator.of(context).pop();
                      });
                    }
                  },
                ),
                TextButton(
                  child: Text("취소"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // 텍스트 만드는 함수 추가
  Future<String> createClipboardText(String address) async {
    final query = await FirebaseFirestore.instance
        .collection(CARLIST + address)
        .orderBy('enter')
        .get();

    final count = query.docs.length;

    final buffer = StringBuffer();
    buffer.writeln('날짜: $address (총 $count대)');
    buffer.writeln('-----------------------------');

    for (int i = 0; i < count; i++) {
      final doc = query.docs[i];
      final carNum = doc['carNumber'];
      final brand = doc['carBrand'];
      final model = doc['carModel'];
      final etc = doc['etc'];
      final enter = getInTime(doc['enter']);
      final out = doc['out'] is Timestamp
          ? getOutTime((doc['out'] as Timestamp).toDate())
          : '---';

      buffer.writeln('(${i + 1}) $brand $model $carNum $enter $out');

      //
      // buffer.writeln('(${i + 1})');
      // buffer.writeln('브랜드: $brand');
      // buffer.writeln('차종: $model');
      // buffer.writeln('차량번호: $carNum');
      // buffer.writeln('입차: $enter / 출차: $out');
      // buffer.writeln('특이사항: $etc ');
      // buffer.writeln('');
    }

    return buffer.toString();
  }

  int selectedTab = 0; // 0=고객차, 1=시승차

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 고객차 버튼
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedTab = 0;
                });
              },
              child: Text(
                '고객차',
                style: TextStyle(
                  color: selectedTab == 0 ? Colors.white : Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(width: 20),

            // 시승차 버튼
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedTab = 1;
                });
              },
              child: Text(
                '시승차',
                style: TextStyle(
                  color: selectedTab == 1 ? Colors.white : Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.copy),
            onPressed: () async {
              final text = await createClipboardText(DBAdress);
              Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('고객차 텍스트만 복사되었습니다!')),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _DateControl(
              onPressLeft: _previousDay,
              onPressRight: _nextDay,
              onPressGoToday: goToday,
              selectedDate: selectedDate,
            ),
            // 🔥 selectedTab 값에 따라 다른 위젯 적용
            selectedTab == 0 ? _ListState() : _Color5State(),

// 기존 ListModel 유지
            ListModel(
              adress: DBAdress,
              selectedTab: selectedTab,
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
  final DateTime selectedDate;

  const _DateControl(
      {super.key,
      required this.onPressLeft,
      required this.onPressRight,
      required this.onPressGoToday,
      required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            Icons.chevron_left_outlined,
            color: Colors.white,
          ),
          onPressed: onPressLeft,
        ),
        Text(
          "${selectedDate.toLocal()}".split(' ')[0],
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        SizedBox(
          width: 2,
        ),
        Text(
          getWeeks(selectedDate.weekday),
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        IconButton(
          icon: Icon(
            Icons.chevron_right_outlined,
            color: Colors.white,
          ),
          onPressed: onPressRight,
        ),
        SizedBox(
          width: 20,
        ),
        GestureDetector(
          onTap: onPressGoToday,
          child: Text(
            '날짜선택',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
}

class _ListState extends StatelessWidget {
  const _ListState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        height: 40,
        color: Colors.grey.shade800,
        child: Row(
          children: [
            _buildHeaderCell(width: 40, label: '번호'),
            _buildHeaderCell(width: 70, label: '브랜드'),
            _buildHeaderCell(width: 60, label: '차종'),
            _buildHeaderCell(width: 60, label: '차량번호'),
            _buildHeaderCell(width: 60, label: '입차'),
            _buildHeaderCell(width: 60, label: '출차'),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell({required double width, required String label}) {
    return Container(
      width: width,
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _Color5State extends StatelessWidget {
  const _Color5State({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        height: 40,
        color: Colors.grey.shade800,
        child: Row(
          children: [
            _buildHeaderCell(width: 40, label: '번호'),
            _buildHeaderCell(width: 60, label: '차종'),
            _buildHeaderCell(width: 70, label: '차량번호'),
            _buildHeaderCell(width: 60, label: '스탠바이'),
            _buildHeaderCell(width: 60, label: '시승출발'),
            _buildHeaderCell(width: 60, label: '시승종료'),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell({required double width, required String label}) {
    return Container(
      width: width,
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ListModel extends StatelessWidget {
  final String adress;
  final int selectedTab;
  String dataId = '';
  String carNumber = '';
  String enterTime = '';
  String enterName = '';
  String etc = '';
  DateTime? outTime;
  DateTime dateTime2 = DateTime.now(); //이동할 시각들 뽑음
  String outName = '';
  String outLocation = '';
  String movedLocation = '';
  String movingTime = '';
  String selfParking = '';
  String movingTimeForTabOne = '';

  ListModel({super.key, required this.adress, required this.selectedTab});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection((selectedTab == 0 ? CARLIST : COLOR5) + adress)
          .orderBy('enter')
          .snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final docs = snapshot.data!.docs;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: GestureDetector(
                onTap: () async {
                  var document = docs[index];
                  print(document.id);
                  dataId = document.id;
                  carNumber = docs[index]['carNumber'];
                  Timestamp sam = docs[index]['enter']; //입차시각
                  enterTime = getInTime(sam); //입차시각 변환코드
                  enterName = docs[index]['wigetName']; //입차한사람 이름
                  selfParking = docs[index]
                      ['enterName']; // 자가주차하면 enterName으로 들어간데이터가 여기에 저장됨
                  etc = docs[index]['etc']; //특이사항

                  outTime = docs[index]['out'] is Timestamp
                      ? (docs[index]['out'] as Timestamp).toDate()
                      : null;

                  String outname = docs[index]['outName']; //출차한사람 이름
                  if (outname == null) {
                    outName = '';
                  } else {
                    outName = outname;
                  }
                  int location = docs[index]['outLocation']; //출차한위치 이름
                  outLocation = checkOutLocation(location);

                  movedLocation = docs[index]['movedLocation']; //출차한위치 이름


                  final raw = docs[index]['movingTime'];
                  movingTime = raw is Timestamp
                      ? movingTimeGet(raw.toDate())
                      : '';

                  if (selectedTab == 0) {
                    showCarInfoBottomSheet(
                      context,
                      dataId,
                      carNumber,
                      enterTime,
                      enterName,
                      etc,
                      outName,
                      outTime,
                      outLocation,
                      movedLocation,
                      adress,
                      selfParking,
                    );
                  } else {
                    showCarInfoBottomSheet2(
                      context,
                      dataId,
                      carNumber,
                      enterTime,
                      enterName,
                      etc,
                      outName,
                      outTime,
                      outLocation,
                      movedLocation,
                      movingTime,
                      adress,
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: CarListCard(
                    index: index + 1,
                    carNum: docs[index]['carNumber'],
                    inTime: docs[index]['enter'],
                    outTime: docs[index]['out'] is Timestamp
                        ? (docs[index]['out'] as Timestamp).toDate()
                        : null,
                    carBrand: docs[index]['carBrand'],
                    carModel: docs[index]['carModel'],
                    selectedTab: selectedTab,
                    movingTime: docs[index]['movingTime'] is Timestamp
                        ? (docs[index]['movingTime'] as Timestamp).toDate()
                        : null,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showCarInfoBottomSheet(
    context,
    id,
    carNumber,
    enterTime,
    enterName,
    etc,
    outName,
    outTime,
    outLocation,
    movedLocation,
    adress,
    selfParking,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 400,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '차번호:$carNumber',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // 다이얼로그 닫기

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("삭제 확인"),
                                content: Text("정말로 삭제하시겠습니까?"),
                                actions: [
                                  TextButton(
                                    child: Text("취소"),
                                    onPressed: () {
                                      Navigator.of(context).pop(); // 다이얼로그 닫기
                                    },
                                  ),
                                  TextButton(
                                    child: Text("삭제"),
                                    onPressed: () async {
                                      try {
                                        // 삭제할 문서의 참조를 가져와
                                        await FirebaseFirestore.instance
                                            .collection(
                                                CARLIST + adress) // 예: 'users'
                                            .doc(id) // 예: 'abc123'
                                            .delete();

                                        Navigator.of(context).pop(); // 다이얼로그 닫기
                                        print('삭제 확인됨');
                                        // 여기에 삭제 완료 후 처리 추가 (예: 스낵바 등)
                                      } catch (e) {
                                        print('삭제 중 오류 발생: $e');
                                        // 오류 처리 로직 추가 가능
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: TextButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          backgroundColor: Colors.red.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          '삭제',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: Colors.red, // 삭제는 빨간색이 직관적
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    // 여기에 다이얼로그의 내용을 추가할 수 있습니다.
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '입차',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                        Row(
                          children: [
                            Text('시각 : $enterTime분'),
                            SizedBox(
                              width: 10,
                            ),
                            Text('이름 : $enterName'),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '출차',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                                '시각 : ${outTime != null ? getOutTime(outTime!) : ''}'),
                            SizedBox(
                              width: 10,
                            ),
                            Text('이름 : ${outName ?? ''}'),
                            SizedBox(
                              width: 10,
                            ),
                            Text('위치 : ${outLocation ?? ''}'),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '특이사항',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                        Row(
                          children: [
                            Text(selfParking),
                            Text(etc),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showCarInfoBottomSheet2(
    context,
    id,
    carNumber,
    enterTime,
    enterName,
    etc,
    outName,
    outTime,
    outLocation,
    movedLocation,
    movingTime,
    adress,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 400,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '시승차번호:$carNumber',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // 다이얼로그 닫기

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("삭제 확인"),
                                content: Text("정말로 삭제하시겠습니까?"),
                                actions: [
                                  TextButton(
                                    child: Text("취소"),
                                    onPressed: () {
                                      Navigator.of(context).pop(); // 다이얼로그 닫기
                                    },
                                  ),
                                  TextButton(
                                    child: Text("삭제"),
                                    onPressed: () async {
                                      try {
                                        // 삭제할 문서의 참조를 가져와
                                        await FirebaseFirestore.instance
                                            .collection(
                                                COLOR5 + adress) // 예: 'users'
                                            .doc(id) // 예: 'abc123'
                                            .delete();

                                        Navigator.of(context).pop(); // 다이얼로그 닫기
                                        print('삭제 확인됨');
                                        // 여기에 삭제 완료 후 처리 추가 (예: 스낵바 등)
                                      } catch (e) {
                                        print('삭제 중 오류 발생: $e');
                                        // 오류 처리 로직 추가 가능
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: TextButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          backgroundColor: Colors.red.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          '삭제',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: Colors.red, // 삭제는 빨간색이 직관적
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    // 여기에 다이얼로그의 내용을 추가할 수 있습니다.
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '스탠바이',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                        Text('시각 : ${enterTime ?? '-'}분'),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '시승출발',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                        Row(
                          children: [
                            Text('시각 : $movingTime분'),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '시승종료(복귀시각)',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                                '시각 : ${outTime != null ? getOutTime(outTime!) : ''}분'),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '특이사항',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                        Row(
                          children: [
                            Text(etc),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
