import 'package:flutter/material.dart';

class GongjiDetail extends StatelessWidget {
  final String writer;
  final String formattedDate;
  final String contents;
  final String subject;
  final Map<String, String>? imageUrls;

  const GongjiDetail({
    super.key,
    required this.writer,
    required this.formattedDate,
    required this.contents,
    required this.subject,
    required this.imageUrls,
  });

  static const Color navy = Color(0xFF17233C);
  static const Color navyLight = Color(0xFF253452);
  static const Color gold = Color(0xFFC6A667);
  static const Color goldLight = Color(0xFFE6D19A);
  static const Color background = Color(0xFFF4F5F7);
  static const Color textDark = Color(0xFF303641);
  static const Color textGrey = Color(0xFF737B89);

  @override
  Widget build(BuildContext context) {
    final List<String> sortedKeys = imageUrls?.keys.toList() ?? [];

    sortedKeys.sort(
          (a, b) => int.parse(a).compareTo(int.parse(b)),
    );

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: navy,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          '공지사항',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          14,
          14,
          14,
          30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목 및 작성 정보
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                18,
                20,
                18,
                16,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFFE2E5EA),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 9,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 골드 포인트
                  Container(
                    width: 34,
                    height: 4,
                    decoration: BoxDecoration(
                      color: gold,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 제목
                  Text(
                    subject,
                    style: const TextStyle(
                      color: textDark,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      height: 1.35,
                      letterSpacing: 0.2,
                    ),
                  ),

                  const SizedBox(height: 17),

                  // 작성일 / 작성자
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: background,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_rounded,
                                color: navy,
                                size: 15,
                              ),
                              const SizedBox(width: 7),
                              Flexible(
                                child: Text(
                                  formattedDate,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: textGrey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 15,
                          color: const Color(0xFFD8DCE2),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.person_outline_rounded,
                                color: navy,
                                size: 16,
                              ),
                              const SizedBox(width: 7),
                              Flexible(
                                child: Text(
                                  writer,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: textGrey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 본문
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                18,
                20,
                18,
                22,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFFE2E5EA),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                contents,
                style: const TextStyle(
                  color: textDark,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  height: 1.7,
                  letterSpacing: 0.1,
                ),
              ),
            ),

            // 이미지
            if (sortedKeys.isNotEmpty) ...[
              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                  10,
                  14,
                  10,
                  10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFFE2E5EA),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < sortedKeys.length; i++) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrls![sortedKeys[i]]!,
                          width: double.infinity,
                          fit: BoxFit.contain,
                          loadingBuilder:
                              (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }

                            return Container(
                              height: 180,
                              alignment: Alignment.center,
                              child: const SizedBox(
                                width: 25,
                                height: 25,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: navy,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 120,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: background,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.broken_image_outlined,
                                    color: textGrey,
                                    size: 28,
                                  ),
                                  SizedBox(height: 7),
                                  Text(
                                    '이미지를 불러올 수 없습니다.',
                                    style: TextStyle(
                                      color: textGrey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      if (i < sortedKeys.length - 1) ...[
                        const SizedBox(height: 25),

                        Container(
                          height: 4,
                          width: 42,
                          decoration: BoxDecoration(
                            color: gold,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),

                        const SizedBox(height: 25),
                      ],
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}