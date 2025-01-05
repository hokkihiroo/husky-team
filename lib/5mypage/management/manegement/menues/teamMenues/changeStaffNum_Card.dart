import 'package:flutter/material.dart';

class ChangeStaffNumCard extends StatelessWidget {
  final String name;
  final String grade;
  final String position;
  final int number;

  const ChangeStaffNumCard({
    super.key,
    required this.position,
    required this.name,
    required this.grade,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      // 여백 추가
      child: Container(
        height: 80, // 카드 높이 조정
        padding: const EdgeInsets.all(16.0), // 내부 여백 추가
        decoration: BoxDecoration(
          color: Colors.orange[50], // 배경 색상
          borderRadius: BorderRadius.circular(15), // 둥근 모서리
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // 그림자 색상
              blurRadius: 6.0, // 그림자 퍼짐 범위
              offset: Offset(0, 4), // 그림자 방향
            ),
          ],
          border: Border.all(
            color: Colors.orange, // 테두리 색상
            width: 1, // 테두리 두께
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center, // 세로 중앙 정렬
          children: [
            // 번호
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  number.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16), // 간격

            // 이름
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis, // 긴 이름을 '...' 처리
              ),
            ),
            SizedBox(width: 10),

            // 직급
            Text(
              grade,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(width: 10),

            // 직위
            Text(
              position,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
