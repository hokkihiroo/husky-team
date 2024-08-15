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

  String memberId = ''; //직원 문서아이디
  String memberName = ''; //직원 이름
  String memberPosition = ''; //직원 하는일
  String upgradePosition = ''; //직원 하는일
  String memberGrade = ''; //직원직책
  String updateGrade = ''; //직원 바뀐직책
  Timestamp memberEnter = Timestamp.now();
  String image = '';
  String picUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar 추가
        title: Text(
          '인사/직책변경',
          style: TextStyle(
            color: Colors.black,
          ),
        ), // 앱 바
        centerTitle: true,
        // 제목 설정
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
                      'position': doc['position'],
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
                        image: Image.asset(docs[index]['image']),
                        name: docs[index]['name'],
                        position: docs[index]['position'],
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
                    .orderBy('enterDay')
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
                  return  Column(
                    children: docs.map((subDoc) {
                      var data = subDoc.data() ?? {};

                      return GestureDetector(
                        onTap: () async {
                          memberId = subDoc.id;
                          memberName = data['name'];
                          memberPosition = data['position'];
                          memberGrade = data['grade'];
                          memberEnter = data['enterDay'];
                          image = data['image'];
                          picUrl = data['picUrl'];

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return MoveInsaButton(
                                teamList,
                                memberId,
                                memberName,
                                memberPosition,
                                memberGrade,
                                docId,
                                memberEnter,
                                image,
                                picUrl,
                              );
                            },
                          );
                        },
                        child: MoveMemberCard(
                          name: data['name'] ?? '',
                          team: data['grade'] ?? '',
                          position: data['position'] ?? '',
                        ),
                      );
                    }).toList(),
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
    Timestamp memberEnter,
    String image,
    String picUrl,
  ) {
    return AlertDialog(
      title: Center(
        child: Text(
          '$memberName \n 이동할 팀 선택',
          textAlign: TextAlign.center,
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(memberName),
                      content: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 200,
                        child: Column(
                          children: [
                            Text('현재 직책: $memberGrade'),
                            SizedBox(
                              height: 30,
                            ),
                            TextField(
                              onChanged: (value) {
                                if (value.length <= 4) {
                                  updateGrade =
                                      value; // 텍스트 필드 값이 변경될 때마다 변수에 저장
                                }
                              },
                              maxLength: 4, // 최대 글자 수 제한
                              decoration: InputDecoration(
                                hintText: '새로운 직책', // 힌트 텍스트 설정
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    Navigator.pop(context);

                                    try {
                                      await FirebaseFirestore.instance
                                          .collection(INSA)
                                          .doc(docId)
                                          .collection('list')
                                          .doc(memberId)
                                          .update({
                                        'grade': updateGrade,
                                      });
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                  child: Text('확인'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('취소'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Text('직책변경'),
            ),
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(memberName),
                      content: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 200,
                        child: Column(
                          children: [
                            Text('현재 직책: $memberPosition'),
                            SizedBox(
                              height: 30,
                            ),
                            TextField(
                              onChanged: (value) {
                                if (value.length <= 4) {
                                  upgradePosition =
                                      value; // 텍스트 필드 값이 변경될 때마다 변수에 저장
                                }
                              },
                              maxLength: 4, // 최대 글자 수 제한
                              decoration: InputDecoration(
                                hintText: '새로운 포지션', // 힌트 텍스트 설정
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    Navigator.pop(context);

                                    try {
                                      await FirebaseFirestore.instance
                                          .collection(INSA)
                                          .doc(docId)
                                          .collection('list')
                                          .doc(memberId)
                                          .update({
                                        'position': upgradePosition,
                                      });
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                  child: Text('확인'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('취소'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Text('업무변경'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('취소'),
            ),
          ],
        ),
      ],
      content: Container(
        width: MediaQuery.of(context).size.width / 2,
        height: 300,
        child: ListView.builder(
          itemCount: teamList.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> teamData = teamList[index];
            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    teamData['name'],
                  ),
                  Text(
                    teamData['position'],
                  ),
                ],
              ),
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
                    'enterDay': memberEnter,
                    'image': image,
                    'picUrl': picUrl,
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
