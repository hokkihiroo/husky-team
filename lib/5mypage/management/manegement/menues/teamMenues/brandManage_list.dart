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

  void _showDialog() {
    final TextEditingController _textFieldController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '차종추가',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "입력"),
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    String inputText = _textFieldController.text;
                    String documentId = FirebaseFirestore.instance
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
                        'createdAt': FieldValue.serverTimestamp(),
                      });
                    } catch (e) {}
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
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
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
              child: Text(
                widget.category,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            GestureDetector(
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('확인사항'),
                        content: Text('브랜드 밖으로 빼면서\n해당시스템 위험하여 폐기함'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // 취소
                            },
                            child: Text('확인'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('일괄삭제')),
          ],
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(gangnamCarList)
                  .doc(widget.documentID)
                  .collection('LIST')
                  .orderBy('createdAt')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                final subDocs = snapshot.data!.docs;

                // 바뀐 부분: ListView 대신 Column을 사용하여 하위 컬렉션의 데이터를 표시
                return Column(
                  children: subDocs.map((subDoc) {
                    var data = subDoc.data() ?? {}; // 데이터가 널인 경우 빈 맵 사용
                    return GestureDetector(
                      onTap: () async {
                        final document = subDoc.id;

                        showDialog(
                          context: context,
                          builder: (dialogContext) {
                            return AlertDialog(
                              title: const Text('작업 선택'),
                              content: const Text('원하시는 작업을 선택하세요'),
                              actions: [
                                /// ✏️ 수정
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(dialogContext); // 선택창 닫기
                                    showEditDialog(
                                        context, document); // 수정 다이얼로그
                                  },
                                  child: const Text(
                                    '수정',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),

                                /// 🗑 삭제
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(dialogContext); // 선택창 닫기
                                    showDeleteConfirmDialog(
                                        context, document); // 삭제 확인
                                  },
                                  child: const Text(
                                    '삭제',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),

                                /// 취소
                                TextButton(
                                  onPressed: () => Navigator.pop(dialogContext),
                                  child: const Text('취소'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 4.0),
                        child: BrandManageListCard(
                          carModel: data['carModel'],
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
              child: Text('차종추가'),
            ),
          ),
        ],
      ),
      color: Colors.white,
    );
  }

  //브랜드 수정하기 기능
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
          title: const Text(
            '카테고리 수정',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: controller,
            maxLength: 6, // ✅ 최대 5글자
            decoration: const InputDecoration(
              hintText: '최대 6글자 입력',
              counterText: '', // 글자수 표시 제거 (선택)
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                final value = controller.text.trim();

                if (value.isEmpty) return; // 빈값 방지 (선택)

                onSave(value); // 🔥 여기서 Firestore update 연결
                Navigator.pop(dialogContext);
              },
              child: const Text('수정'),
            ),
          ],
        );
      },
    );
  }

  void showDeleteConfirmDialog(BuildContext context, String document) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('삭제 확인'),
          content: Text(
            widget.grade == 1
                ? '해당 차종을 삭제하시겠습니까?'
                : '브랜드 밖으로 빼면서\n삭제 시스템 폐기함\n팀장님께 문의하세요',
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

                    Navigator.pop(dialogContext); // 삭제 다이얼로그 닫기
                  } catch (e) {
                    print('❌ 삭제 에러: $e');
                  }
                },
                child: const Text(
                  '확인',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('취소'),
            ),
          ],
        );
      },
    );
  }

  void showEditDialog(BuildContext context, String document) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('차종 수정'),
          content: TextField(
            controller: controller,
            maxLength: 7,
            decoration: const InputDecoration(
              hintText: '최대 7글자',
              counterText: '',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final newValue = controller.text.trim();
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
                Navigator.pop(dialogContext); //
              },
              child: const Text('저장'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('취소'),
            ),
          ],
        );
      },
    );
  }
}
