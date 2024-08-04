import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/2car_management_system/team1/team1_adress_const.dart';
import 'package:team_husky/2car_management_system/team1/team1_carschedule_view_card.dart';

class CarScheduleView extends StatefulWidget {
  final String CarScheduleAdress;

  CarScheduleView({
    super.key,
    required this.CarScheduleAdress,
  });

  @override
  State<CarScheduleView> createState() => _CarScheduleViewState();
}

class _CarScheduleViewState extends State<CarScheduleView> {
  final String testTime = '';
  final String testCar = '';
  final String docId = '';
  final String testOk = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(CARSCHEDULE + widget.CarScheduleAdress)
          .orderBy('time')
          .snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final docs = snapshot.data!.docs;

        return Column(
          children: docs.asMap().entries.map((entry) {
            int index = entry.key + 1; // 1부터 시작하는 인덱스
            var doc = entry.value;
            return GestureDetector(
              onTap: () {
                var testTime = doc['time'];
                var testCar = doc['car'];
                var docId = doc['docId'];
                print(testTime);
                print(testCar);
                print(docId);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return selectFinish(
                      docId,
                      testCar,
                      testTime,
                    );
                  },
                );
              },
              child: CarScheduleViewCard(
                car: doc['car'],
                docId: doc.id,
                time: doc['time'],
                index: index,
                seat: doc['seat'],
                testOk: doc['testOk'],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget selectFinish(
    docId,
    testCar,
    testTime,
  ) {
    return AlertDialog(
      title: Column(
        children: [
          Text('차량이름: $testCar'),
          Text('시승시각: $testTime'),
        ],
      ),
      content: Container(
        height: 150,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      try {
                        await FirebaseFirestore.instance
                            .collection(CARSCHEDULE + widget.CarScheduleAdress)
                            .doc(docId)
                            .update({
                          'testOk': 1,
                        });
                        Navigator.pop(context);
                      } catch (e) {
                        print('문서 업뎃 오류: $e');
                      }
                    },
                    child: Text('시승완료')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection(CARSCHEDULE + widget.CarScheduleAdress)
                          .doc(docId)
                          .update({
                        'testOk': 2,
                      });
                      Navigator.pop(context);
                    },
                    child: Text('시승취소')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection(CARSCHEDULE + widget.CarScheduleAdress)
                          .doc(docId)
                          .update({
                        'testOk': 0,
                      });
                      Navigator.pop(context);
                    },
                    child: Text('복귀 ')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
