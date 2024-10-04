import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'gongji_detail_view.dart';
import 'gongji_select_category_list_card.dart';
import 'manageGongji.dart';

class ManageSelectCategory extends StatefulWidget {
  String category;
  String documentID;
  String name;

  ManageSelectCategory(
      {super.key,
        required this.category,
        required this.documentID,
        required this.name});

  @override
  State<ManageSelectCategory> createState() => _ManageSelectCategoryState();
}

class _ManageSelectCategoryState extends State<ManageSelectCategory> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('gongji')
            .doc(widget.documentID)
            .collection('List')
            .orderBy('createdAt')
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index].data(); // 문서 데이터 가져오기
              Timestamp? timestamp = data['createdAt'];
              // timestamp가 null일 경우 9월 1일로 설정
              DateTime date = (timestamp != null) ? timestamp.toDate() : DateTime(2023, 9, 1);
              // 날짜 형식으로 변환
              String formattedDate = DateFormat('yyyy.MM.dd').format(date);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GongjiDetailView(
                            category: widget.category,
                            subject: docs[index]['subject'],
                            writer: docs[index]['writer'],
                            contents: docs[index]['contents'],
                            docId: docs[index].id,
                            categoryDocId: widget.documentID,
                            imageUrls: docs[index]['images'] != null
                                ? Map<String, String>.from(docs[index]['images'])
                                : {},
                            formattedDate: formattedDate, // null일 때 빈 Map을 전달
                          ),
                        ),
                      );
                    },
                    child: ManageSelectCategoryCard(
                      subject: docs[index]['subject'],
                      date: formattedDate,
                    ),
                  ),
                ),
              );
            },
          );
        },
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManageGongji(
                      subject: widget.category,
                      docId: widget.documentID,
                      name: widget.name,
                    ),
                  ),
                );
              },
              child: Text('글쓰기'),
            ),
          ),
        ],
      ),
      color: Colors.white,
    );
  }

}
