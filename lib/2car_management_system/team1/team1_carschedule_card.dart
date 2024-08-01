import 'package:flutter/material.dart';

class CarScheduleCard extends StatelessWidget {
  final int number;
  final String selectedTime;
  final String selectedAlpha;

  const CarScheduleCard({super.key, required this.number, required this.selectedTime, required this.selectedAlpha});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0), // Adds padding on the sides
      child: Container(
        height: 30,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  '$number',
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
                  '$selectedTime',
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
                  '$selectedAlpha',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
