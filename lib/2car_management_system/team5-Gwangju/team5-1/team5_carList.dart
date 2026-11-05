import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:team_husky/2car_management_system/team5-Gwangju/team5-1/team5_carList_card.dart';

import '../team5_adress.dart';

class Team5CarList extends StatefulWidget {
  const Team5CarList({super.key});

  @override
  State<Team5CarList> createState() => _CarListState();
}

class _CarListState extends State<Team5CarList> {

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
        .collection(TEAM5CARLIST + address)
        .orderBy('enter')
        .get();

    final count = query.docs.length;

    final buffer = StringBuffer();
    buffer.writeln('날짜: $address (총 $count대)');
    buffer.writeln('번호 브랜드 차종 차번호 입차 출차');

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

      buffer.writeln('${i + 1} $brand $model $carNum $enter $out');

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
            Text(
              '고객차리스트',
              style: TextStyle(
                color:Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
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
            _ListState() ,
// 기존 ListModel 유지
            ListModel(
              adress: DBAdress,
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



class ListModel extends StatelessWidget {
  final String adress;
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

  ListModel({super.key, required this.adress,});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(TEAM5CARLIST+adress)
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
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Team5CarlistCard(
                    index: index + 1,
                    carNum: docs[index]['carNumber'],
                    inTime: docs[index]['enter'],
                    outTime: docs[index]['out'] is Timestamp
                        ? (docs[index]['out'] as Timestamp).toDate()
                        : null,
                    carBrand: docs[index]['carBrand'],
                    carModel: docs[index]['carModel'],
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
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(sheetContext).size.height * 0.8,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFFF3F1EC),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 상단 손잡이
                  Center(
                    child: Container(
                      width: 38,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCCCCCC),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // 차량번호 및 삭제 버튼
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFF17233C),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.directions_car_rounded,
                          color: Colors.white,
                          size: 23,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '차량 정보',
                              style: TextStyle(
                                color: Color(0xFF737B89),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '차번호 : $carNumber',
                              style: const TextStyle(
                                color: Color(0xFF202632),
                                fontSize: 21,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 삭제 버튼
                      TextButton.icon(
                        onPressed: () {
                          Navigator.of(sheetContext).pop();

                          showDialog(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              return AlertDialog(
                                backgroundColor: const Color(0xFF202632),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                title: const Row(
                                  children: [
                                    Icon(
                                      Icons.warning_amber_rounded,
                                      color: Color(0xFFFF6B6B),
                                      size: 25,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      '삭제 확인',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                content: const Text(
                                  '정말로 삭제하시겠습니까?',
                                  style: TextStyle(
                                    color: Color(0xFFD0D3DA),
                                    fontSize: 14,
                                  ),
                                ),
                                actionsPadding:
                                const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop();
                                    },
                                    child: const Text(
                                      '취소',
                                      style: TextStyle(
                                        color: Color(0xFFB8BEC9),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: const Color(0xFFB83232),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(9),
                                      ),
                                    ),
                                    onPressed: () async {
                                      try {
                                        await FirebaseFirestore.instance
                                            .collection(TEAM5CARLIST + adress)
                                            .doc(id)
                                            .delete();

                                        Navigator.of(dialogContext).pop();
                                        print('삭제 확인됨');
                                      } catch (e) {
                                        print('삭제 중 오류 발생: $e');
                                      }
                                    },
                                    child: const Text(
                                      '삭제',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          size: 17,
                        ),
                        label: const Text(
                          '삭제',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFFCE4545),
                          backgroundColor: const Color(0xFFFCEAEA),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 9,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // 입차 정보
                  _carInfoSection(
                    title: '입차 정보',
                    icon: Icons.login_rounded,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _carInfoRow('입차 시각', '$enterTime분'),
                          ),
                          Expanded(
                            child: _carInfoRow('입차 담당자', '$enterName'),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // 출차 정보
                  _carInfoSection(
                    title: '출차 정보',
                    icon: Icons.logout_rounded,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _carInfoRow(
                              '출차 시각',
                              outTime != null ? getOutTime(outTime!) : '-',
                            ),
                          ),
                          Expanded(
                            child: _carInfoRow('출차 위치', outLocation ?? '-'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _carInfoRow('출차 담당자', outName ?? '-'),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // 특이사항
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 17,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF17233C),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          color: Color(0xFFE6D19A),
                          size: 19,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '특이사항 :',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            etc != null && etc.toString().isNotEmpty
                                ? '$etc'
                                : '-',
                            style: const TextStyle(
                              color: Color(0xFFE6D19A),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
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

// 정보 섹션 디자인
  Widget _carInfoSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFF17233C),
                size: 19,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF202632),
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 13),

          ...children,
        ],
      ),
    );
  }

// 정보 행 디자인
  Widget _carInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$title : ',
            style: const TextStyle(
              color: Color(0xFF737B89),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF202632),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
