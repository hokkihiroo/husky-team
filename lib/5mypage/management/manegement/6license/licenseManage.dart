import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LicenseManage extends StatefulWidget {
  final String name;

  const LicenseManage({
    super.key,
    required this.name,
  });

  @override
  State<LicenseManage> createState() => _LicenseManageState();
}

class _LicenseManageState extends State<LicenseManage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '운전면허관리',
          style: TextStyle(
            color: Colors.white, // 텍스트를 흰색으로 변경
            fontWeight: FontWeight.bold, // 굵은 글씨
            fontSize: 20, // 텍스트 크기 증가
            letterSpacing: 1.2, // 글자 간격 추가
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        // 아이콘 색상 변경
        centerTitle: true,
        // 제목 중앙 정렬
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.black], // 그라데이션 색상
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3), // 그림자 색상
                offset: Offset(0, 4), // 그림자 위치
                blurRadius: 10, // 그림자 흐림 정도
              ),
            ],
          ),
        ),
        elevation: 0, // AppBar 그림자 제거
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            color: Color(0xFFFFE0B2), // 살색 배경
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('insa')
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

                final filteredDocs = docs.where((doc) => doc.id != "3LDEwvJicNKtzDemmHY6").toList();



                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: filteredDocs.map<Widget>((doc) {
                      // 각 문서에서 category 필드 값을 가져옵니다.
                      final String name = doc['name'];
                      final String position = doc['position'];

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              // collectionAddress = doc.id;
                              // category = localcategory;


                            });
                          },
                          child: Text(
                            '$position$name',
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
        ],
      ),
    );
  }
}
