import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../0adress_const.dart';
import 'brandManage_list_card.dart';

class BrandMansgeList extends StatefulWidget {
  String category;
  String documentID;
  String position;
  String teamId;

  BrandMansgeList({
    super.key,
    required this.category,
    required this.documentID,
    required this.position,
    required this.teamId,
  });

  @override
  State<BrandMansgeList> createState() => _BrandMansgeListState();
}

class _BrandMansgeListState extends State<BrandMansgeList> {
  late String gangnamCarList;

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

    gangnamCarList = getBrandNameList(widget.teamId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              '${widget.position} ${widget.category} 차종',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            GestureDetector(
              onTap: ()async{



                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('삭제 확인'),
                      content: Text('해당 브랜드와 모든 차종을 삭제하시겠습니까?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // 취소
                          },
                          child: Text('취소'),
                        ),
                        TextButton(
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection(gangnamCarList)
                                .doc(widget.documentID)
                                .delete();

                            Navigator.pop(context); // 확인 후 다이얼로그 닫기

                            print('삭제해요');
                            Navigator.pop(context); // 확인 후 다이얼로그 닫기

                          },
                          child: Text('삭제', style: TextStyle(color: Colors.red)),
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
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('삭제 확인'),
                              content: Text('${data['carModel']} 차종을 삭제하시겠습니까?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // 취소
                                  },
                                  child: Text('취소'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection(gangnamCarList)
                                        .doc(widget.documentID)
                                        .collection('LIST')
                                        .doc(subDoc.id)
                                        .delete();

                                    Navigator.pop(context); // 확인 후 다이얼로그 닫기
                                  },
                                  child: Text('삭제', style: TextStyle(color: Colors.red)),
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
