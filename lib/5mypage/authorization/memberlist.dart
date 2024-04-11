import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/5mypage/authorization/authorization_card.dart';

class MemberList extends StatefulWidget {
  final int grade;

  const MemberList({Key? key, required this.grade}) : super(key: key);

  @override
  State<MemberList> createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  String dataId = ''; //차번호 클릭시 그 차번호에 고유 아이디값
  String name = ''; //픽업 하는 사람 이름
  int grade = 9; //픽업 하는 사람 이름

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('user')
          .where('grade', isEqualTo: widget.grade)
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
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: GestureDetector(
                onTap: () {
                  var document = docs[index];
                  dataId = document.id;
                  name = docs[index]['name'];
                  grade = docs[index]['grade'];

                  print(dataId);
                  print(dataId);
                  print(name);
                  print(name);
                  print(grade);
                  print(grade);

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ChangeGrade(
                        name,
                        dataId,
                        grade,
                      );
                    },
                  );
                },
                child: AuthorizationCard(
                  name: docs[index]['name'],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget ChangeGrade(
    String docId,
    String name,
    int grade,
  ) {
    String titleText = grade == 0 ? '관리자로 진급시키시겠습니까?' : '일반직원으로 하락 시키시겠습니까?';
    String buttonText = grade == 0 ? '진급시키기' : '하락시키기';
    return AlertDialog(
      title: Center(
        child: Text(
          titleText,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      content: Container(
        height: 60,
        width: 60,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              onPressed: ()  {
                Navigator.pop(context);
              },
              child: Text('취소'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              onPressed: () async {
                Navigator.pop(context);
                int updatedGrade = grade == 0 ? 1 : 0;

                try {
                  await FirebaseFirestore.instance
                      .collection('user')
                      .doc(dataId)
                      .update({
                    'grade': updatedGrade,
                  });
                } catch (e) {
                  print(e);
                }
              },
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}
