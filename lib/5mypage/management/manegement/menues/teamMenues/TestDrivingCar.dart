import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:team_husky/5mypage/management/manegement/0adress_const.dart';
import 'package:team_husky/5mypage/management/manegement/menues/teamMenues/TestDrivingCar_Card.dart';

class TestDrivingCar extends StatefulWidget {
  final String teamName;
  final String position;
  final String teamDocId;

  const TestDrivingCar({
    super.key,
    required this.teamName,
    required this.position,
    required this.teamDocId,
  });

  @override
  State<TestDrivingCar> createState() => _GangnamCarState();
}

class _GangnamCarState extends State<TestDrivingCar> {
  late String gangnamCarList;

  String carName = '';
  String carNumber = '';
  String dataId = '';

  static const Color navy = Color(0xFF17233C);
  static const Color navyLight = Color(0xFF253452);
  static const Color gold = Color(0xFFC6A667);
  static const Color goldLight = Color(0xFFE6D19A);
  static const Color background = Color(0xFFF4F5F7);
  static const Color textDark = Color(0xFF303641);
  static const Color textGrey = Color(0xFF737B89);

  @override
  void initState() {
    super.initState();

    gangnamCarList = getGangnamCarList(widget.teamDocId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: navy,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          '${widget.position} ${widget.teamName} 시승차',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection(gangnamCarList)
                  .orderBy('createdAt')
                  .snapshots(),
              builder: (
                  BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
                  ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: navy,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return _buildMessageCard(
                    icon: Icons.error_outline_rounded,
                    title: '차량 정보를 불러올 수 없습니다.',
                    subtitle: '잠시 후 다시 시도해주세요.',
                  );
                }

                final docs = snapshot.data?.docs ?? [];

                return ListView(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    20,
                  ),
                  children: [
                    // 상단 안내 카드
                    Container(
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
                            color: navy.withOpacity(0.18),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.directions_car_filled_rounded,
                              color: goldLight,
                              size: 25,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '시승차 관리',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${widget.position} ${widget.teamName}',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.72),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: gold.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: gold.withOpacity(0.35),
                              ),
                            ),
                            child: Text(
                              '${docs.length}대',
                              style: const TextStyle(
                                color: goldLight,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 섹션 제목
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 18,
                          decoration: BoxDecoration(
                            color: gold,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 9),
                        const Text(
                          '시승차 목록',
                          style: TextStyle(
                            color: textDark,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    if (docs.isEmpty)
                      _buildEmptyCard()
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 2.5,
                        ),
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final doc = docs[index];

                          return GestureDetector(
                            onTap: () {
                              carName = doc['carName'];
                              carNumber = doc['carNumber'];
                              dataId = doc.id;

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return butto(
                                    carName,
                                    carNumber,
                                    dataId,
                                  );
                                },
                              );
                            },
                            child: TestDrivingCarCard(
                              carName: doc['carName'],
                              carNumber: doc['carNumber'],
                            ),
                          );
                        },
                      ),
                  ],
                );
              },
            ),
          ),

          // 하단 차량 추가 버튼
          Container(
            padding: const EdgeInsets.fromLTRB(
              16,
              10,
              16,
              18,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 12,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () {
                  carName = '';
                  carNumber = '';

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return addCar();
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: navy,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                icon: const Icon(
                  Icons.add_rounded,
                  size: 22,
                ),
                label: const Text(
                  '차량 추가',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 차량이 없을 때
  Widget _buildEmptyCard() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 40,
        horizontal: 20,
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
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: navy.withOpacity(0.06),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.directions_car_outlined,
              color: navy,
              size: 27,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            '등록된 시승차가 없습니다.',
            style: TextStyle(
              color: textDark,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            '하단의 차량 추가 버튼으로 등록해주세요.',
            style: TextStyle(
              color: textGrey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // 오류 / 상태 카드
  Widget _buildMessageCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: navy,
                size: 34,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: textDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(
                  color: textGrey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 차량 추가 다이얼로그
  Widget addCar() {
    return AlertDialog(
      backgroundColor: Colors.white,
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
        22,
        0,
        22,
        20,
      ),
      title: Row(
        children: [
          Container(
            width: 4,
            height: 22,
            decoration: BoxDecoration(
              color: gold,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            '시승차 추가',
            style: TextStyle(
              color: textDark,
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),

          TextField(
            autofocus: true,
            onChanged: (value) {
              carName = value;
            },
            decoration: InputDecoration(
              labelText: '차종',
              hintText: '차량명을 입력하세요',
              prefixIcon: const Icon(
                Icons.directions_car_outlined,
                color: navy,
              ),
              filled: true,
              fillColor: const Color(0xFFF6F7F9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: const BorderSide(
                  color: gold,
                  width: 1.3,
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          TextField(
            onChanged: (value) {
              carNumber = value;
            },
            decoration: InputDecoration(
              labelText: '차량번호',
              hintText: '차량번호를 입력하세요',
              prefixIcon: const Icon(
                Icons.pin_outlined,
                color: navy,
              ),
              filled: true,
              fillColor: const Color(0xFFF6F7F9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: const BorderSide(
                  color: gold,
                  width: 1.3,
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
                height: 48,
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
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    String documentId = FirebaseFirestore.instance
                        .collection(gangnamCarList)
                        .doc()
                        .id;

                    try {
                      await FirebaseFirestore.instance
                          .collection(gangnamCarList)
                          .doc(documentId)
                          .set({
                        'carName': carName,
                        'carNumber': carNumber,
                        'createdAt': FieldValue.serverTimestamp(),
                        'oilCount': '0',
                      });
                    } catch (e) {
                      print('차량 추가 오류: $e');
                    }

                    Navigator.pop(context);
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
                    '입력',
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
  }

  // 차량 삭제 다이얼로그
  Widget butto(
      String carName,
      String carNumber,
      String dataId,
      ) {
    return AlertDialog(
      backgroundColor: Colors.white,
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
        22,
        0,
        22,
        20,
      ),
      title: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: navy.withOpacity(0.07),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.directions_car_rounded,
              color: navy,
              size: 27,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            '시승차 관리',
            style: TextStyle(
              color: textDark,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            carName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: textDark,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            carNumber,
            style: const TextStyle(
              color: textGrey,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      content: const Text(
        '등록된 시승차를 삭제하시겠습니까?',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textGrey,
          fontSize: 13,
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
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
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await FirebaseFirestore.instance
                          .collection(gangnamCarList)
                          .doc(dataId)
                          .delete();

                      print('문서 삭제 완료');

                      Navigator.pop(context);
                    } catch (e) {
                      print('문서 삭제 오류: $e');
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
                    '삭제',
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
  }
}