import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:team_husky/4education/education_card.dart';
import 'package:team_husky/5mypage/management/manegement/5educationManage/education_manage_card.dart';

import 'education_select_category.dart';

class EducationManage extends StatefulWidget {
  String name;

  EducationManage({super.key, required this.name});

  @override
  State<EducationManage> createState() => _EducationManageState();
}

class _EducationManageState extends State<EducationManage> {
  String? documentID = '';

  void _showDialog() {
    final TextEditingController _textFieldController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '카테고리명',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "입력"),
            inputFormatters: [
              LengthLimitingTextInputFormatter(5),
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
                        .collection('education')
                        .doc()
                        .id;
                    try {
                      await FirebaseFirestore.instance
                          .collection('education')
                          .doc(documentId)
                          .set({
                        'category': inputText,
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '카테고리선택',
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
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('education')
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
                        var document = subDoc;
                        documentID = document.id;
                        print(documentID);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EducationSelectCategory(
                              category: data['category'],
                              documentID: '$documentID',
                              name: widget.name,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        child: EducationManageCard(
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
              child: Text('카테고리추가'),
            ),
          ),
        ],
      ),
      color: Colors.white,
    );
  }
}
