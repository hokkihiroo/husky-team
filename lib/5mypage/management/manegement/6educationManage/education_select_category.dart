import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'education_making.dart';
import 'education_manage_detail.dart';
import 'education_select_category_card.dart';

class EducationSelectCategory extends StatefulWidget {
  String category;
  String documentID;
  String name;

  EducationSelectCategory(
      {super.key,
      required this.category,
      required this.documentID,
      required this.name});

  @override
  State<EducationSelectCategory> createState() =>
      _EducationSelectCategoryState();
}

class _EducationSelectCategoryState extends State<EducationSelectCategory> {
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
            .collection('education')
            .doc(widget.documentID)
            .collection('list')
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
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EducationManageDetail(
                            category: widget.category,
                            subject: docs[index]['subject'],
                            writer: docs[index]['writer'],
                            contents: docs[index]['contents'],
                            docId: docs[index].id,
                            categoryDocId: widget.documentID,
                            imageUrls: docs[index]['images'] != null
                                ? Map<String, String>.from(docs[index]['images'])
                                : {}, // null일 때 빈 Map을 전달
                          ),
                        ),
                      );
                    },
                    child: EducationSelectCategoryCard(
                      subject: docs[index]['subject'],
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
                    builder: (context) => EducationMaking(
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
