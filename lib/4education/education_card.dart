import 'package:flutter/material.dart';

class EducationCard extends StatelessWidget {
  final String subject;

  const EducationCard({
    super.key,
    required this.subject,
  });

  static const Color navy = Color(0xFF17233C);
  static const Color gold = Color(0xFFC6A667);
  static const Color textDark = Color(0xFF303641);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 3,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
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
            height: 42,
            decoration: BoxDecoration(
              color: gold,
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          const SizedBox(width: 12),

          // 교육 아이콘
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: navy.withOpacity(0.07),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.school_outlined,
              color: navy,
              size: 21,
            ),
          ),

          const SizedBox(width: 12),

          // 교육 제목
          Expanded(
            child: Text(
              subject,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: textDark,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ),

          const SizedBox(width: 8),

          // 오른쪽 화살표
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: navy.withOpacity(0.07),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(
              Icons.chevron_right_rounded,
              color: navy,
              size: 19,
            ),
          ),
        ],
      ),
    );
  }
}