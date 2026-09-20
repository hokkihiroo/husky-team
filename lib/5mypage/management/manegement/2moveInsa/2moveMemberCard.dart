import 'package:flutter/material.dart';

class MoveMemberCard extends StatelessWidget {
  final String name;
  final String team;
  final String position;

  const MoveMemberCard({
    Key? key,
    required this.name,
    required this.team,
    required this.position,
  }) : super(key: key);

  static const Color navy = Color(0xFF17233C);
  static const Color gold = Color(0xFFC6A667);
  static const Color textDark = Color(0xFF303641);
  static const Color textGrey = Color(0xFF737B89);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 2,
        vertical: 5,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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

          const SizedBox(width: 12),

          // 이름
          Expanded(
            flex: 2,
            child: Text(
              name,
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

          const SizedBox(width: 8),

          // 소속
          Expanded(
            flex: 2,
            child: Text(
              team,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: textGrey,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(width: 8),

          // 직책
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: navy.withOpacity(0.07),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              position,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: navy,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}