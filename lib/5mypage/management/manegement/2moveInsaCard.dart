import 'package:flutter/material.dart';

class MoveInsaCard extends StatelessWidget {
  final String name;
  final Widget? image;

  const MoveInsaCard({
    Key? key,
    required this.name,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0), // 핸드폰 좌우로 2센치미터의 여백 설정
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: Container(
              height: 100, // 이미지의 높이를 조정, 필요에 따라 조절
              width: 100, // 이미지의 너비를 조정, 필요에 따라 조절
              child: image,
            ),
          ),
          SizedBox(height: 4), // 이미지와 텍스트 사이의 간격 조정
          Text(
            name,
            style: TextStyle(
              letterSpacing: 1.0,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}