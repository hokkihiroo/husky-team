import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/5mypage/management/manegement/menues/teamMenues/changeStaffNum_Card.dart';

class ChangeStaffNum extends StatefulWidget {
  final String teamName;
  final String position;
  final String teamDocId;

  const ChangeStaffNum({super.key,
    required this.teamName,
    required this.position,
    required this.teamDocId,
  });

  @override
  State<ChangeStaffNum> createState() => _ChangeStaffNumState();
}

class _ChangeStaffNumState extends State<ChangeStaffNum> {
  List<Map<String, dynamic>> memberList = [];

  String name = '';
  String position = '';
  String grade = '';
  String docId = '';
  int levelNumber = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ' 직원순서 변경',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        // SingleChildScrollView로 감싸기
        child: Container(
          color: Colors.white, // 전체 배경 색상
          padding: const EdgeInsets.all(16.0), // 전체 패딩
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('insa')
                .doc(widget.teamDocId)
                .collection('list')
                .orderBy('levelNumber')
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text('데이터가 없습니다.'),
                );
              }

              final docs = snapshot.data!.docs;
              final filteredDocs =
                  docs.where((doc) => doc['levelNumber'] != 0).toList();

              memberList.clear(); // 이 부분을 넣어서 이전 데이터를 지운 후 새로 추가
              for (var doc in filteredDocs) {
                Map<String, dynamic> data = {
                  'name': doc['name'],
                  'docId': doc.id,
                  'position': doc['position'],
                  'grade': doc['grade'],
                  'levelNumber': doc['levelNumber'],
                };
                memberList.add(data); // memberList에 추가
              }

              return Column(
                children: [
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredDocs.length,
                    itemBuilder: (context, index) {
                      final doc = filteredDocs[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            name = doc['name'] ?? '이름 없음'; // null이면 '이름 없음' 사용
                            grade =
                                doc['grade'] ?? '학년 없음'; // null이면 '학년 없음' 사용
                            position =
                                doc['position'] ?? '직책 없음'; // null이면 '직책 없음' 사용
                            levelNumber =
                                doc['levelNumber'] ?? 0; // null이면 0 사용
                            var document = doc;
                            docId = document.id; // 문서 ID는 null이 될 수 없음, 안전하게 접근

                            print(name);
                            print(grade);
                            print(position);
                            print(levelNumber);
                            print(docId);

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return changeNum(
                                  name,
                                  grade,
                                  position,
                                  levelNumber,
                                  docId,
                                  memberList,
                                );
                              },
                            );
                          },
                          child: ChangeStaffNumCard(
                            number: index + 1,
                            name: doc['name'] ?? '',
                            position: doc['position'] ?? '',
                            grade: doc['grade'] ?? '',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget changeNum(
    String name,
    String grade,
    String position,
    int levelNumber,
    String docId,
    List<Map<String, dynamic>> memberList, // memberList
  ) {
    return AlertDialog(
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$name 직원의 위치를',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8), // 텍스트 사이 간격
          Text(
            '누구와 바꾸시겠습니까?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          Divider(
            color: Colors.orange, // 구분선 색상
            thickness: 2, // 구분선 두께
            height: 20, // 구분선과 텍스트 간격
          ),
        ],
      ),

      content: Container(
        width: double.maxFinite, // 내용이 다 표시되도록 최대 너비 설정
        height: 300, // 충분한 높이 설정
        child: ListView.builder(
          itemCount: memberList.length, // memberList의 길이만큼 아이템 수 설정
          itemBuilder: (context, index) {
            var member = memberList[index]; // memberList의 각 아이템

            // null 체크 후 기본값 설정
            String memberName = member['name'] ?? '이름 없음';
            String memberPosition = member['position'] ?? '직책 없음';
            String memberGrade = member['grade'] ?? '직급 없음';
            String memberdocId = member['docId'] ?? '아이디 없음';
            int memberlevelNumber = member['levelNumber'] ?? '넘버 없음';


            return GestureDetector(
              onTap: () async{
                print('$memberName');
                print('$memberPosition');
                print('$memberGrade');
                print('$memberdocId');
                print('$memberlevelNumber');

                Navigator.pop(context);

                try {
                  await FirebaseFirestore.instance
                      .collection('insa')
                      .doc(widget.teamDocId)
                      .collection('list')
                      .doc(docId)
                      .update({
                    'levelNumber': memberlevelNumber,
                  });
                  print('$name 이');
                  print('$memberName 으로감');
                } catch (e) {
                  print(e);
                }

                try {
                  await FirebaseFirestore.instance
                      .collection('insa')
                      .doc(widget.teamDocId)
                      .collection('list')
                      .doc(memberdocId)
                      .update({
                    'levelNumber': levelNumber,
                  });

                  print('$memberName 이');
                  print('$name 으로감');
                } catch (e) {
                  print(e);
                }


              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300), // 테두리 추가
                  borderRadius: BorderRadius.circular(5), // 모서리 둥글게
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 원형 번호 표시
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.orange,
                      child: Text(
                        (index + 1).toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    // 이름과 직책 가로 배치
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            memberName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 20),
                          Text(
                            memberPosition,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 직급 표시
                    Text(
                      memberGrade,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('닫기'),
        ),
      ],
    );
  }
}
