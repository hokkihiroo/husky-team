import 'package:flutter/material.dart';

class CarScheduleViewCard extends StatelessWidget {
  final int index;
  final String seat;
  final String car;
  final String docId;
  final String time;

  const CarScheduleViewCard(
      {super.key, required this.car, required this.docId, required this.time, required this.index, required this.seat});

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
                color: Colors.white,
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
                color: Colors.white,
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
                color: Colors.white,
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
            child:Text(
              seat,
              style: TextStyle(
                color: seat == 'X' ? Colors.black : Colors.white, // 조건에 따라 색상 변경
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            )
          ),
        ),
      ],
    );
  }
}
