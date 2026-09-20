import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/5mypage/authorization/authorization_card.dart';

class MemberList extends StatefulWidget {
  final int grade;

  const MemberList({
    Key? key,
    required this.grade,
  }) : super(key: key);

  @override
  State<MemberList> createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  String dataId = '';
  String name = '';
  int grade = 9;

  static const Color navy = Color(0xFF17233C);
  static const Color navyLight = Color(0xFF253452);
  static const Color gold = Color(0xFFC6A667);
  static const Color goldLight = Color(0xFFE6D19A);
  static const Color textDark = Color(0xFF303641);
  static const Color textGrey = Color(0xFF737B89);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('user')
          .where(
        'grade',
        isEqualTo: widget.grade,
      )
          .snapshots(),
      builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
          ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: navy,
                ),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              '직원 목록을 불러오지 못했습니다.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textGrey,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 18,
            ),
            child: Column(
              children: [
                Icon(
                  Icons.person_off_outlined,
                  color: Colors.grey.shade400,
                  size: 25,
                ),
                const SizedBox(height: 6),
                Text(
                  '직원이 없습니다.',
                  style: TextStyle(
                    color: textGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final document = docs[index];

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 2,
              ),
              child: GestureDetector(
                onTap: () {
                  dataId = document.id;
                  name = document['name'];
                  grade = document['grade'];

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ChangeGrade(
                        name,
                        dataId,
                        grade,
                      );
                    },
                  );
                },
                child: AuthorizationCard(
                  name: document['name'],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget ChangeGrade(
      String name,
      String docId,
      int grade,
      ) {
    final bool isGeneral = grade == 0;

    final String titleText = isGeneral
        ? '관리자로 변경하시겠습니까?'
        : '일반직원으로 변경하시겠습니까?';

    final String buttonText = isGeneral
        ? '관리자로 변경'
        : '직원으로 변경';

    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        18,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 아이콘
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: navy.withOpacity(0.07),
              shape: BoxShape.circle,
              border: Border.all(
                color: gold.withOpacity(0.7),
                width: 1.5,
              ),
            ),
            child: Icon(
              isGeneral
                  ? Icons.admin_panel_settings_rounded
                  : Icons.person_outline_rounded,
              color: navy,
              size: 27,
            ),
          ),

          const SizedBox(height: 13),

          // 직원 이름
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: textDark,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 7),

          // 안내 문구
          Text(
            titleText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: textGrey,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 18),

          // 변경될 권한 표시
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 11,
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              color: backgroundColor(),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isGeneral
                      ? Icons.person_outline_rounded
                      : Icons.admin_panel_settings_outlined,
                  color: navy,
                  size: 18,
                ),
                const SizedBox(width: 7),
                Text(
                  isGeneral ? '일반직원  →  관리자' : '관리자  →  일반직원',
                  style: const TextStyle(
                    color: navy,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // 버튼
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: textGrey,
                      side: const BorderSide(
                        color: Color(0xFFD9DDE3),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '취소',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);

                      final int updatedGrade = grade == 0 ? 1 : 0;

                      try {
                        await FirebaseFirestore.instance
                            .collection('user')
                            .doc(docId)
                            .update({
                          'grade': updatedGrade,
                        });
                      } catch (e) {
                        debugPrint(e.toString());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: navy,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color backgroundColor() {
    return const Color(0xFFF4F5F7);
  }
}