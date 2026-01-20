import 'package:flutter/material.dart';

class ForgenesisCard extends StatelessWidget {
  final String carModel;
  final String carNumber;

  const ForgenesisCard({
    super.key,
    required this.carModel,
    required this.carNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 22), // ⭐ 전체 여백 증가
      decoration: BoxDecoration(
        color: Colors.green.shade400, // ⭐ 연한 배경
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 50), // ⭐ 왼쪽 숨 쉴 공간

          // 🚗 차종
          SizedBox(
            width: 150,
            child: Text(
              carModel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
                color: Colors.black87,
              ),
            ),
          ),

          const Spacer(),

          // 🔢 차량 번호
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              carNumber,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                color: Colors.grey.shade700,
              ),
            ),
          ),

          const SizedBox(width: 50), // ⭐ 오른쪽 숨 쉴 공간
        ],
      ),
    );
  }
}
