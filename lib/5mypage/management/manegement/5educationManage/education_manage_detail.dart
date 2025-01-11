import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/5mypage/management/manegement/5educationManage/education_manage_detail_screen.dart';

class EducationManageDetail extends StatelessWidget {
  String category;
  String subject;
  String writer;
  String contents;
  String docId;
  String categoryDocId;
  Map<String, String>? imageUrls; // nullable로 정의


  EducationManageDetail({
    super.key,
    required this.category,
    required this.subject,
    required this.writer,
    required this.contents,
    required this.docId,
    required this.categoryDocId,
    required this.imageUrls,
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '카테고리:  $category',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTapDown: (details) {
                      showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(
                            details.globalPosition.dx,
                            details.globalPosition.dy,
                            0,
                            0),
                        items: [
                          PopupMenuItem(
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // 메뉴 닫기

                                // "수정하기" 다이얼로그 띄우기
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Text('수정하시겠습니까?'),
                                      actions: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween, // 좌우 끝에 배치
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(); // 다이얼로그 닫기

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => EditEducationDetailScreen(
                                                      category: category,
                                                      subject: subject,
                                                      writer: writer,
                                                      contents: contents,
                                                      docId: docId,
                                                      categoryDocId: categoryDocId,
                                                    ),
                                                  ),
                                                );




                                              },
                                              child: Text('예'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(); // 다이얼로그 닫기
                                                // "아니오" 선택 시 아무 작업도 하지 않음
                                              },
                                              child: Text('아니오'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text('수정하기'),
                            ),
                          ),
                          PopupMenuItem(
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // 메뉴 닫기

                                // "삭제하기" 확인 다이얼로그 띄우기
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Text('삭제하시겠습니까?'),
                                      actions: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween, // 좌우 끝에 배치
                                          children: [
                                            TextButton(
                                              onPressed: () async {
                                                Navigator.of(context).pop();

                                                try {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                          'education') // 컬렉션 이름을 지정하세요
                                                      .doc(
                                                          categoryDocId) // 삭제할 문서의 ID를 지정하세요
                                                      .collection(
                                                          'list') // 컬렉션 이름을 지정하세요
                                                      .doc(
                                                          docId) // 삭제할 문서의 ID를 지정하세요

                                                      .delete();
                                                  print('문서 삭제 완료');

                                                } catch (e) {
                                                  print('문서 삭제 오류: $e');
                                                }
                                                Navigator.of(context).pop(); // 메뉴 닫기

                                              },
                                              child: Text('예'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // 다이얼로그 닫기
                                                // "아니오" 선택 시 아무 작업도 하지 않음
                                              },
                                              child: Text('아니오'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text('삭제하기'),
                            ),
                          ),
                        ],
                      );
                    },
                    child: Text(
                      '☰', // 줄 세 개가 그어진 이모티콘
                      style: TextStyle(
                        fontSize: 24, // 이모티콘 크기 조절
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: Text(
                  subject,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '작성자: $writer',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Divider(color: Colors.grey[400]),
              SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  contents,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
              ),

              if (imageUrls != null && imageUrls!.isNotEmpty)
                Column(
                  children: [
                    // imageUrls의 키들을 숫자로 변환 후 정렬
                    for (String key in imageUrls!.keys.toList()..sort((a, b) => int.parse(a).compareTo(int.parse(b)))) ...[
                      Container(
                        width: double.infinity,
                        child: Image.network(
                          imageUrls![key]!, // 네트워크 이미지 URL
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 10), // 이미지 사이 간격
                    ],
                  ],
                )


            ],
          ),
        ),
      ),
    );
  }
}
