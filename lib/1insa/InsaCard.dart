import 'package:flutter/material.dart';

class OrganizationCard extends StatelessWidget {
  final Widget image;
  final String name;
  final String grade;
  final String position;
  final String? picUrl;

  const OrganizationCard({
    super.key,
    required this.image,
    required this.position,
    required this.name,
    required this.grade,
    this.picUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 12.0,
        right: 8.0,
        top: 4.0,
        bottom: 4.0,
      ),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: Colors.grey.withOpacity(0.12),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 18),

            // 프로필 이미지
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFC6A667),
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: picUrl != null && picUrl!.isNotEmpty
                    ? Image.network(
                  picUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return image;
                  },
                )
                    : image,
              ),
            ),

            const SizedBox(width: 18),

            // 이름
            Expanded(
              flex: 3,
              child: Text(
                name.length == 2
                    ? '${name[0]}   ${name[1]}'
                    : name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  letterSpacing: 2.0,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF222222),
                ),
              ),
            ),
            // 직급
            Expanded(
              flex: 2,
              child: Text(
                grade,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: grade == '대표'
                      ? const Color(0xFFB8860B)
                      : grade == '팀장'
                      ? const Color(0xFFC6A667)
                      : const Color(0xFF555555),
                  shadows: grade == '대표' || grade == '팀장'
                      ? [
                    Shadow(
                      color: const Color(0xFFC6A667).withOpacity(0.45),
                      blurRadius: 5,
                    ),
                  ]
                      : null,
                ),
              ),
            ),

            // 직책
            Expanded(
              flex: 2,
              child: Text(
                position,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF555555),
                ),
              ),
            ),

            const SizedBox(width: 14),
          ],
        ),
      ),
    );
  }
}