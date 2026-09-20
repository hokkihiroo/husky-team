import 'package:flutter/material.dart';

class ManageGongjiCategoryCaard extends StatelessWidget {
  String category;

  ManageGongjiCategoryCaard({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFF0F0F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
// 카테고리 아이콘
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.campaign_outlined,
              size: 21,
              color: Color(0xFF444444),
            ),
          ),

          const SizedBox(width: 14),

// 카테고리 이름
          Expanded(
            child: Text(
              category,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.4,
                color: Color(0xFF222222),
              ),
            ),
          ),

// 선택
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                '선택',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF999999),
                ),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.chevron_right_rounded,
                size: 21,
                color: Color(0xFFAAAAAA),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
