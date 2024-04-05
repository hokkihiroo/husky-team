import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/1insa/Address.dart';
import 'package:team_husky/5mypage/management/manegement/0adress_const.dart';
import 'package:team_husky/5mypage/management/manegement/2moveInsaCard.dart';
import 'package:team_husky/5mypage/management/manegement/2moveMemberCard.dart';

class MoveInsa extends StatefulWidget {
  const MoveInsa({Key? key});

  @override
  State<MoveInsa> createState() => _MoveInsaState();
}

class _MoveInsaState extends State<MoveInsa> {
  String docId = '';
  List<Map<String, dynamic>> teamList = [];
  List<Map<String, dynamic>> memberList = [];

  String memberId = '';
  String memberName = '';
  String memberPosition = '';
  String memberGrade = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar 추가
        title: Text(
          '인사이동',
          style: TextStyle(
            color: Colors.black,
          ),
        ), // 앱 바 제목 설정
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(INSA)
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
                // teamList가 비어있을 때만 데이터를 채움
                if (teamList.isEmpty) {
                  // 여기 수정
                  for (var doc in docs) {
                    Map<String, dynamic> data = {
                      'name': doc['name'],
                      'docId': doc['docId'],
                    };
                    teamList.add(data);
                  }
                } // 여기 수정
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 한 줄에 표시할 개수 설정
                    crossAxisSpacing: 3, // 가로 간격 설정
                    mainAxisSpacing: 3, // 세로 간격 설정
                  ),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        setState(() {
                          docId = docs[index]['docId'];
                          print(docId);
                        });

                        // 활성화 시키면 bar 가 바뀜 데이터 클릭시마다
                      },
                      child: MoveInsaCard(
                        name: docs[index]['name'],
                        image: Image.asset(docs[index]['image']),
                      ),
                    );
                  },
                );
              },
            ),
            Divider(
              color: Colors.black,
              height: 1,
              thickness: 1,
            ),
            if (docId.isNotEmpty)
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(INSA)
                    .doc(docId)
                    .collection('list')
                    // .orderBy('createdAt')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final docs = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    // 리스트뷰가 컨테이너의 크기에 맞게 축소될 수 있도록 설정
                    // 스크롤 불가능하도록 설정
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      // 2단계 컬렉션의 데이터를 표시하는 위젯 반환
                      var data = docs[index].data() ?? {}; // 데이터가 널인 경우 빈 맵을 사용
                      return GestureDetector(
                        onTap: () async {
                          var document = docs[index];
                          memberId = document.id;
                          memberName = docs[index]['name'];
                          memberPosition = docs[index]['position'];
                          memberGrade = docs[index]['grade'];

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return MoveInsaButton(
                                  teamList,
                                  memberId,
                                  memberName,
                                  memberPosition,
                                  memberGrade,
                                  docId);
                            },
                          );
                        },
                        child: MoveMemberCard(
                          name: data['name'] ?? '',
                          team: data['grade'] ?? '',
                          position: data['position'] ?? '',
                        ),
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget MoveInsaButton(
    List<Map<String, dynamic>> teamList,
    String memberId,
    String memberName,
    String memberPosition,
    String memberGrade,
    String docId,
  ) {
    return AlertDialog(
      title: Text('이동할 팀 선택'),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: 300,
        child: ListView.builder(
          itemCount: teamList.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> teamData = teamList[index];
            return ListTile(
              title: Text(teamData['name']),
              onTap: () async {
                // 특정 팀을 선택했을 때 수행할 동작 추가
                // 예: 선택한 팀의 정보를 활용하여 다른 작업을 수행할 수 있음
                try {
                  await FirebaseFirestore.instance
                      .collection(INSA)
                      .doc(docId)
                      .collection('list')
                      .doc(memberId)
                      .delete();
                  print('문서 삭제 완료');
                } catch (e) {
                  print('문서 삭제 오류: $e');
                }

                try {
                  await FirebaseFirestore.instance
                      .collection(INSA)
                      .doc(teamData['docId'])
                      .collection('list')
                      .doc(memberId)
                      .set({
                    'grade': memberGrade,
                    'name': memberName,
                    'position': memberPosition,
                  });
                } catch (e) {
                  print(e);
                }

                print('선택한 팀: ${teamData['name']}');

                // 여기에 선택한 팀에 대한 추가 작업 추가
                Navigator.pop(context); // 다이얼로그 닫기
              },
            );
          },
        ),
      ),
    );
  }
}
