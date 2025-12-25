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
  final String documentID='';


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
            Text(
              widget.category,
              style: TextStyle(
                color: Colors.black,
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

                        var document = subDoc.id;



                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('삭제 확인'),
                              content: Text(
                                widget.grade == 1
                                    ? '해당차종을 삭제하시겠습니까?'
                                    : '브랜드 밖으로 빼면서\n삭제시스템 폐기함\n팀장님께 삭제 문의하세요',
                              ),
                              actions: [
                                // ✅ grade == 1 일 때만 확인 버튼 표시
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
}
