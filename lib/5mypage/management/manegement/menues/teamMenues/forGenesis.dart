import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:team_husky/5mypage/management/manegement/menues/teamMenues/forGenesis_card.dart';

import '../../0adress_const.dart';

class ForGenesis extends StatefulWidget {
  final String teamDocId;

  const ForGenesis({
    super.key,
    required this.teamDocId,
  });

  @override
  State<ForGenesis> createState() => _ForGenesisState();
}

class _ForGenesisState extends State<ForGenesis> {
  late String field;

  final List<String> categories = [
    '60',
    '70',
    '80',
    '90',
  ];

  String selectedCategory = '80';
  int selectedCategoryNum = 3;

  final TextEditingController carModelController = TextEditingController();
  final TextEditingController carNumberController = TextEditingController();

  String thisMonth = '';

  // 디자인 색상
  static const Color navy = Color(0xFF17233C);
  static const Color navyLight = Color(0xFF253452);
  static const Color gold = Color(0xFFC6A667);
  static const Color goldLight = Color(0xFFE6D19A);
  static const Color textDark = Color(0xFF303641);
  static const Color textGrey = Color(0xFF737B89);
  static const Color background = Color(0xFFF4F5F7);

  @override
  void dispose() {
    carModelController.dispose();
    carNumberController.dispose();
    super.dispose();
  }

