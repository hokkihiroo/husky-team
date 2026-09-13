import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:table_calendar/table_calendar.dart';

import '../team5-1/team5_carList_card.dart';
import '../team5_adress.dart';

class Team5_carlist extends StatefulWidget {
  const Team5_carlist({super.key});

  @override
  State<Team5_carlist> createState() => _Team5_carlistState();
}

class _Team5_carlistState extends State<Team5_carlist> {

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
        .collection(COLOR5 + address)
        .orderBy('enter')
        .get();

    final count = query.docs.length;

    final buffer = StringBuffer();
    buffer.writeln('날짜: $address (총 $count대)');
    buffer.writeln(
        '번호 차종 차번호 출발 도착 용도 고객성함 총거리(전) 총거리(후) 주유량(전) 주유량(후) 주유충전여부 주유/충전금액');

    for (int i = 0; i < count; i++) {
      final doc = query.docs[i];
      final model = doc['carModel'];
      final carNum = doc['carNumber'];
      Timestamp movingTime123 = doc['movingTime']; //입차시각
      final movingTime = getInTime(movingTime123);
      final out = doc['out'] is Timestamp
          ? getOutTime((doc['out'] as Timestamp).toDate())
          : '---';

      final option5 = '${doc['option5'] ?? ''}'; //대면시승 비대면시승
      final option8 = '${doc['option8'] ?? ''}'; //A-1 A-2 C D
      final option9Raw = doc['option9'];
      final option9 = (option9Raw == null ||
          option9Raw.toString().trim().isEmpty)
          ? '없음'
          : option9Raw.toString().trim();

      final totalKm = '${doc['totalKm'] ?? ''}'; //총거리(시승전)
      final totalKmAfter = '${doc['totalKmAfter'] ?? ''}'; //총거리(시승후)
      final leftGas = '${doc['leftGas'] ?? ''}'; //주유량(시승전)
      final leftGasAfter = '${doc['leftGasAfter'] ?? ''}'; //주유량(시승후)
      final dynamic rawOption2 = doc['option2'];

      final int option2222 = rawOption2 is int
          ? rawOption2
          : int.tryParse(rawOption2?.toString() ?? '') ?? 0; // 🔥 핵심     주유충전금액
      final String gasOk = option2222 > 0 ? 'O' : 'X'; //금액이 0보다크면 O 아니면X
      final String option2 = option2222.toString(); //0보다 클때 스트링으로

      buffer.writeln(
          '${i + 1} $model $carNum $movingTime $out $option5$option8 $option9 $totalKm $totalKmAfter $leftGas $leftGasAfter $gasOk $option2');

    }

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          '시승차 일일리스트',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.copy),
            onPressed: () async {
              final text = await createClipboardText(DBAdress);
              Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('텍스트가 복사되었습니다!')),
              );
            },
          ),
          SizedBox(
            width: 15,
          ),
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
            _Color5State(),
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
  String dataId = '';
  String carNumber = '';
  String enterTime = '';
  String enterName = '';
  String etc = '';
  DateTime? outTime;
  DateTime dateTime2 = DateTime.now(); //이동할 시각들 뽑음
  String outName = '';
  String outLocation = '';
  String carModel = '';
  String movingTime = '';
  String selfParking = '';
  String movingTimeForTabOne = '';

  int leftGas = 0; // 주유잔량
  int hiPass = 0; //  하이패스잔액
  int totalKm = 0; // 총킬로수
  int leftGasAfter = 0; //시승후 주유잔량
  int hiPassAfter = 0; // 시승후 하이패스잔액
  int totalKmAfter = 0; //시승후 총킬로수

  String option1 = ''; //최종 3개 (하이패스 잔량 총거리 변경자)
  int? option2; // 주유금액
  String option5 = ''; // 시승차상태 기본시승 비교시승 비대면시승 등등
  String option8 = ''; //A-1 A-2 C D
  String option9 = ''; //예약한 고객성함

  ListModel({
    super.key,
    required this.adress,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(COLOR5 + adress)
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
                  enterName = docs[index]['enterName']; //입차한사람 이름
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

                  carModel = docs[index]['carModel']; //차종

                  final raw = docs[index]['movingTime'];
                  movingTime =
                  raw is Timestamp ? movingTimeGet(raw.toDate()) : '';

                  option1 = docs[index]['option1']; //최종 3개 (하이패스 잔량 총거리 변경자)
                  option2 = docs[index]['option2'] as int?; //주유금액 설정
                  option5 = docs[index]['option5']; // 시승차상태 기본시승 비교시승 비대면시승 등등
                  option8 = docs[index]['option8']; //A-1 A-2 C D
                  option9 = docs[index]['option9']; //예약한 고객성함

                  hiPass = int.tryParse(docs[index]['hiPass'].toString()) ??
                      0; //하이패스 잔액
                  leftGas = int.tryParse(docs[index]['leftGas'].toString()) ??
                      0; //주유잔량
                  totalKm = int.tryParse(docs[index]['totalKm'].toString()) ??
                      0; //총킬로수
                  hiPassAfter =
                      int.tryParse(docs[index]['hiPassAfter'].toString()) ??
                          0; //하이패스 잔액
                  leftGasAfter =
                      int.tryParse(docs[index]['leftGasAfter'].toString()) ??
                          0; //주유잔량
                  totalKmAfter =
                      int.tryParse(docs[index]['totalKmAfter'].toString()) ??
                          0; //총킬로수

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
                    carModel,
                    movingTime,
                    adress,
                    leftGas,
                    hiPass,
                    totalKm,
                    leftGasAfter,
                    hiPassAfter,
                    totalKmAfter,
                    option1,
                    option2,
                    option5,
                    option8,
                    option9, //예약한 고객성함
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
    carModel,
    movingTime,
    adress,
    leftGas,
    hiPass,
    totalKm,
    leftGasAfter,
    hiPassAfter,
    totalKmAfter,
    option1, //시승종료후 차량 내려서 3대 기록한사람
    option2, //주유금액
    option5, // 시승차상태 기본시승 비교시승 비대면시승 등등
    option8, //A-1 C D
    option9, //예약한 고객성함
    ) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 600,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '차종 : $carModel',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          height: 1.1, // 👈 이거 추가
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        '차번호 : $carNumber',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          height: 1.1, // 👈 이거 추가
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        // 👈 필수
                        constraints: const BoxConstraints(),
                        // 👈 필수
                        tooltip: '삭제',
                        icon: const Icon(Icons.delete_outline),
                        color: Colors.red,
                        onPressed: () {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return AlertDialog(
                                title: const Text('삭제 확인'),
                                content: const Text(
                                  '정말로 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(dialogContext),
                                    child: const Text('취소'),
                                  ),
                                  SizedBox(width: 40),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                    ),
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection(COLOR5 + adress)
                                          .doc(id)
                                          .delete();
                                      Navigator.pop(dialogContext);
                                    },
                                    child: const Text(
                                      '삭제',
                                      style: TextStyle(
                                        color: Colors.yellow,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 5),

                /// =====================
                /// 🕒 상태 / 시각 카드
                /// =====================
                _card(
                  child: Column(
                    children: [
                      _rowHeader(['상태', '스탠바이', '시승출발', '시승종료']),
                      const SizedBox(height: 5),
                      _rowValue([
                        '시각',
                        '${enterTime ?? '-'}분',
                        '$movingTime분',
                        outTime != null ? '${getOutTime(outTime)}분' : '-',
                      ]),
                    ],
                  ),
                ),

                const SizedBox(height: 5),

                /// =====================
                /// ⛽ 주유 / 거리 카드
                /// =====================
                _card(
                  child: Column(
                    children: [
                      _rowHeader(['상태', '주유잔량', '하이패스', '총거리']),
                      const SizedBox(height: 5),
                      _rowValue([
                        '시승전',
                        formatKm(leftGas),
                        formatWon(hiPass),
                        formatKm(totalKm),
                      ]),
                      const SizedBox(height: 5),
                      _rowValue([
                        '시승후',
                        formatKm(leftGasAfter),
                        formatWon(hiPassAfter),
                        formatKm(totalKmAfter),
                      ]),
                    ],
                  ),
                ),

                const SizedBox(height: 5),

                /// =====================
                /// 👤 시승상태 카드 (변경됨)
                /// =====================
                _card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12), // ⭐ 핵심
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: _cell('시승준비 :', align: TextAlign.right),
                        ),
                        Expanded(
                          flex: 4,
                          child: _cell(enterName),
                        ),
                        Expanded(
                          flex: 3,
                          child: _cell('시승복귀 :', align: TextAlign.right),
                        ),
                        Expanded(
                          flex: 4,
                          child: _cell(option1),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 5),
                _card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12), // ⭐ 핵심
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: _cell('시승상태 :', align: TextAlign.right),
                        ),
                        Expanded(
                          flex: 4,
                          child: _cell(option5),
                        ),
                        Expanded(
                          flex: 3,
                          child: _cell('시승상태 :', align: TextAlign.right),
                        ),
                        Expanded(
                          flex: 4,
                          child: _cell(option8),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                _card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12), // ⭐ 핵심
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: _cell('주유금액 :', align: TextAlign.right),
                        ),
                        Expanded(
                          flex: 4,
                          child: _cell(formatWon(option2)),
                        ),
                        Expanded(
                          flex: 3,
                          child: _cell('예약자 :', align: TextAlign.right),
                        ),
                        Expanded(
                          flex: 4,
                          child: _cell(option9),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),

                _card(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      const Text(
                        '특이사항 :',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        etc.isNotEmpty ? etc : '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
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

Widget _cell(String text, {TextAlign align = TextAlign.center}) {
  return Text(
    text,
    textAlign: align,
    style: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
    ),
  );
}

Widget _rowHeader(List<String> texts) {
  return Row(
    children: texts
        .map(
          (t) => Expanded(
        child: _cell(
          t,
          align: TextAlign.center,
        ),
      ),
    )
        .toList(),
  );
}

Widget _rowValue(List<String> texts) {
  return Row(
    children: texts
        .map(
          (t) => Expanded(
        child: _cell(t),
      ),
    )
        .toList(),
  );
}

Widget _card({required Widget child}) {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 12,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: child,
  );
}
