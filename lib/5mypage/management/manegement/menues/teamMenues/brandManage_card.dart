import 'package:flutter/material.dart';

class BrandManageCard extends StatelessWidget {
  final String category;

  const BrandManageCard({
    super.key,
    required this.category,
  });

  static const Color navy = Color(0xFF17233C);
  static const Color gold = Color(0xFFC6A667);
  static const Color textDark = Color(0xFF303641);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE4E7EC),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        child: Row(
          children: [
            // 왼쪽 골드 포인트
            Container(
              width: 3,
              height: 22,
              decoration: BoxDecoration(
                color: gold,
                borderRadius: BorderRadius.circular(3),
              ),
            ),

            const SizedBox(width: 10),

            // 브랜드명
            Expanded(
              child: Text(
                category,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
            ),

            // 차종으로 들어가는 것을 은은하게 암시
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF9AA1AC),
              size: 19,
            ),
          ],
        ),
      ),
    );
  }
}