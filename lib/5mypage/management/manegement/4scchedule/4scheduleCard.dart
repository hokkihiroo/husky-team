import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  final String name;
  final String position;

  const ScheduleCard({
    Key? key,
    required this.name,
    required this.position,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 5.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              name,
              style: TextStyle(
                letterSpacing: 1.0,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              position,
              style: TextStyle(
                letterSpacing: 1.0,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              '선택  >',
              style: TextStyle(
                letterSpacing: 1.0,
                fontSize: 13,
                fontWeight: FontWeight.w200,
                color: Colors.grey.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
