import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/5mypage/management/manegement/menues/teamMenues/changeStaffNum_Card.dart';

class ChangeStaffNum extends StatefulWidget {
  final String teamName;
  final String position;
  final String teamDocId;

  const ChangeStaffNum({
    super.key,
    required this.teamName,
    required this.position,
    required this.teamDocId,
  });

  @override
  State<ChangeStaffNum> createState() => _ChangeStaffNumState();
}

class _ChangeStaffNumState extends State<ChangeStaffNum> {
  List<Map<String, dynamic>> memberList = [];

  String name = '';
  String position = '';
  String grade = '';
  String docId = '';
  int levelNumber = 0;

  static const Color navy = Color(0xFF17233C);
  static const Color navyLight = Color(0xFF253452);
  static const Color gold = Color(0xFFC6A667);
  static const Color textDark = Color(0xFF303641);
  static const Color textGrey = Color(0xFF737B89);
  static const Color background = Color(0xFFF4F5F7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: navy,
        foregroundColor: Colors.white,
        title: const Text(
          '직원순서 변경',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 안내 카드
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    navy,
                    navyLight,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: navy.withOpacity(0.18),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 43,
                    height: 43,
                    decoration: BoxDecoration(
                      color: gold.withOpacity(0.16),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(
                      Icons.format_list_numbered_rounded,
                      color: gold,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '직원순서 관리',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${widget.position} ${widget.teamName} 직원 순서를 변경합니다.',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFFD5DAE3),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // 제목
            Row(
              children: [
                const Text(
                  '직원 목록',
                  style: TextStyle(
                    color: textDark,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 1,
                    color: const Color(0xFFDDE1E7),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('insa')
                  .doc(widget.teamDocId)
                  .collection('list')
                  .orderBy('levelNumber')
                  .snapshots(),
              builder: (
                  BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                  snapshot,
                  ) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 50),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: gold,
                        strokeWidth: 2.5,
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return _emptyCard(
                    icon: Icons.error_outline_rounded,
                    text: '직원 정보를 불러오지 못했습니다.',
                  );
                }

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  return _emptyCard(
                    icon: Icons.people_outline_rounded,
                    text: '데이터가 없습니다.',
                  );
                }

                final docs = snapshot.data!.docs;

                final filteredDocs = docs
                    .where((doc) => doc['levelNumber'] != 0)
                    .toList();

                memberList.clear();

                for (var doc in filteredDocs) {
                  Map<String, dynamic> data = {
                    'name': doc['name'],
                    'docId': doc.id,
                    'position': doc['position'],
                    'grade': doc['grade'],
                    'levelNumber': doc['levelNumber'],
                  };

                  memberList.add(data);
                }

                if (filteredDocs.isEmpty) {
                  return _emptyCard(
                    icon: Icons.people_outline_rounded,
                    text: '등록된 직원이 없습니다.',
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final doc = filteredDocs[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 9),
                      child: GestureDetector(
                        onTap: () {
                          name = doc['name'] ?? '이름 없음';
                          grade = doc['grade'] ?? '학년 없음';
                          position = doc['position'] ?? '직책 없음';
                          levelNumber =
                              doc['levelNumber'] ?? 0;

                          var document = doc;
                          docId = document.id;

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return changeNum(
                                name,
                                grade,
                                position,
                                levelNumber,
                                docId,
                                memberList,
                              );
                            },
                          );
                        },
                        child: ChangeStaffNumCard(
                          number: index + 1,
                          name: doc['name'] ?? '',
                          position: doc['position'] ?? '',
                          grade: doc['grade'] ?? '',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyCard({
    required IconData icon,
    required String text,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E5EA),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: const Color(0xFFB5BBC5),
            size: 32,
          ),
          const SizedBox(height: 9),
          Text(
            text,
            style: const TextStyle(
              color: textGrey,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget changeNum(
      String name,
      String grade,
      String position,
      int levelNumber,
      String docId,
      List<Map<String, dynamic>> memberList,
      ) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      titlePadding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        8,
      ),
      contentPadding: const EdgeInsets.fromLTRB(
        16,
        8,
        16,
        8,
      ),
      actionsPadding: const EdgeInsets.fromLTRB(
        16,
        4,
        16,
        14,
      ),
      title: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: navy.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.swap_vert_rounded,
                  color: navy,
                  size: 22,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  '$name 직원의 위치 변경',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: textDark,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '위치를 바꿀 직원을 선택하세요.',
              style: TextStyle(
                color: textGrey,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 1,
            color: const Color(0xFFE2E5EA),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 300,
        child: ListView.builder(
          itemCount: memberList.length,
          itemBuilder: (context, index) {
            var member = memberList[index];

            String memberName =
                member['name'] ?? '이름 없음';
            String memberPosition =
                member['position'] ?? '직책 없음';
            String memberGrade =
                member['grade'] ?? '직급 없음';
            String memberdocId =
                member['docId'] ?? '아이디 없음';
            int memberlevelNumber =
                member['levelNumber'] ?? 0;

            return GestureDetector(
              onTap: () async {
                Navigator.pop(context);

                try {
                  await FirebaseFirestore.instance
                      .collection('insa')
                      .doc(widget.teamDocId)
                      .collection('list')
                      .doc(docId)
                      .update({
                    'levelNumber': memberlevelNumber,
                  });

                  print('$name 이');
                  print('$memberName 으로감');
                } catch (e) {
                  print(e);
                }

                try {
                  await FirebaseFirestore.instance
                      .collection('insa')
                      .doc(widget.teamDocId)
                      .collection('list')
                      .doc(memberdocId)
                      .update({
                    'levelNumber': levelNumber,
                  });

                  print('$memberName 이');
                  print('$name 으로감');
                } catch (e) {
                  print(e);
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 4,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: const Color(0xFFE2E5EA),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // 순번
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: gold.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: navy,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // 이름
                    Expanded(
                      child: Text(
                        memberName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: textDark,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // 직책
                    Text(
                      memberPosition,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: textGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(width: 8),

                    // 직급
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: navy.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        memberGrade,
                        style: const TextStyle(
                          color: navy,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(width: 3),

                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFFB0B6C0),
                      size: 18,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          height: 44,
          child: OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: textGrey,
              side: const BorderSide(
                color: Color(0xFFDDE1E7),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              '닫기',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}