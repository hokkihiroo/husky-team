import 'package:flutter/material.dart';

class ForgenesisCard extends StatelessWidget {
  final String carModel;
  final String carNumber;

  const ForgenesisCard({
    super.key,
    required this.carModel,
    required this.carNumber,
  });

  static const Color navy = Color(0xFF17233C);
  static const Color gold = Color(0xFFC6A667);
  static const Color textDark = Color(0xFF303641);
  static const Color textGrey = Color(0xFF737B89);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E5EA),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // 골드 포인트
          Container(
            width: 4,
            height: 34,
            decoration: BoxDecoration(
              color: gold,
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          const SizedBox(width: 13),

          // 차량 아이콘
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: navy.withOpacity(0.07),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.directions_car_rounded,
              color: navy,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          // 차종
          Expanded(
            child: Text(
              carModel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: textDark,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ),

          const SizedBox(width: 10),

          // 차량 번호
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 11,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: navy.withOpacity(0.07),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              carNumber,
              style: const TextStyle(
                color: navy,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}