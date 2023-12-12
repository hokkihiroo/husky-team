import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CarListCard extends StatelessWidget {
  final int index;
  final String carNum;
  final Timestamp inTime;
  final DateTime? outTime;

  const CarListCard(
      {super.key,
      required this.index,
      required this.carNum,
      required this.inTime,
      required this.outTime});

  String getInTime(Timestamp inTime) {
    final String a = inTime.toDate().hour.toString();
    final String b = inTime.toDate().minute.toString();
    final String c = '$a:$b';
    return c;
  }

  String getOutTime(DateTime outTime) {
    final String a = outTime.hour.toString();
    final String b = outTime.minute.toString();
    final String c = '$a:$b';

    return c;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            index.toString(),
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
          ),
          Text(
            carNum,
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
          ),
          Text(
            getInTime(inTime),
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
          ),
          if (outTime != null)
            Text(
              getOutTime(outTime!),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800),
            ),
          if (outTime == null)
            Text(
              '00:00',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w800),
            ),
        ],
      ),
    );
  }
}
