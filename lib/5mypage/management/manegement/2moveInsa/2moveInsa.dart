import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/1insa/Address.dart';
import 'package:team_husky/5mypage/management/manegement/2moveInsa/2moveMemberCard.dart';

class MoveInsa extends StatefulWidget {
  const MoveInsa({Key? key}) : super(key: key);

  @override
  State<MoveInsa> createState() => _MoveInsaState();
}

class _MoveInsaState extends State<MoveInsa> {
  String docId = '';
  List<Map<String, dynamic>> teamList = [];
  List<Map<String, dynamic>> memberList = [];

  String memberId = '';
  String memberName = '';
  String memberPosition = '';
  String upgradePosition = '';
  String memberGrade = '';
  String updateGrade = '';
  Timestamp memberEnter = Timestamp.now();
  String image = '';
  String picUrl = '';
  int levelNum = 0;

  static const Color navy = Color(0xFF17233C);
  static const Color navyLight = Color(0xFF253452);
  static const Color gold = Color(0xFFC6A667);
  static const Color goldLight = Color(0xFFE6D19A);
  static const Color background = Color(0xFFF4F5F7);
  static const Color textDark = Color(0xFF202632);
  static const Color textGrey = Color(0xFF737B89);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: navy,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          '인사 / 직책변경',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 안내
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
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
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: gold.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                        color: gold.withOpacity(0.45),
                      ),
                    ),
                    child: const Icon(
                      Icons.manage_accounts_rounded,
                      color: goldLight,
                      size: 25,
                    ),
                  ),
                  const SizedBox(width: 13),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '인사 관리',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '팀을 선택하여 직원의 소속과 직책을 관리합니다.',
                          style: TextStyle(
                            color: Color(0xFFD4D9E2),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              '팀 선택',
              style: TextStyle(
                color: textDark,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection(INSA)
                  .orderBy('createdAt')
                  .snapshots(),
              builder: (
                  BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
                  ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(30),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: navy,
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return _buildErrorCard(
                    '팀 정보를 불러오지 못했습니다.',
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return _buildEmptyCard(
                    icon: Icons.groups_outlined,
                    text: '등록된 팀이 없습니다.',
                  );
                }

                final docs = snapshot.data!.docs;

                if (teamList.isEmpty) {
                  for (var doc in docs) {
                    Map<String, dynamic> data = {
                      'name': doc['name'],
                      'docId': doc['docId'],
                      'position': doc['position'],
                    };

                    teamList.add(data);
                  }
                }

                return GridView.builder(
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 2.6,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data();
                    final bool isSelected =
                        docId == data['docId'];

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          docId = data['docId'];
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? navy
                              : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? gold
                                : const Color(0xFFE2E5EA),
                            width: isSelected ? 1.5 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                isSelected ? 0.10 : 0.04,
                              ),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? gold.withOpacity(0.18)
                                      : navy.withOpacity(0.07),
                                  borderRadius:
                                  BorderRadius.circular(9),
                                ),
                                child: Icon(
                                  Icons.groups_rounded,
                                  color: isSelected
                                      ? goldLight
                                      : navy,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 9),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['name'] ?? '',
                                      maxLines: 1,
                                      overflow:
                                      TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : textDark,
                                        fontSize: 14,
                                        fontWeight:
                                        FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      data['position'] ?? '',
                                      maxLines: 1,
                                      overflow:
                                      TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: isSelected
                                            ? const Color(
                                          0xFFD4D9E2,
                                        )
                                            : textGrey,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: gold,
                                  size: 18,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 22),

            if (docId.isNotEmpty) ...[
              Row(
                children: [
                  const Text(
                    '직원 목록',
                    style: TextStyle(
                      color: textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: navy.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '직원을 선택하세요',
                      style: TextStyle(
                        color: navy,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              StreamBuilder<
                  QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection(INSA)
                    .doc(docId)
                    .collection('list')
                    .orderBy('levelNumber')
                    .snapshots(),
                builder: (
                    BuildContext context,
                    AsyncSnapshot<
                        QuerySnapshot<Map<String, dynamic>>>
                    snapshot,
                    ) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(30),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: navy,
                        ),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return _buildErrorCard(
                      '직원 정보를 불러오지 못했습니다.',
                    );
                  }

                  if (!snapshot.hasData) {
                    return _buildEmptyCard(
                      icon: Icons.person_outline_rounded,
                      text: '직원이 없습니다.',
                    );
                  }

                  final docs = snapshot.data!.docs.where((subDoc) {
                    final data = subDoc.data();
                    final levelNumber =
                        data['levelNumber'] ?? 0;

                    return levelNumber != 0;
                  }).toList();

                  if (docs.isEmpty) {
                    return _buildEmptyCard(
                      icon: Icons.person_outline_rounded,
                      text: '해당 팀에 등록된 직원이 없습니다.',
                    );
                  }

                  return Column(
                    children: docs.map((subDoc) {
                      final data = subDoc.data();

                      return Padding(
                        padding:
                        const EdgeInsets.only(bottom: 9),
                        child: GestureDetector(
                          onTap: () async {
                            memberId = subDoc.id;
                            memberName = data['name'] ?? '';
                            memberPosition =
                                data['position'] ?? '';
                            memberGrade = data['grade'] ?? '';
                            memberEnter =
                            data['enterDay'];
                            image = data['image'] ?? '';
                            picUrl = data['picUrl'] ?? '';

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return MoveInsaButton(
                                  teamList,
                                  memberId,
                                  memberName,
                                  memberPosition,
                                  memberGrade,
                                  docId,
                                  memberEnter,
                                  image,
                                  picUrl,
                                );
                              },
                            );
                          },
                          child: MoveMemberCard(
                            name: data['name'] ?? '',
                            team: data['grade'] ?? '',
                            position: data['position'] ?? '',
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCard({
    required IconData icon,
    required String text,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFE2E5EA),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: const Color(0xFF9AA1AC),
            size: 30,
          ),
          const SizedBox(height: 8),
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

  Widget _buildErrorCard(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFE2E5EA),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Colors.redAccent,
          ),
          const SizedBox(width: 10),
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

  Widget MoveInsaButton(
      List<Map<String, dynamic>> teamList,
      String memberId,
      String memberName,
      String memberPosition,
      String memberGrade,
      String docId,
      Timestamp memberEnter,
      String image,
      String picUrl,
      ) {
    return AlertDialog(
      backgroundColor: background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),

      title: Column(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: navy.withOpacity(0.08),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: navy,
              size: 25,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            memberName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: textDark,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            '이동하고자하는 팀선택',
            style: TextStyle(
              color: textGrey,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),

      actions: [
        Row(
          children: [
            Expanded(
              child: _buildDialogButton(
                icon: Icons.badge_outlined,
                text: '직책변경',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return _buildChangeDialog(
                        title: '직책 변경',
                        currentTitle: '현재 직책',
                        currentValue: memberGrade,
                        hintText: '새로운 직책',
                        onChanged: (value) {
                          if (value.length <= 4) {
                            updateGrade = value;
                          }
                        },
                        onConfirm: () async {
                          Navigator.pop(context);

                          try {
                            await FirebaseFirestore.instance
                                .collection(INSA)
                                .doc(docId)
                                .collection('list')
                                .doc(memberId)
                                .update({
                              'grade': updateGrade,
                            });
                          } catch (e) {
                            print(e);
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildDialogButton(
                icon: Icons.work_outline_rounded,
                text: '업무변경',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return _buildChangeDialog(
                        title: '업무 변경',
                        currentTitle: '현재 업무',
                        currentValue: memberPosition,
                        hintText: '새로운 포지션',
                        onChanged: (value) {
                          if (value.length <= 4) {
                            upgradePosition = value;
                          }
                        },
                        onConfirm: () async {
                          Navigator.pop(context);

                          try {
                            await FirebaseFirestore.instance
                                .collection(INSA)
                                .doc(docId)
                                .collection('list')
                                .doc(memberId)
                                .update({
                              'position': upgradePosition,
                            });
                          } catch (e) {
                            print(e);
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildDialogButton(
                icon: Icons.close_rounded,
                text: '취소',
                onPressed: () {
                  Navigator.pop(context);
                },
                outlined: true,
              ),
            ),
          ],
        ),
      ],

      content: Container(
        width: double.maxFinite,
        constraints: const BoxConstraints(
          maxHeight: 310,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color(0xFFE2E5EA),
          ),
        ),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: teamList.length,
          separatorBuilder: (context, index) {
            return const Divider(
              height: 1,
              indent: 55,
              endIndent: 15,
              color: Color(0xFFE9EBEF),
            );
          },
          itemBuilder: (context, index) {
            Map<String, dynamic> teamData = teamList[index];

            final bool isCurrentTeam =
                teamData['docId'] == docId;

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 3,
              ),
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isCurrentTeam
                      ? gold.withOpacity(0.18)
                      : navy.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isCurrentTeam
                      ? Icons.check_rounded
                      : Icons.groups_rounded,
                  color: isCurrentTeam ? gold : navy,
                  size: 20,
                ),
              ),
              title: Text(
                teamData['name'],
                style: TextStyle(
                  color: isCurrentTeam ? navy : textDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                teamData['position'],
                style: const TextStyle(
                  color: textGrey,
                  fontSize: 11,
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF9AA1AC),
                size: 20,
              ),
              onTap: () async {
                levelNum = 0;

                var selectTeam = teamData['docId'];

                try {
                  QuerySnapshot querySnapshot =
                  await FirebaseFirestore.instance
                      .collection(INSA)
                      .doc(selectTeam)
                      .collection('list')
                      .get();

                  int highestLevel = querySnapshot.docs
                      .map((doc) =>
                  doc['levelNumber'] as int)
                      .reduce(
                          (curr, next) =>
                      curr > next ? curr : next);

                  levelNum = highestLevel;
                  print(highestLevel);
                  print(levelNum);
                } catch (e) {
                  print('문서 삭제 오류: $e');
                }

                try {
                  await FirebaseFirestore.instance
                      .collection('user')
                      .doc(memberId)
                      .update({
                    'teamId': selectTeam,
                  });
                } catch (e) {
                  print(e);
                }

                try {
                  await FirebaseFirestore.instance
                      .collection(INSA)
                      .doc(docId)
                      .collection('list')
                      .doc(memberId)
                      .delete();

                  print('문서 삭제 완료');
                } catch (e) {
                  print('문서 삭제 오류: $e');
                }

                try {
                  await FirebaseFirestore.instance
                      .collection(INSA)
                      .doc(teamData['docId'])
                      .collection('list')
                      .doc(memberId)
                      .set({
                    'grade': memberGrade,
                    'name': memberName,
                    'position': memberPosition,
                    'enterDay': memberEnter,
                    'image': image,
                    'picUrl': picUrl,
                    'levelNumber': levelNum + 1,
                  });
                } catch (e) {
                  print(e);
                }

                print(
                    '선택한 팀: ${teamData['name']} ${teamData['docId']}');

                Navigator.pop(context);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildDialogButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
    bool outlined = false,
  }) {
    return SizedBox(
      height: 43,
      child: outlined
          ? OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: textGrey,
          side: const BorderSide(
            color: Color(0xFFD9DDE4),
          ),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
          padding: EdgeInsets.zero,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      )
          : ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: navy,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
          padding: EdgeInsets.zero,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildChangeDialog({
    required String title,
    required String currentTitle,
    required String currentValue,
    required String hintText,
    required ValueChanged<String> onChanged,
    required VoidCallback onConfirm,
  }) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: textDark,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            currentTitle,
            style: const TextStyle(
              color: textGrey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            currentValue,
            style: const TextStyle(
              color: textDark,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 18),
          TextField(
            onChanged: onChanged,
            maxLength: 4,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Color(0xFF9AA1AC),
                fontSize: 14,
              ),
              counterStyle: const TextStyle(
                color: textGrey,
                fontSize: 11,
              ),
              filled: true,
              fillColor: background,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 13,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
                borderSide: const BorderSide(
                  color: navy,
                  width: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      actions: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 44,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: textGrey,
                    side: const BorderSide(
                      color: Color(0xFFD9DDE4),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    '취소',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: SizedBox(
                height: 44,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: navy,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  onPressed: onConfirm,
                  child: const Text(
                    '변경',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}