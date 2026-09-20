import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:team_husky/3notice/Address.dart';
import 'package:team_husky/3notice/gongjiCard.dart';
import 'package:team_husky/3notice/gongji_detail.dart';

import '../notification.dart';

class Notication extends StatefulWidget {
  const Notication({super.key});

  @override
  State<Notication> createState() => _NoticationState();
}

class _NoticationState extends State<Notication> {
  String formattedDate = '';
  String writer = '';
  String docId = '';
  String contents = '';
  String subject = '';

  // 운영내용 주소
  final String operateAddress = 'dj8Jxkbcw5BR16sCF9jg';

  // 사건사고 주소
  final String issueAddress = 'doQRXV02Lid2jhjQeR99';

  // 현재 선택된 주소
  String address = 'dj8Jxkbcw5BR16sCF9jg';

  static const Color navy = Color(0xFF17233C);
  static const Color navyLight = Color(0xFF253452);
  static const Color gold = Color(0xFFC6A667);
  static const Color goldLight = Color(0xFFE6D19A);
  static const Color background = Color(0xFFF4F5F7);
  static const Color textDark = Color(0xFF303641);
  static const Color textGrey = Color(0xFF737B89);

  bool get isOperate => address == operateAddress;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      child: Column(
        children: [
          const SizedBox(height: 12),

          // 상단 카테고리 선택
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Container(
              height: 52,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFE2E5EA),
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
                  Expanded(
                    child: _buildCategoryButton(
                      title: '운영내용',
                      icon: Icons.campaign_outlined,
                      selected: isOperate,
                      onTap: () {
                        setState(() {
                          address = operateAddress;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: _buildCategoryButton(
                      title: '사건사고',
                      icon: Icons.warning_amber_rounded,
                      selected: !isOperate,
                      onTap: () {
                        setState(() {
                          address = issueAddress;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 공지 목록
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection(GONGJI)
                  .doc(address)
                  .collection('List')
                  .orderBy(
                'createdAt',
                descending: true,
              )
                  .snapshots(),
              builder: (
                  BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
                  ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: navy,
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return _buildEmptyMessage(
                    icon: Icons.error_outline_rounded,
                    message: '공지사항을 불러오지 못했습니다.',
                  );
                }

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return _buildEmptyMessage(
                    icon: Icons.notifications_none_rounded,
                    message: isOperate
                        ? '등록된 운영내용이 없습니다.'
                        : '등록된 사건사고가 없습니다.',
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    10,
                    0,
                    10,
                    16,
                  ),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data();

                    final Timestamp timestamp = data['createdAt'];
                    final DateTime date = timestamp.toDate();

                    final String dateText =
                    DateFormat('yyyy.MM.dd').format(date);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 7),
                      child: GestureDetector(
                        onTap: () {
                          writer = data['writer'];
                          contents = data['contents'];
                          subject = data['subject'];

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GongjiDetail(
                                writer: writer,
                                formattedDate: dateText,
                                contents: contents,
                                subject: subject,
                                imageUrls: data['images'] != null
                                    ? Map<String, String>.from(
                                  data['images'],
                                )
                                    : {},
                              ),
                            ),
                          );
                        },
                        child: GongjiCard(
                          subject: data['subject'],
                          date: dateText,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 카테고리 버튼
  Widget _buildCategoryButton({
    required String title,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: double.infinity,
        decoration: BoxDecoration(
          color: selected ? navy : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: selected ? goldLight : textGrey,
            ),
            const SizedBox(width: 7),
            Text(
              title,
              style: TextStyle(
                color: selected ? Colors.white : textGrey,
                fontSize: 14,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 빈 화면 / 오류 화면
  Widget _buildEmptyMessage({
    required IconData icon,
    required String message,
  }) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 28,
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: navy.withOpacity(0.07),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: navy,
                size: 25,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: textGrey,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}