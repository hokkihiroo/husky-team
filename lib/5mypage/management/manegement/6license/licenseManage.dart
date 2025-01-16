import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../mylicense/myLicenseUpdate.dart';
import 'license_card.dart';

class LicenseManage extends StatefulWidget {
  final String name;

   LicenseManage({
    super.key,
    required this.name,
  });

  @override
  State<LicenseManage> createState() => _LicenseManageState();
}

class _LicenseManageState extends State<LicenseManage> {
  String teamId = 'e46miKLAbe8CjR1RsQkR';
  int index=0;

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
            color: Colors.orange, // 살색 배경
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

                final filteredDocs = docs
                    .where((doc) => doc.id != "3LDEwvJicNKtzDemmHY6")
                    .toList();

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
                              teamId = doc.id;
                              print(teamId);
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
          Expanded(
            child: LicenseList(
              teamId: teamId,
              index: index,
            ),
          ),
        ],
      ),
    );
  }
}

class LicenseList extends StatelessWidget {
  String teamId;
  int index;
  bool management = false;


  LicenseList({
    super.key,
    required this.teamId,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('insa')
          .doc(teamId)
          .collection('list')
          .orderBy('levelNumber')
          .snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        final docs = snapshot.data!.docs.where((subDoc) {
          // levelNumber 필드 값 확인 (필드가 없으면 기본값 0)
          final data = subDoc.data();
          final levelNumber = data['levelNumber'] ?? 0;
          return levelNumber != 0; // levelNumber가 0이 아닌 문서만 포함
        }).toList();

        return SingleChildScrollView(
          child: Column(
            children: docs.map((subDoc) {
              index++;
              var data = subDoc.data() ?? {}; // 데이터가 널인 경우 빈 맵 사용
              return GestureDetector(
                onTap: () {

                  print(subDoc.id);


                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyLicenseUpdate(
                        name:data['name'],
                        uid:subDoc.id,
                        team: data['name'],
                        management: management,

                      ),
                    ),
                  );

                },
                child: Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: LicenseCard(
                    index: index,
                    name: data['name'] ?? '',
                    // 이름이 널인 경우 빈 문자열 사용
                    position: data['position'] ?? '',
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

// class LicenseList extends StatelessWidget {
//   String collectionAddress;
//   String category;
//
//   LicenseList(
//       {super.key,
//         required this.collectionAddress,
//         required this.category,
//       });
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: FirebaseFirestore.instance
//           .collection('user')
//           .doc(collectionAddress)
//           .collection('list')
//           .orderBy('createdAt')
//           .snapshots(),
//       builder: (BuildContext context,
//           AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//
//         final docs = snapshot.data!.docs;
//         return ListView.builder(
//           itemCount: docs.length,
//           itemBuilder: (context, index) {
//             return Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10.0),
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 6),
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => EducationDetail(
//                           category: category,
//                           subject: docs[index]['subject'],
//                           writer: docs[index]['writer'],
//                           contents: docs[index]['contents'],
//                           docId: docs[index].id,
//                           categoryDocId: collectionAddress,
//                           imageUrls: docs[index]['images'] != null
//                               ? Map<String, String>.from(docs[index]['images'])
//                               : {}, // null일 때 빈 Map을 전달
//                         ),
//                       ),
//                     );
//                   },
//                   child: EducationCard(
//                     subject: docs[index]['subject'],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
