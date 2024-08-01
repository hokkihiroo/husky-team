import 'package:flutter/material.dart';

class GangnamCarCard extends StatelessWidget {
  final String carName;
  final String carNumber;

  const GangnamCarCard({super.key, required this.carName, required this.carNumber});



  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 250,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Text(carName,
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w800),
          ),
          Text(
            carNumber,
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
