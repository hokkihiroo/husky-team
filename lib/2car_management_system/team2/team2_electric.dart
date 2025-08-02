import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/2car_management_system/team2/team2_adress_const.dart';
import 'package:team_husky/2car_management_system/team2/team2_electric_card.dart';

class Electric extends StatefulWidget {
  const Electric({super.key});

  @override
  State<Electric> createState() => _ElectricState();
}

class _ElectricState extends State<Electric> {
  DateTime selectedDate = DateTime.now();
  String DBAdress = elecToDate();

  void _previousDay() {
    final goToOneMonthAgo = DateTime(
      selectedDate.year,
      selectedDate.month - 1,
      selectedDate.day,
    );
    final year = goToOneMonthAgo.year.toString();
    final month = goToOneMonthAgo.month.toString().padLeft(2, '0');

    setState(() {
      selectedDate = goToOneMonthAgo;
      DBAdress = year + month;
    });
  }

  //다음날로 이동
  void _nextDay() {
    final today = DateTime.now();
    final nextMonth = DateTime(
      selectedDate.year,
      selectedDate.month + 1,
      selectedDate.day,
    );
    final year = nextMonth.year.toString();
    final month = nextMonth.month.toString().padLeft(2, '0');

    setState(() {
      if (nextMonth.isBefore(today)) {
        setState(() {
          selectedDate = nextMonth;
          DBAdress = year + month;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          '전기차 충전관리',
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
              // final text = await createClipboardText(DBAdress);
              // Clipboard.setData(ClipboardData(text: text));
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(content: Text('텍스트가 복사되었습니다!')),
              // );
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
  final DateTime selectedDate;

  const _DateControl(
      {super.key,
      required this.onPressLeft,
      required this.onPressRight,
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
          "${selectedDate.year.toString()}-${selectedDate.month.toString().padLeft(2, '0')}",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),

        SizedBox(
          width: 2,
        ),
        Text(
          '월',
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
            _buildHeaderCell(width: 40, label: '날짜'),
            _buildHeaderCell(width: 70, label: '충전기'),
            _buildHeaderCell(width: 60, label: '차종'),
            _buildHeaderCell(width: 60, label: '충전시각'),
            _buildHeaderCell(width: 60, label: '완료시각'),
            _buildHeaderCell(width: 60, label: '체류장소'),
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
          .collection(ELECTRICLIST + adress)
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
                  // var document = docs[index];
                  // print(document.id);
                  // dataId = document.id;
                  // carNumber = docs[index]['carNumber'];
                  // Timestamp sam = docs[index]['enter']; //입차시각
                  // enterTime = getInTime(sam); //입차시각 변환코드
                  // enterName = docs[index]['enterName']; //입차한사람 이름
                  //
                  // outTime = docs[index]['out'] is Timestamp
                  //     ? (docs[index]['out'] as Timestamp).toDate()
                  //     : null;
                  //
                  // String outname = docs[index]['outName']; //출차한사람 이름
                  // if (outname == null) {
                  //   outName = '';
                  // } else {
                  //   outName = outname;
                  // }
                  // int location = docs[index]['outLocation']; //출차한위치 이름
                  // outLocation = checkOutLocation(location);
                  //
                  // movedLocation = docs[index]['movedLocation']; //출차한위치 이름
                  // movingTime = docs[index]['movingTime']; //출차한위치 이름
                  // wigetName = docs[index]['wigetName']; //출차한위치 이름
                  //
                  // showCarInfoBottomSheet(
                  //   context,
                  //   dataId,
                  //   carNumber,
                  //   enterTime,
                  //   enterName,
                  //   outName,
                  //   outTime,
                  //   outLocation,
                  //   movedLocation,
                  //   wigetName,
                  //   movingTime,
                  //   adress,
                  // );
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: ElectricCard(
                    theDay: docs[index]['theDay'],
                    chargeNumber: docs[index]['chargeNumber'],
                    outTime: docs[index]['out'] is Timestamp
                        ? (docs[index]['out'] as Timestamp).toDate()
                        : null,

                    inTime: docs[index]['enter'],
                    carModel: docs[index]['carModel'],
                    selectedLocation: docs[index]['selectedLocation'],
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
      outName,
      outTime,
      outLocation,
      movedLocation,
      wigetName,
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