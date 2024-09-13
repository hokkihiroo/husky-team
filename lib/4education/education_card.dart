import 'package:flutter/material.dart';

class EducationCard extends StatelessWidget {
  final String subject;

  EducationCard({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // 카드의 그림자 깊이
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // 카드의 모서리 둥글게
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0), // 카드 내부 여백
        child: Row(
          children: [
            Text(
              '📚', // 책 이모티콘
              style: TextStyle(
                fontSize: 32, // 이모티콘 크기
              ),
            ),
            SizedBox(width: 16), // 이모티콘과 텍스트 사이 여백
            Expanded(
              child: Text(
                subject,
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 16, // 폰트 크기 줄임
                  fontWeight: FontWeight.bold, // 텍스트를 굵게
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios, // 오른쪽 화살표 아이콘
              color: Colors.grey, // 화살표 색상
              size: 20, // 화살표 크기
            ),
          ],
        ),
      ),
    );
  }
}
