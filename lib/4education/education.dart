import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'education_card.dart';
import 'education_detail.dart';

class Education extends StatefulWidget {
  const Education({super.key});

  @override
  State<Education> createState() => _EducationState();
}

class _EducationState extends State<Education> {
  String collectionAddress = '0oB68hipcx7qvyDunh4F';
  String category = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          color: Color(0xFFFFE0B2), // 살색 배경
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('education')
                .orderBy('createdAt')
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('에러가 발생했습니다: ${snapshot.error}'),
                );
              }

              final docs = snapshot.data!.docs;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: docs.map<Widget>((doc) {
                    // 각 문서에서 category 필드 값을 가져옵니다.
                    final String localcategory = doc['category'];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            collectionAddress = doc.id;
                            category = localcategory;
                          });
                        },
                        child: Text(
                          localcategory,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: EduList(
            collectionAddress: collectionAddress,
            category: category,
          ),
        ),
      ],
    );
  }
}

class EduList extends StatelessWidget {
  String collectionAddress;
  String category;

  EduList({super.key, required this.collectionAddress,
    required this.category});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('education')
          .doc(collectionAddress)
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
                        builder: (context) => EducationDetail(
                          category: category,
                          subject: docs[index]['subject'],
                          writer: docs[index]['writer'],
                          contents: docs[index]['contents'],
                          docId: docs[index].id,
                          categoryDocId:collectionAddress,
                          imageUrls: docs[index]['images'] != null
                              ? Map<String, String>.from(docs[index]['images'])
                              : {}, // null일 때 빈 Map을 전달


                        ),
                      ),
                    );
                  },
                  child: EducationCard(
                    subject: docs[index]['subject'],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
