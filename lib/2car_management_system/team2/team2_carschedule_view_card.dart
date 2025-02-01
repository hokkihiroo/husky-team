import 'package:flutter/material.dart';

class Team2CarScheduleViewCard extends StatelessWidget {
  final int index;
  final int testOk;
  final String seat;
  final String carNumber;
  final String meeting;
  final String car;
  final String docId;
  final String time;

  const Team2CarScheduleViewCard({
    super.key,
    required this.car,
    required this.docId,
    required this.time,
    required this.index,
    required this.seat,
    required this.testOk,
    required this.carNumber,
    required this.meeting,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width, // 화면 전체 너비
      child: Row(
        children: [

          Expanded(
            flex: 2,
            child: Container(
              child: Text(
                '$time',
                style: TextStyle(
                  color: testOk == 0 ? Colors.white : Colors.grey[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Text(
                meeting,
                style: TextStyle(
                  color: testOk == 0 ? Colors.white : Colors.grey[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '$car',
                    style: TextStyle(
                      color: testOk == 0 ? Colors.white : Colors.grey[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Text(
                carNumber,
                style: TextStyle(
                  color: testOk == 0 ? Colors.white : Colors.grey[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Text(
                seat,
                style: TextStyle(
                  color: seat == 'X'
                      ? Colors.black
                      : (testOk == 1 || testOk == 2
                          ? Colors.grey[800]
                          : Colors.white),
                  // 조건에 따라 색상 변경
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Text(
                testOk == 1
                    ? '완료'
                    : (testOk == 2
                        ? '취소'
                        : (testOk == 0 ? '확인' : '')), // testOk가 0이면 "확인"
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: testOk == 0 ? Colors.black : Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
