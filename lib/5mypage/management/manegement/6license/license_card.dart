import 'package:flutter/material.dart';

class LicenseCard extends StatelessWidget {
  final int index;
  final String name;
  final String position;

  const LicenseCard({
    super.key,
    required this.index,
    required this.name,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 6, // 그림자 깊이
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // 둥근 모서리
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9, // 화면 가로의 90% 사용
          height: 70, // 높이 고정
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              SizedBox(
                width: 30, // 번호 영역의 고정 너비
                child: Text(
                  '$index',
                  textAlign: TextAlign.center, // 텍스트 가운데 정렬
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 20), // 간격
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Text(
                position,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 20), // 간격
              Text(
                '>',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
