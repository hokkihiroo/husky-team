import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../0adress_const.dart';
import 'brandManage_list_card.dart';

class BrandMansgeList extends StatefulWidget {
  final String category;
  final String documentID;
  final String teamId;
  final int grade;

  BrandMansgeList({
    super.key,
    required this.category,
    required this.documentID,
    required this.teamId,
    required this.grade,
  });

  @override
  State<BrandMansgeList> createState() => _BrandMansgeListState();
}

class _BrandMansgeListState extends State<BrandMansgeList> {
  late String gangnamCarList;
  final String documentID = '';

  // ------------------------------------------------------------
  // 디자인 색상
  // ------------------------------------------------------------
  static const Color navy = Color(0xFF17233C);
  static const Color navyLight = Color(0xFF253452);
  static const Color gold = Color(0xFFC6A667);
  static const Color goldLight = Color(0xFFE6D19A);
  static const Color background = Color(0xFFF4F5F7);
  static const Color textDark = Color(0xFF202632);
  static const Color textGrey = Color(0xFF737B89);

  // ------------------------------------------------------------
  // 차종 추가
  // ------------------------------------------------------------
  void _showDialog() {
    final TextEditingController _textFieldController =
    TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            '차종 추가',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 23,
              color: textDark,
            ),
          ),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(
              hintText: '차종 입력',
              hintStyle: const TextStyle(
                color: Color(0xFFA5ABB5),
              ),
              filled: true,
              fillColor: const Color(0xFFF5F6F8),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: gold,
                  width: 1.5,
                ),
              ),
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
            ],
          ),
          actionsPadding: const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            16,
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: textGrey,
                      side: const BorderSide(
                        color: Color(0xFFDDE1E7),
                      ),
                      minimumSize: const Size.fromHeight(46),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '취소',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      String inputText =
                          _textFieldController.text;

                      String documentId = FirebaseFirestore
                          .instance
                          .collection(gangnamCarList)
                          .doc(widget.documentID)
                          .collection('LIST')
                          .doc()
                          .id;

                      try {
                        await FirebaseFirestore.instance
                            .collection(gangnamCarList)
                            .doc(widget.documentID)
                            .collection('LIST')
                            .doc(documentId)
                            .set({
                          'carModel': inputText,
                          'createdAt':
                          FieldValue.serverTimestamp(),
                        });
                      } catch (e) {}

                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: navy,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size.fromHeight(46),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '확인',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    print('initState 호출됨');

    gangnamCarList = getBrandNameList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      // ----------------------------------------------------------
      // 상단 AppBar
      // ----------------------------------------------------------
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: navy,
        foregroundColor: Colors.white,
        centerTitle: true,

        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'TEAM HUSKY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              widget.category,
              style: const TextStyle(
                color: goldLight,
                fontSize: 10,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),

        iconTheme: const IconThemeData(
          color: Colors.white,
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      title: const Text(
                        '확인사항',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: textDark,
                        ),
                      ),
                      content: const Text(
                        '브랜드 밖으로 빼면서\n'
                            '해당시스템 위험하여 폐기함',
                        style: TextStyle(
                          color: textGrey,
                          height: 1.5,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            '확인',
                            style: TextStyle(
                              color: navy,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Text(
                  '일괄삭제',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // ----------------------------------------------------------
      // 본문
      // ----------------------------------------------------------
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            16,
            18,
            16,
            24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ----------------------------------------------------
              // 브랜드 정보
              // ----------------------------------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFE2E5EA),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 28,
                      decoration: BoxDecoration(
                        color: gold,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '차종 목록',
                            style: TextStyle(
                              color: textGrey,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.category,
                            style: const TextStyle(
                              color: textDark,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 브랜드 수정
                    GestureDetector(
                      onTap: () {
                        showEditCategoryDialog(
                          context,
                          widget.category,
                              (newValue) async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection(gangnamCarList)
                                  .doc(widget.documentID)
                                  .update({
                                'category': newValue,
                              });
                            } catch (e) {
                              print(e);
                            }

                            Navigator.pop(context);
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: navy.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.edit_outlined,
                              size: 14,
                              color: navy,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '수정',
                              style: TextStyle(
                                color: navy,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ----------------------------------------------------
              // 차종 목록 제목
              // ----------------------------------------------------
              const Row(
                children: [
                  Text(
                    '등록된 차종',
                    style: TextStyle(
                      color: textDark,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.directions_car_outlined,
                    size: 18,
                    color: gold,
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // ----------------------------------------------------
              // 차종 목록
              // ----------------------------------------------------
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(gangnamCarList)
                    .doc(widget.documentID)
                    .collection('LIST')
                    .orderBy('createdAt')
                    .snapshots(),
                builder: (
                    BuildContext context,
                    AsyncSnapshot<
                        QuerySnapshot<Map<String, dynamic>>> snapshot,
                    ) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 45,
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: navy,
                        ),
                      ),
                    );
                  }

                  final subDocs = snapshot.data!.docs;

                  if (subDocs.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 40,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFE2E5EA),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: navy.withOpacity(0.06),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.directions_car_outlined,
                              color: navy,
                              size: 25,
                            ),
                          ),
                          const SizedBox(height: 11),
                          const Text(
                            '등록된 차종이 없습니다.',
                            style: TextStyle(
                              color: textGrey,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // ------------------------------------------------
                  // 3열 차종 카드
                  // ------------------------------------------------
                  return GridView.builder(
                    shrinkWrap: true,
                    physics:
                    const NeverScrollableScrollPhysics(),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,

                      // 좌우 간격
                      crossAxisSpacing: 10,

                      // 위아래 간격
                      mainAxisSpacing: 10,

                      // 카드 비율
                      childAspectRatio: 3.0,
                    ),
                    itemCount: subDocs.length,
                    itemBuilder: (context, index) {
                      final subDoc = subDocs[index];
                      final data = subDoc.data() ?? {};

                      return GestureDetector(
                        onTap: () async {
                          final document = subDoc.id;

                          showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(18),
                                ),
                                title: const Text(
                                  '작업 선택',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: textDark,
                                  ),
                                ),
                                content: const Text(
                                  '원하시는 작업을 선택하세요',
                                  style: TextStyle(
                                    color: textGrey,
                                  ),
                                ),
                                actions: [
                                  // 수정
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(
                                        dialogContext,
                                      );

                                      showEditDialog(
                                        context,
                                        document,
                                      );
                                    },
                                    child: const Text(
                                      '수정',
                                      style: TextStyle(
                                        color: navy,
                                        fontWeight:
                                        FontWeight.w700,
                                      ),
                                    ),
                                  ),

                                  // 삭제
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(
                                        dialogContext,
                                      );

                                      showDeleteConfirmDialog(
                                        context,
                                        document,
                                      );
                                    },
                                    child: const Text(
                                      '삭제',
                                      style: TextStyle(
                                        color: Color(0xFFC44A4A),
                                        fontWeight:
                                        FontWeight.w700,
                                      ),
                                    ),
                                  ),

                                  // 취소
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(
                                          dialogContext,
                                        ),
                                    child: const Text(
                                      '취소',
                                      style: TextStyle(
                                        color: textGrey,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: BrandManageListCard(
                          carModel: data['carModel'],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),

      // ----------------------------------------------------------
      // 차종 추가 버튼
      // ----------------------------------------------------------
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            14,
            10,
            14,
            10,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: const Border(
              top: BorderSide(
                color: Color(0xFFE2E5EA),
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: SizedBox(
            height: 54,
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: navy,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {
                _showDialog();
              },
              icon: const Icon(
                Icons.add_rounded,
                size: 22,
              ),
              label: const Text(
                '차종 추가',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // 브랜드 수정하기
  // ------------------------------------------------------------
  void showEditCategoryDialog(
      BuildContext context,
      String initialValue,
      Function(String newValue) onSave,
      ) {
    final TextEditingController controller =
    TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            '카테고리 수정',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: textDark,
            ),
          ),
          content: TextField(
            controller: controller,
            maxLength: 6,
            decoration: InputDecoration(
              hintText: '최대 6글자 입력',
              counterText: '',
              filled: true,
              fillColor: const Color(0xFFF5F6F8),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: gold,
                  width: 1.5,
                ),
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            16,
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        Navigator.pop(dialogContext),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: textGrey,
                      side: const BorderSide(
                        color: Color(0xFFDDE1E7),
                      ),
                      minimumSize: const Size.fromHeight(44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('취소'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final value = controller.text.trim();

                      if (value.isEmpty) return;

                      onSave(value);

                      Navigator.pop(dialogContext);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: navy,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size.fromHeight(44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '수정',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // ------------------------------------------------------------
  // 차종 삭제 확인
  // ------------------------------------------------------------
  void showDeleteConfirmDialog(
      BuildContext context,
      String document,
      ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            '삭제 확인',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: textDark,
            ),
          ),
          content: Text(
            widget.grade == 1
                ? '해당 차종을 삭제하시겠습니까?'
                : '브랜드 밖으로 빼면서\n'
                '삭제 시스템 폐기함\n'
                '팀장님께 문의하세요',
            style: const TextStyle(
              color: textGrey,
              height: 1.5,
            ),
          ),
          actions: [
            if (widget.grade == 1)
              TextButton(
                onPressed: () async {
                  try {
                    await FirebaseFirestore.instance
                        .collection(gangnamCarList)
                        .doc(widget.documentID)
                        .collection('LIST')
                        .doc(document)
                        .delete();

                    Navigator.pop(dialogContext);
                  } catch (e) {
                    print('❌ 삭제 에러: $e');
                  }
                },
                child: const Text(
                  '확인',
                  style: TextStyle(
                    color: Color(0xFFC44A4A),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext),
              child: const Text(
                '취소',
                style: TextStyle(
                  color: textGrey,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ------------------------------------------------------------
  // 차종 수정
  // ------------------------------------------------------------
  void showEditDialog(
      BuildContext context,
      String document,
      ) {
    final TextEditingController controller =
    TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            '차종 수정',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: textDark,
            ),
          ),
          content: TextField(
            controller: controller,
            maxLength: 7,
            decoration: InputDecoration(
              hintText: '최대 7글자',
              counterText: '',
              filled: true,
              fillColor: const Color(0xFFF5F6F8),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: gold,
                  width: 1.5,
                ),
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            16,
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        Navigator.pop(dialogContext),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: textGrey,
                      side: const BorderSide(
                        color: Color(0xFFDDE1E7),
                      ),
                      minimumSize: const Size.fromHeight(44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('취소'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final newValue =
                      controller.text.trim();

                      if (newValue.isEmpty) return;

                      try {
                        await FirebaseFirestore.instance
                            .collection(gangnamCarList)
                            .doc(widget.documentID)
                            .collection('LIST')
                            .doc(document)
                            .update({
                          'carModel': newValue,
                        });
                      } catch (e) {
                        print(e);
                      }

                      Navigator.pop(dialogContext);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: navy,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size.fromHeight(44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '저장',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}