import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:team_husky/5mypage/management/manegement/menues/teamMenues/forGenesis_card.dart';

import '../../0adress_const.dart';

class ForGenesis extends StatefulWidget {
  final String teamDocId;

  const ForGenesis({super.key, required this.teamDocId});

  @override
  State<ForGenesis> createState() => _ForGenesisState();
}

class _ForGenesisState extends State<ForGenesis> {
  late String field; // 전역 변수로 선언
  final List<String> categories = [
    '60',
    '70',
    '80',
    '90',
  ];
  String selectedCategory = '80'; // ✅ 선택된 값 저장
  int selectedCategoryNum = 3; //80이 제일 자주 사용하니 80으로 고정해둠 80이 3번임

  final TextEditingController carModelController = TextEditingController();
  final TextEditingController carNumberController = TextEditingController();

  @override
  void dispose() {
    carModelController.dispose();
    carNumberController.dispose();
    super.dispose();
  }

//시승차 추가 코드
  void _showDialog() {
      carModelController.clear();
      carNumberController.clear();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                '시승차종',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: carModelController,
                    maxLength: 8,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(8),
                    ],
                    decoration: const InputDecoration(
                      hintText: "시승차종",
                      counterStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  TextField(
                    controller: carNumberController,
                    maxLength: 4,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(4),
                    ],
                    decoration: const InputDecoration(
                      hintText: "시승차번호",
                      counterStyle: TextStyle(color: Colors.grey),
                    ),
                  )
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        String carModel = carModelController.text;
                        String carNumber = carNumberController.text;

                        String documentId = FirebaseFirestore.instance
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
                            //자가주차하면 여기에 자가라고 들어가게함 *고객차한정*
                            'name': '',
                            'createdAt': FieldValue.serverTimestamp(),
                            'location': 11,
                            'color': 5,
                            'etc': '',
                            'movedLocation': '입차',
                            'wigetName': '',
                            'movingTime': '',
                            'carBrand': '제네시스',
                            'carModel': carModel,
                            'option1': '',
                            //필드에 있는 옵션1은 컬러5에 넣을 문서데이터저장
                            'option2': '',
                            //하이패스
                            'option3': '',
                            //기름잔량
                            'option4': '',
                            //총거리
                            'option5': '',
                            //시승차 기타
                            'option6': '',
                            //최근 3종 변경자 이름
                            'option7': selectedCategoryNum,
                            //시승차 타입 (고객= 0 시승차 60= 1 70=2 80=3 90=4
                            'option8': '',
                            'option9': '',
                            'option10': '',
                            'option11': '',
                            'option12': '',
                          });
                        } catch (e) {
                          print('저장 에러: $e');
                        }
                        Navigator.of(context).pop();

                      },
                      child: Text('확인'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('취소'),
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

    field = getForFieldAdress(widget.teamDocId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '시승차관리(제네시스전용)',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Wrap(
                  // ✅ 가로로 배치, 공간 부족하면 자동 줄바꿈
                  spacing: 8, // ✅ 칩 간격
                  children: categories.map((category) {
                    return ChoiceChip(
                      label: Text(category),
                      // ✅ 칩 이름
                      labelStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: selectedCategory == category
                            ? Colors.white // ✅ 선택된 칩 글씨색
                            : Colors.grey.shade700, // ✅ 기본 글씨색
                      ),
                      selected: selectedCategory == category,
                      // ✅ 선택 상태 반영
                      selectedColor: Colors.green.shade400,
                      // ✅ 선택된 칩 배경
                      backgroundColor: Colors.grey.shade200,
                      // ✅ 기본 배경
                      onSelected: (bool selected) {
                        setState(() {
                          selectedCategory = category; // ✅ 선택값 업데이트
                          print("선택된 카테고리: $selectedCategory");

                          // ✅ 선택된 카테고리에 따라 번호 매핑
                          if (selectedCategory == '60') {
                            selectedCategoryNum = 1;
                          } else if (selectedCategory == '70') {
                            selectedCategoryNum = 2;
                          } else if (selectedCategory == '80') {
                            selectedCategoryNum = 3;
                          } else if (selectedCategory == '90') {
                            selectedCategoryNum = 4;
                          }

                          print("카테고리 번호: $selectedCategoryNum");
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(field)
                  .where('option7', isEqualTo: selectedCategoryNum)
                  .orderBy('createdAt')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                // ✅ 데이터가 없는 경우 처리
                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(child: Text("데이터가 없습니다."));
                }
                final subDocs = snapshot.data!.docs;

                // 바뀐 부분: ListView 대신 Column을 사용하여 하위 컬렉션의 데이터를 표시
                return Column(
                  children: subDocs.map((subDoc) {
                    var data = subDoc.data() ?? {}; // 데이터가 널인 경우 빈 맵 사용
                    return GestureDetector(
                      onTap: () async {
                        var document = subDoc.id;

                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('삭제 확인'),
                              content: Text('해당차종을 삭제하시겠습니까?'),
                              actions: [
                                // ✅ grade == 1 일 때만 확인 버튼 표시
                                TextButton(
                                  onPressed: () async {
                                    try {
                                      await FirebaseFirestore.instance
                                          .collection(field)
                                          .doc(document)
                                          .update({
                                        'location': 14,       //location이 13이면 외부주차장으로보이고 14면 필드에서 사라짐
                                        'option7': 5,         // option7  이 0은 고객차 1은 60이고 4가 90임
                                                              // 5로 바꾸면 시승차관리 페이지에서도 사라지게해둠
                                      });

                                      Navigator.pop(context); // 다이얼로그 닫기
                                    } catch (e) {
                                      print('❌ 삭제 에러: $e');
                                    }
                                  },
                                  child: const Text(
                                    '확인',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),

                                // 취소 버튼 (항상 존재)
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    '취소',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        // 👈 카드 사이 간격
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

  Widget bottomOne() {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(fontWeight: FontWeight.w800, fontSize: 25),
              ),
              onPressed: () {
                _showDialog();
              },
              child: Text('시승차 추가'),
            ),
          ),
        ],
      ),
      color: Colors.white,
    );
  }
}
