import 'package:flutter/material.dart';

class OrganizationCard extends StatelessWidget {
  final Widget image;
  final String name;
  final String grade;
  final String position;
  final String? picUrl;

  const OrganizationCard(
      {super.key,
      required this.image,
      required this.position,
      required this.name,
      required this.grade,
      this.picUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 30,
            ),
            ClipOval(
              child: Container(
                height: 40, // 이미지의 높이를 조정
                width: 40, // 이미지의 너비를 조정
                child: picUrl != null && picUrl!.isNotEmpty
                    ? Image.network(
                  picUrl!,
                  fit: BoxFit.cover,
                )
                    : image, // picUrl이 null이거나 빈 값일 경우 기본 이미지 사용
              ),
            ),
            SizedBox(width: 30,),
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
