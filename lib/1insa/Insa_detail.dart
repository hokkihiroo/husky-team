
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Address.dart';

class InsaDetail extends StatelessWidget {
  final Map<String, dynamic> data;
  final String formattedDate;
  final String picUrl;

  const InsaDetail({
    super.key,
    required this.data,
    required this.formattedDate,
    required this.picUrl,
  });

  // 전화 걸기
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  // 이메일 보내기
  Future<void> _sendEmail(String email) async {
    final Uri url = Uri(
      scheme: 'mailto',
      path: email,
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  // 전체 이미지 보기
  void _showFullImage(BuildContext context) {
    if (picUrl.isEmpty) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _FullImageView(imageUrl: picUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String employeeName =
        data['name']?.toString() ?? '이름 없음';

    final String birthDay =
        data['birthDay']?.toString() ?? '';

    final String phoneNumber =
        data['phoneNumber']?.toString() ?? '';

    final String email =
        data['email']?.toString() ?? '';

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 20,
      ),
      child: Container(
        width: 320,
        constraints: const BoxConstraints(maxWidth: 320),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: AppColors.navy.withOpacity(0.18),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.navy.withOpacity(0.18),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 상단 브랜드 영역
            Row(
              children: [
                const Icon(
                  Icons.badge_outlined,
                  color: AppColors.navy,
                  size: 19,
                ),
                const SizedBox(width: 7),
                const Text(
                  'TEAM HUSKY',
                  style: TextStyle(
                    color: AppColors.navy,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(20),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.close_rounded,
                      size: 21,
                      color: AppColors.textGrey,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // 프로필 사진 좌우 네이비 그라데이션 배경
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 18,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFF0C1425),
                    AppColors.navy,
                    Color(0xFF35496D),
                    AppColors.navy,
                    Color(0xFF0C1425),
                  ],
                  stops: [0.0, 0.22, 0.5, 0.78, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.navy.withOpacity(0.18),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: GestureDetector(
                  onTap: () => _showFullImage(context),
                  child: Container(
                    width: 112,
                    height: 112,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF35496D),
                          AppColors.navy,
                          Color(0xFF0C1425),
                        ],
                      ),
                      border: Border.all(
                        color: AppColors.gold,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.28),
                          blurRadius: 14,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: ClipOval(
                        child: picUrl.isNotEmpty
                            ? Image.network(
                          picUrl,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) {
                            return Image.asset(
                              'asset/img/husky_Logo.png',
                              fit: BoxFit.cover,
                            );
                          },
                        )
                            : Image.asset(
                          'asset/img/husky_Logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // 직원 이름
            Text(
              employeeName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.navy,
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 20),

            // 연락처
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: AppColors.navy.withOpacity(0.10),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.navy,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.phone_outlined,
                      color: AppColors.goldLight,
                      size: 19,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '연락처',
                          style: TextStyle(
                            color: AppColors.textGrey,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          phoneNumber.isEmpty
                              ? '정보 없음'
                              : phoneNumber,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textDark,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (phoneNumber.isNotEmpty)
                    IconButton(
                      onPressed: () => _makePhoneCall(phoneNumber),
                      icon: const Icon(Icons.call_rounded),
                      color: AppColors.navy,
                      iconSize: 19,
                      visualDensity: VisualDensity.compact,
                      tooltip: '전화 걸기',
                    ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // 이메일
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: AppColors.navy.withOpacity(0.10),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.navy,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.mail_outline_rounded,
                      color: AppColors.goldLight,
                      size: 19,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '이메일',
                          style: TextStyle(
                            color: AppColors.textGrey,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          email.isEmpty ? '정보 없음' : email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textDark,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // 입사일 + 생년월일
            Row(
              children: [
                Expanded(
                  child: _infoRow('입사일', formattedDate),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _infoRow('생년월일', birthDay),
                ),
              ],
            ),

            const SizedBox(height: 2),
          ],
        ),
      ),
    );
  }

  // 정보 항목 카드
  Widget _infoRow(String label, dynamic value) {
    final String displayValue =
    value == null || value.toString().trim().isEmpty
        ? '정보 없음'
        : value.toString();

    return Container(
      constraints: const BoxConstraints(minHeight: 62),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.navy.withOpacity(0.10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.clip,
            style: const TextStyle(
              color: AppColors.textGrey,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: double.infinity,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                displayValue,
                maxLines: 1,
                softWrap: false,
                style: const TextStyle(
                  color: AppColors.navy,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 전체 이미지 보기
// ============================================================

class _FullImageView extends StatelessWidget {
  final String imageUrl;

  const _FullImageView({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Center(
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.broken_image_outlined,
                color: AppColors.goldLight,
                size: 48,
              );
            },
          ),
        ),
      ),
    );
  }
}