  // 시승차 추가
  void _showDialog() {
    carModelController.clear();
    carNumberController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              titlePadding: const EdgeInsets.fromLTRB(
                22,
                22,
                22,
                8,
              ),
              contentPadding: const EdgeInsets.fromLTRB(
                22,
                8,
                22,
                10,
              ),
              actionsPadding: const EdgeInsets.fromLTRB(
                16,
                4,
                16,
                16,
              ),
              title: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: navy.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.directions_car_rounded,
                      color: navy,
                      size: 21,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    '시승차 추가',
                    style: TextStyle(
                      color: textDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 19,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '차량 정보를 입력해주세요.',
                    style: TextStyle(
                      color: textGrey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 시승차종
                  TextField(
                    controller: carModelController,
                    maxLength: 8,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(8),
                    ],
                    decoration: InputDecoration(
                      labelText: '시승차종',
                      hintText: '예: GV80',
                      counterStyle: const TextStyle(
                        color: textGrey,
                        fontSize: 11,
                      ),
                      filled: true,
                      fillColor: background,
                      prefixIcon: const Icon(
                        Icons.directions_car_outlined,
                        color: navy,
                        size: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: const BorderSide(
                          color: gold,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // 시승차번호
                  TextField(
                    controller: carNumberController,
                    maxLength: 4,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(4),
                    ],
                    decoration: InputDecoration(
                      labelText: '시승차번호',
                      hintText: '예: 1234',
                      counterStyle: const TextStyle(
                        color: textGrey,
                        fontSize: 11,
                      ),
                      filled: true,
                      fillColor: background,
                      prefixIcon: const Icon(
                        Icons.confirmation_number_outlined,
                        color: navy,
                        size: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: const BorderSide(
                          color: gold,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 45,
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
                            '취소',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () async {
                            String carModel = carModelController.text;
                            String carNumber = carNumberController.text;

                            String documentId = FirebaseFirestore
                                .instance
                                .collection(field)
                                .doc()
                                .id;

                            try {
                              await FirebaseFirestore.instance
                                  .collection(field)
                                  .doc(documentId)
                                  .set({
                                'carNumber': carNumber,
                                'enterName': '',
                                'name': '',
                                'createdAt':
                                FieldValue.serverTimestamp(),
                                'location': 11,
                                'color': 5,
                                'etc': '',
                                'movedLocation': '입차',
                                'wigetName': '',
                                'movingTime': '',
                                'carBrand': '제네시스',
                                'carModel': carModel,
                                'option1': '',
                                'option2': '',
                                'option3': '',
                                'option4': '',
                                'option5': '',
                                'option6': '',
                                'option7': selectedCategoryNum,
                                'option8': '',
                                'option9': '',
                                'option10':
                                FieldValue.serverTimestamp(),
                                'option11': '',
                                'option12': '',
                              });
                            } catch (e) {
                              print('저장 에러: $e');
                            }

                            Navigator.of(context).pop();

                            try {
                              await FirebaseFirestore.instance
                                  .collection(field)
                                  .doc(documentId)
                                  .collection(thisMonth)
                                  .doc()
                                  .set({
                                'createdAt':
                                FieldValue.serverTimestamp(),
                                'name': '',
                                'color': '',
                                'location': '',
                                'state': '시승차량입고',
                                'wayToDrive': '',
                              });
                            } catch (e) {
                              print('저장 에러: $e');
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
                          child: const Text(
                            '확인',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
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

    field = getForFieldAdress(widget.teamDocId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      // 상단 AppBar
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: navy,
        foregroundColor: Colors.white,
        title: const Text(
          '시승차관리(제네시스전용)',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          100,
        ),
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
                      Icons.auto_awesome_rounded,
                      color: gold,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 13),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '제네시스 시승차',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          '시승차 타입을 선택하여 차량을 관리하세요.',
                          style: TextStyle(
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

            const SizedBox(height: 20),

            // 시승차 타입 제목
            const Text(
              '시승차 타입',
              style: TextStyle(
                color: textDark,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            // 카테고리 선택
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFE2E5EA),
                ),
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

                          if (selectedCategory == '60') {
                            selectedCategoryNum = 1;
                          } else if (selectedCategory == '70') {
                            selectedCategoryNum = 2;
                          } else if (selectedCategory == '80') {
                            selectedCategoryNum = 3;
                          } else if (selectedCategory == '90') {
                            selectedCategoryNum = 4;
                          }
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? navy
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          category,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : textGrey,
                            fontSize: 14,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // 차량 목록 제목
            Row(
              children: [
                const Text(
                  '차량 목록',
                  style: TextStyle(
                    color: textDark,
                    fontSize: 16,
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

            const SizedBox(height: 8),

            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(field)
                  .where(
                'option7',
                isEqualTo: selectedCategoryNum,
              )
                  .orderBy('createdAt')
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
                    text: '차량 정보를 불러오지 못했습니다.',
                  );
                }

                if (!snapshot.hasData ||
                    snapshot.data == null) {
                  return _emptyCard(
                    icon: Icons.directions_car_outlined,
                    text: '데이터가 없습니다.',
                  );
                }

                final subDocs = snapshot.data!.docs;

                if (subDocs.isEmpty) {
                  return _emptyCard(
                    icon: Icons.directions_car_outlined,
                    text: '등록된 시승차가 없습니다.',
                  );
                }

                return Column(
                  children: subDocs.map((subDoc) {
                    var data = subDoc.data();

                    return GestureDetector(
                      onTap: () async {
                        var document = subDoc.id;

                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              surfaceTintColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(18),
                              ),
                              title: Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: Colors.red
                                          .withOpacity(0.08),
                                      borderRadius:
                                      BorderRadius.circular(11),
                                    ),
                                    child: const Icon(
                                      Icons.delete_outline_rounded,
                                      color: Colors.red,
                                      size: 21,
                                    ),
                                  ),
                                  const SizedBox(width: 11),
                                  const Text(
                                    '삭제 확인',
                                    style: TextStyle(
                                      color: textDark,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              content: const Text(
                                '해당 차종을 삭제하시겠습니까?',
                                style: TextStyle(
                                  color: textGrey,
                                  fontSize: 14,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    try {
                                      await FirebaseFirestore
                                          .instance
                                          .collection(field)
                                          .doc(document)
                                          .update({
                                        'location': 14,
                                        'option7': 5,
                                      });

                                      Navigator.pop(context);
                                    } catch (e) {
                                      print('❌ 삭제 에러: $e');
                                    }
                                  },
                                  child: const Text(
                                    '확인',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    '취소',
                                    style: TextStyle(
                                      color: textGrey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        child: ForgenesisCard(
                          carModel: data['carModel'],
                          carNumber: data['carNumber'],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),

      bottomNavigationBar: bottomOne(),
    );
  }

  Widget _emptyCard({
    required IconData icon,
    required String text,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 5),
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

  Widget bottomOne() {
    return BottomAppBar(
      color: Colors.white,
      elevation: 10,
      surfaceTintColor: Colors.white,
      padding: const EdgeInsets.fromLTRB(
        12,
        8,
        12,
        10,
      ),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            _showDialog();

            thisMonth = carStateAddress();

            print(thisMonth);
          },
          icon: const Icon(
            Icons.add_rounded,
            size: 22,
          ),
          label: const Text(
            '시승차 추가',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: navy,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }
}