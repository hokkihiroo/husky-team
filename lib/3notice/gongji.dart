import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:team_husky/3notice/Address.dart';
import 'package:team_husky/3notice/gongjiCard.dart';
import 'package:team_husky/3notice/gongji_detail.dart';

import '../notification.dart';

class Notication extends StatefulWidget {
  const Notication({super.key});

  @override
  State<Notication> createState() => _NoticationState();
}

class _NoticationState extends State<Notication> {
  String formattedDate = '';
  String writer = '';
  String docId = '';
  String contents = '';
  String subject = '';

  Color firstContents = Colors.black;
  Color secondContents = Colors.grey;

// 운영내용 주소
  String operateAddress = 'dj8Jxkbcw5BR16sCF9jg';

// 사건사고 주소
  String issueAddress = 'doQRXV02Lid2jhjQeR99';

  //선택 주소
  String address = 'dj8Jxkbcw5BR16sCF9jg';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white, // 배경색
                border: Border.all(
                  color: firstContents, // 테두리 색상
                  width: 2.0, // 테두리 두께
                ),
                borderRadius: BorderRadius.circular(15.0), // 모서리를 둥글게
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // 그림자 색상 및 투명도
                    spreadRadius: 3, // 그림자 퍼짐 반경
                    blurRadius: 7, // 그림자 흐림 효과
                    offset: Offset(0, 3), // 그림자 위치
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    firstContents = Colors.black;
                    secondContents = Colors.grey;
                    address = operateAddress;
                  });
                },
                child: Text(
                  '운영내용',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: firstContents, // 텍스트 색상
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white, // 배경색
                border: Border.all(
                  color: secondContents, // 테두리 색상
                  width: 2.0, // 테두리 두께
                ),
                borderRadius: BorderRadius.circular(15.0), // 모서리를 둥글게
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // 그림자 색상 및 투명도
                    spreadRadius: 3, // 그림자 퍼짐 반경
                    blurRadius: 7, // 그림자 흐림 효과
                    offset: Offset(0, 3), // 그림자 위치
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    firstContents = Colors.grey;
                    secondContents = Colors.black;
                    address = issueAddress;
                  });
                },
                child: Text(
                  '사건사고',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: secondContents, // 텍스트 색상
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(GONGJI)
                .doc(address)
                .collection('List')
                .orderBy('createdAt', descending: true)
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
                  Timestamp timestamp = docs[index]['createdAt'];
                  DateTime date = timestamp.toDate();
                  formattedDate = DateFormat('yyyy.MM.dd').format(date);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: GestureDetector(
                        onTap: () {
                          writer = docs[index]['writer'];
                          contents = docs[index]['contents'];
                          subject = docs[index]['subject'];
                          Timestamp timestamp = docs[index]['createdAt'];
                          DateTime date = timestamp.toDate();
                          formattedDate = DateFormat('yyyy.MM.dd').format(date);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GongjiDetail(
                                writer: writer,
                                formattedDate: formattedDate,
                                contents: contents,
                                subject: subject,
                                imageUrls: docs[index]['images'] != null
                                    ? Map<String, String>.from(docs[index]['images'])
                                    : {},
                              ),
                            ),
                          );
                        },
                        child: GongjiCard(
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
        ),
      ],
    );
  }
}
