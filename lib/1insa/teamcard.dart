import 'package:flutter/material.dart';

class BuildingCard extends StatelessWidget {
  final Widget image;
  final String name;
  final String position;

  const BuildingCard({
    Key? key,
    required this.name,
    required this.image,
    required this.position,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Row(
          children: [
            // ClipOval로 이미지를 감싸서 원형으로 잘라냄
            ClipOval(
              child: Container(
                height: 40, // 이미지의 높이를 조정, 필요에 따라 조절
                width: 40, // 이미지의 너비를 조정, 필요에 따라 조절
                child: image,
              ),
            ),
            SizedBox(width: 20),
            Text(
              name,
              style: TextStyle(
                letterSpacing: 3.0,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(width: 20),
            Text(
              position,
              style: TextStyle(
                letterSpacing: 3.0,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
