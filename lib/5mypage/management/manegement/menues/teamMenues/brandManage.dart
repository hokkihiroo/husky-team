import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../0adress_const.dart';
import 'brandManage_card.dart';
import 'brandManage_list.dart';

class BrandManage extends StatefulWidget {
  final String teamDocId;
  final int grade;

  const BrandManage({
    super.key,
    required this.teamDocId,
    required this.grade,
  });

  @override
  State<BrandManage> createState() => _BrandManageState();
}

class _BrandManageState extends State<BrandManage> {
  late String gangnamCarList;
  String? documentID = '';

  String selectedCategory = '국산';
  final List<String> categories = ['국산', '수입', '기타'];
  int selectedCategoryNum = 1;

  static const Color navy = Color(0xFF17233C);
  static const Color navyLight = Color(0xFF253452);
  static const Color gold = Color(0xFFC6A667);
  static const Color goldLight = Color(0xFFE6D19A);
  static const Color background = Color(0xFFF4F5F7);
  static const Color textDark = Color(0xFF202632);
  static const Color textGrey = Color(0xFF737B89);

  void _showDialog() {
    final TextEditingController _textFieldController =
    TextEditingController();

    String selectedCategory = '국내';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                '브랜드이름',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 24,
                  color: textDark,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '새로운 브랜드명을 입력해주세요.',
                    style: TextStyle(
                      color: textGrey,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _textFieldController,
                    decoration: InputDecoration(
                      hintText: '브랜드명 입력',
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
                ],
              ),
              actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                              .doc()
                              .id;

                          try {
                            await FirebaseFirestore.instance
                                .collection(gangnamCarList)
                                .doc(documentId)
                                .set({
                              'category': inputText,
                              'brandType': selectedCategoryNum,
                              'createdAt':
                              FieldValue.serverTimestamp(),
                            });
                          } catch (e) {
                            print('저장 에러: $e');
                          }

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

      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: navy,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'TEAM HUSKY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 2),
            Text(
              '차량 브랜드 관리',
              style: TextStyle(
                color: goldLight,
                fontSize: 9,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),

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

              // --------------------------------------------------
              // 제목
              // --------------------------------------------------
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 22,
                    decoration: BoxDecoration(
                      color: gold,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 9),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '차량 브랜드',
                        style: TextStyle(
                          color: textDark,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '브랜드 카테고리를 선택해주세요.',
                        style: TextStyle(
                          color: textGrey,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // --------------------------------------------------
              // 카테고리
              // --------------------------------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(6),
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
                  children: categories.map((category) {
                    final bool isSelected =
                        selectedCategory == category;

                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = category;

                            if (selectedCategory == '국산') {
                              selectedCategoryNum = 1;
                            } else if (selectedCategory == '수입') {
                              selectedCategoryNum = 2;
                            } else if (selectedCategory == '기타') {
                              selectedCategoryNum = 3;
                            }

                            print(
                              "선택된 카테고리: $selectedCategory",
                            );

                            print(
                              "카테고리 번호: $selectedCategoryNum",
                            );
                          });
                        },
                        child: AnimatedContainer(
                          duration:
                          const Duration(milliseconds: 180),
                          height: 46,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 3,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? navy
                                : Colors.transparent,
                            borderRadius:
                            BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              category,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : textGrey,
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 22),

              // --------------------------------------------------
              // 브랜드 목록 제목
              // --------------------------------------------------
              Row(
                children: [
                  const Text(
                    '브랜드 목록',
                    style: TextStyle(
                      color: textDark,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: gold.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      selectedCategory,
                      style: const TextStyle(
                        color: Color(0xFF8E733A),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // --------------------------------------------------
              // 브랜드 목록
              // --------------------------------------------------
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(gangnamCarList)
                    .where(
                  'brandType',
                  isEqualTo: selectedCategoryNum,
                )
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
                      padding:
                      EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: navy,
                        ),
                      ),
                    );
                  }

                  if (!snapshot.hasData ||
                      snapshot.data == null) {
                    return const Center(
                      child: Text(
                        "데이터가 없습니다.",
                        style: TextStyle(
                          color: textGrey,
                          fontSize: 13,
                        ),
                      ),
                    );
                  }

                  final subDocs = snapshot.data!.docs;

                  if (subDocs.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 35,
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
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: navy.withOpacity(0.06),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.directions_car_outlined,
                              color: navy,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            '등록된 브랜드가 없습니다.',
                            style: TextStyle(
                              color: textGrey,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // ------------------------------------------------
                  // 2열 브랜드 카드
                  // ------------------------------------------------
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),

                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,

                      // 좌우 간격
                      crossAxisSpacing: 10,

                      // 위아래 간격
                      mainAxisSpacing: 10,

                      // 숫자가 클수록 카드가 납작해짐
                      childAspectRatio: 3.0,
                    ),

                    itemCount: subDocs.length,

                    itemBuilder: (context, index) {
                      final subDoc = subDocs[index];
                      final data = subDoc.data() ?? {};

                      return GestureDetector(
                        onTap: () async {
                          var document = subDoc;

                          documentID = document.id;

                          print(documentID);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BrandMansgeList(
                                teamId: widget.teamDocId,
                                category: data['category'],
                                documentID: '$documentID',
                                grade: widget.grade,
                              ),
                            ),
                          );
                        },

                        child: BrandManageCard(
                          category: data['category'],
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

      // ------------------------------------------------------------
      // 브랜드 추가
      // ------------------------------------------------------------
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
                '브랜드 추가',
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
}