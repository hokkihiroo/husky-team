import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:team_husky/2car_management_system/team2/team2_adress_const.dart';

import '../../0adress_const.dart';
import 'brandManage_card.dart';
import 'brandManage_list.dart';

class BrandManage extends StatefulWidget {
  final String teamName;
  final String position;
  final String teamDocId;

  const BrandManage(
      {super.key,
      required this.teamName,
      required this.position,
      required this.teamDocId});

  @override
  State<BrandManage> createState() => _BrandManageState();
}

class _BrandManageState extends State<BrandManage> {
  late String gangnamCarList; // 전역 변수로 선언
  String? documentID = '';

  void _showDialog() {
    final TextEditingController _textFieldController = TextEditingController();
    String selectedCategory = '국내'; // 기본 선택값

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                '브랜드이름',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _textFieldController,
                    decoration: InputDecoration(hintText: "브랜드명 입력"),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        '카테고리: ',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 10),
                      DropdownButton<String>(
                        value: selectedCategory,
                        items: ['국내', '수입유명', '잡브랜드']
                            .map((label) => DropdownMenuItem(
                                  value: label,
                                  child: Text(label),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedCategory = value;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        String inputText = _textFieldController.text;

                        // 카테고리 숫자 변환
                        int brandTypeValue;
                        switch (selectedCategory) {
                          case '국내':
                            brandTypeValue = 1;
                            break;
                          case '수입유명':
                            brandTypeValue = 2;
                            break;
                          case '잡브랜드':
                            brandTypeValue = 3;
                            break;
                          default:
                            brandTypeValue = 0; // 예외처리용
                        }

                        String documentId = FirebaseFirestore.instance
                            .collection(gangnamCarList)
                            .doc()
                            .id;

                        try {
                          await FirebaseFirestore.instance
                              .collection(gangnamCarList)
                              .doc(documentId)
                              .set({
                            'category': inputText,
                            'brandType': brandTypeValue, // 숫자로 저장
                            'createdAt': FieldValue.serverTimestamp(),
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

    gangnamCarList = getBrandNameList(widget.teamDocId);
  }

  // 버튼 상태 (3개니까 false 3개로 초기화)
  String selectedCategory = '국산'; // ✅ 선택된 값 저장
  final List<String> categories = ['국산', '수입', '기타'];
  int selectedCategoryNum = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.teamName} ${widget.position} 브랜드',
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
                          if (selectedCategory == '국산') {
                            selectedCategoryNum = 1;
                          } else if (selectedCategory == '수입') {
                            selectedCategoryNum = 2;
                          } else if (selectedCategory == '기타') {
                            selectedCategoryNum = 3;
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
                  .collection(gangnamCarList)
                  .where('brandType', isEqualTo: selectedCategoryNum)
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
                              position: widget.position,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: BrandManageCard(
                          category: data['category'],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),

            // ScheduleList(),
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
              child: Text('브랜드추가'),
            ),
          ),
        ],
      ),
      color: Colors.white,
    );
  }
}
