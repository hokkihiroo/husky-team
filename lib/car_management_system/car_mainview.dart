import 'package:flutter/material.dart';
import 'package:team_husky/car_management_system/team1/team1_view.dart';

class CarManagementSystem extends StatelessWidget {
  const CarManagementSystem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context, MaterialPageRoute(builder: (context) => Team1View()),
            );
          },
          child: Container(
            child: Column(
              children: [
                Text(
                  '1팀 HMS 강남 ',
                  style: TextStyle(
                    letterSpacing: 3.0,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ' 차량관리, 시승차 관리 시스템',
                  style: TextStyle(
                    letterSpacing: 3.0,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
