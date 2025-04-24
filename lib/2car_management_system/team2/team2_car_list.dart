import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  //오늘로 이동
  void goToday() {
    setState(() {
      selectedDate = DateTime.now();
      DBAdress = formatTodayDate();
    });
  }

  // 텍스트 만드는 함수 추가
  Future<String> createClipboardText(String address) async {
    final query = await FirebaseFirestore.instance
        .collection(CARLIST + address)
        .orderBy('enter')
        .get();

    final buffer = StringBuffer();
    buffer.writeln('날짜: $address');
    buffer.writeln('-----------------------------');

    for (int i = 0; i < query.docs.length; i++) {
      final doc = query.docs[i];
      final carNum = doc['carNumber'];
      final brand = doc['carBrand'];
      final model = doc['carModel'];
      final etc = doc['etc'];
      final enter = getInTime(doc['enter']);
      final out = doc['out'] is Timestamp
          ? getOutTime((doc['out'] as Timestamp).toDate())
          : '---';

      buffer.writeln('[${i + 1}]');
      buffer.writeln('브랜드: $brand');
      buffer.writeln('차종: $model');
      buffer.writeln('차량번호: $carNum');
      buffer.writeln('입차: $enter / 출차: $out');
      buffer.writeln('특이사항: $etc ');
      buffer.writeln('');
    }

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          '입차리스트',
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
            _ListState(),
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
            'TODAY',
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
  DateTime? outTime;
  String outName = '';
  String outLocation = '';
  String movedLocation = '';
  String wigetName = '';
  String movingTime = '';

  ListModel({super.key, required this.adress});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(CARLIST + adress)
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
                  movingTime = docs[index]['movingTime']; //출차한위치 이름
                  wigetName = docs[index]['wigetName']; //출차한위치 이름

                  showCarInfoBottomSheet(
                      context,
                      dataId,
                      carNumber,
                      enterTime,
                      enterName,
                      outName,
                      outTime,
                      outLocation,
                      movedLocation,
                      wigetName,
                      movingTime);

                  // showDialog(
                  //   context: context,
                  //   builder: (BuildContext context) {
                  //     return AlertDialog(
                  //       title: Text('차정보'),
                  //     );
                  //   },
                  // );
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
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showCarInfoBottomSheet(context, id, carNumber, enterTime, enterName,
      outName, outTime, outLocation, movedLocation, wigetName, movingTime) {
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '차번호:$carNumber',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
                        Row(
                          children: [
                            Text(
                              '이동',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              movedLocation
                                  .replaceAll('=', '\n')
                                  .split('\n')
                                  .sublist(
                                      0, movedLocation.split('=').length - 1)
                                  .join('\n'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              wigetName.replaceAll('=', '\n'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              movingTime.replaceAll('=', '\n'),
                            ),
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
