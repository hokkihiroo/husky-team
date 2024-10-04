import 'package:flutter/material.dart';

class EducationDetail extends StatelessWidget {
  String category;
  String subject;
  String writer;
  String contents;
  String docId;
  String categoryDocId;
  Map<String, String>? imageUrls; // nullable로 정의


  EducationDetail({
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
          category,
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
