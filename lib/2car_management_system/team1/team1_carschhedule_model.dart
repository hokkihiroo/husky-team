import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/2car_management_system/team1/team1_adress_const.dart';
import 'package:team_husky/2car_management_system/team1/team1_carschedule_card.dart';
import 'package:team_husky/5mypage/management/manegement/0adress_const.dart';

class CarScheduleView extends StatefulWidget {
  final String Adress;
  final List<RowFirst> rowFirst;
  final VoidCallback addRow;

  CarScheduleView(
      {super.key,
      required this.Adress,
      required this.rowFirst,
      required this.addRow});

  @override
  State<CarScheduleView> createState() => _CarScheduleViewState();
}

class _CarScheduleViewState extends State<CarScheduleView> {
  String selectedCarName = '';
  String selectedCarTime = '';
  String seat = '';
  String dataId = '';

  List<String> timeItems = [
    "09:00",
    "10:00",
    "11:00",
    "12:00",
    "13:00",
    "14:00",
    "15:00",
    "16:00",
    "17:00",
    "18:00",
    "19:00"
  ];
  List<String> alphaItems = [];
  List<String> carSeat = ["대","소"];

  Future<void> fetchCarNames() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection(GANGNAMCARLIST).get();
    alphaItems =
        querySnapshot.docs.map((doc) => doc['carName'] as String).toList();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(CARSCHEDULE + widget.Adress)
            .orderBy('time')
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          fetchCarNames(); // 시승차 목록을 시승차 스케줄 추가시 목록에 자동으로 추가하는 함수

          List<RowSecond> rowSecond = [];

          final docs = snapshot.data!.docs;

          for (int i = 0; i < docs.length; i++) {
            final doc = docs[i];
            rowSecond.add(RowSecond(
              number: i + 1, // 번호를 1부터 시작
              selectedTime: doc['time'],
              selectedAlpha: doc['car'],
              docId: doc['docId'],
              seat: doc['seat'],
            ));
          }

          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ...rowSecond.map((row) {
                  return GestureDetector(
                    onTap: () {
                      print(row.docId);

                      selectedCarName = row.selectedAlpha;
                      selectedCarTime = row.selectedTime;
                      seat = row.seat;
                      dataId = row.docId;

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return deleteCar(
                            selectedCarName,
                            selectedCarTime,
                            dataId,
                          );
                        },
                      );

                      // setState(() {
                      //   rowSecond.removeWhere((item) => item.number == row.number);
                      // });
                    },
                    child: CarScheduleCard(
                      number: row.number,
                      selectedTime: '${row.selectedTime}',
                      selectedAlpha: '${row.selectedAlpha}',
                      seat: '${row.seat}',
                    ),
                  );
                }).toList(),
                SizedBox(
                  height: 20,
                ),
                ...widget.rowFirst.map((row) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        DropdownButton<String>(
                          value: row.selectedTime,
                          dropdownColor: Colors.blue,
                          hint: Text(
                            '시각',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20, // 원하는 크기로 조정
                            ),
                          ),
                          items: timeItems.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20, // 원하는 크기로 조정
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              row.selectedTime = newValue;
                            });
                          },
                        ),
                        SizedBox(width: 30),
                        DropdownButton<String>(
                          value: row.selectedAlpha,
                          dropdownColor: Colors.blue,
                          hint: Text(
                            '시승차',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20, // 원하는 크기로 조정
                            ),
                          ),
                          items: alphaItems.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20, // 원하는 크기로 조정
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              row.selectedAlpha = newValue;
                            });
                          },
                        ),
                        DropdownButton<String>(
                          value: row.carSeat,
                          dropdownColor: Colors.blue,
                          hint: Text(
                            'X',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20, // 원하는 크기로 조정
                            ),
                          ),
                          items: carSeat.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20, // 원하는 크기로 조정
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              row.carSeat = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
                ElevatedButton(
                  onPressed: widget.addRow,
                  child: Text('추가'),
                ),
                SizedBox(
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        for (var item in widget.rowFirst) {
                          String documentId = FirebaseFirestore.instance
                              .collection(LOTARY)
                              .doc()
                              .id;
                          try {
                            await FirebaseFirestore.instance
                                .collection(CARSCHEDULE + widget.Adress)
                                .doc(documentId)
                                .set({
                              'car': '${item.selectedAlpha}',
                              'time': ' ${item.selectedTime}',
                              'docId': documentId,
                              'seat': item.carSeat ?? 'X', // null이면 'X'를 넣음
                              'testOk': 0, //0이면 시승대기 1이면 시승완료 2면 시승취소
                            });
                          } catch (e) {}
                        }

                        Navigator.pop(context);
                      },
                      child: Text('저장하기'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('뒤로가기'),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget deleteCar(
    selectedCarName,
    selectedCarTime,
    dataId,
  ) {
    return AlertDialog(
      title: Column(
        children: [
          Text('차량이름: $selectedCarName'),
          Text('시승시각: $selectedCarTime'),
        ],
      ),
      content: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () async {
                  try {
                    await FirebaseFirestore.instance
                        .collection(
                            CARSCHEDULE + widget.Adress) // 컬렉션 이름을 지정하세요
                        .doc(dataId) // 삭제할 문서의 ID를 지정하세요
                        .delete();
                    print('문서 삭제 완료');
                    Navigator.pop(context);
                  } catch (e) {
                    print('문서 삭제 오류: $e');
                  }
                },
                child: Text('삭제')),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('취소 ')),
          ],
        ),
      ),
    );
  }
}

class RowFirst {
  final int number;
  String? selectedTime;
  String? selectedAlpha;
  String? carSeat;

  RowFirst({
    required this.number,
    this.selectedTime,
    this.selectedAlpha,
    this.carSeat,
  });
}

class RowSecond {
  final int number;
  final String selectedTime;
  final String selectedAlpha;
  final String docId;
  final String seat;

  RowSecond({
    required this.number,
    required this.selectedTime,
    required this.selectedAlpha,
    required this.docId,
    required this.seat,
  });
}
