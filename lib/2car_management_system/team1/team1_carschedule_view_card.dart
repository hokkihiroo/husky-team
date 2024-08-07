import 'package:flutter/material.dart';

class CarScheduleViewCard extends StatelessWidget {
  final int index;
  final int testOk;
  final String seat;
  final String car;
  final String docId;
  final String time;

  const CarScheduleViewCard(
      {super.key,
      required this.car,
      required this.docId,
      required this.time,
      required this.index,
      required this.seat,
      required this.testOk});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Center(
            child: Text(
              '$index',
              style: TextStyle(
                color: testOk == 0 ? Colors.white : Colors.grey[800],
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Center(
            child: Text(
              '$time',
              style: TextStyle(
                color: testOk == 0 ? Colors.white : Colors.grey[800],
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Center(
            child: Text(
              '$car',
              style: TextStyle(
                color: testOk == 0 ? Colors.white : Colors.grey[800],
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
              child: Text(
            seat,
            style: TextStyle(
              color: seat == 'X'
                  ? Colors.black
                  : (testOk == 1 || testOk == 2 ? Colors.grey[800] : Colors.white),
              // 조건에 따라 색상 변경
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          )),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: Text(
              testOk == 1 ? '완료' : (testOk == 2 ? '취소' : ''),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.red
              ),
            ),
          ),
        ),
      ],
    );
  }
}
