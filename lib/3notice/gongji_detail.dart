import 'package:flutter/material.dart';

class GongjiDetail extends StatelessWidget {
  final String writer;
  final String formattedDate;
  final String contents;
  final String subject;
  Map<String, String>? imageUrls; // nullable로 정의


  GongjiDetail({
    super.key,
    required this.writer,
    required this.formattedDate,
    required this.contents,
    required this.subject,
    required this.imageUrls,

  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '공지사항',
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
                    '작성일: $formattedDate',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
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

                Column( // 여러 위젯을 세로로 배치하기 위해 Column 사용
                  children: [
                    for (String key in imageUrls!.keys.toList()..sort((a, b) => int.parse(a).compareTo(int.parse(b)))) ...[
                      Container(
                        width: double.infinity, // 가로 길이를 화면에 맞추기 위해 설정
                        child: Image.network(
                          imageUrls![key]!, // 네트워크 이미지 URL
                          fit: BoxFit.contain, // 이미지를 화면에 맞춰 늘림, 비율 유지
                        ),
                      ),
                      SizedBox(height: 30), // 이미지 사이 간격

                      Divider(
                        color: Colors.black,
                        thickness: 30.0, // 원하는 두께 값 설정
                      ),


                      SizedBox(height: 10), // 이미지 사이 간격
                    ],
                  ],
                ),

            ],
          ),
        ),
      ),
    );
  }
}
