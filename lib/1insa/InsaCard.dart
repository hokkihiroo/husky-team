import 'package:flutter/material.dart';

class OrganizationCard extends StatelessWidget {
  final Widget image;
  final String name;
  final String grade;
  final String position;


  const OrganizationCard(
      {super.key,
        required this.image,
        required this.position,
        required this.name,
        required this.grade});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(width: 30,),

            Expanded(
              child: ClipOval(
                child: Container(
                  height: 70, // 이미지의 높이를 조정, 필요에 따라 조절
                  width: 70, // 이미지의 너비를 조정, 필요에 따라 조절
                  child: image,
                ),
              ),
            ),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  letterSpacing: 3.0,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                grade,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                position,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}