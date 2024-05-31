import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:team_husky/1insa/Address.dart';
import 'package:team_husky/1insa/InsaCard.dart';
import 'package:team_husky/1insa/teamcard.dart';

class Organization extends StatefulWidget {
  const Organization({super.key});

  @override
  State<Organization> createState() => _OrganizationState();
}

class _OrganizationState extends State<Organization> {
  String dataId = ''; //팀 클릭시 그 팀고유 아이디값
  String name = ''; // 팀 이름
  String mansID = ''; // 팀원문서아이디
  String formattedDate = '';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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
          return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Column(
                      children: [
                        BuildingCard(
                          image: Image.asset(docs[index]['image']),
                          name: docs[index]['name'],
                          position: docs[index]['position'],
                        ),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection(INSA)
                              .doc(docs[index].id)
                              .collection('list')
                              .orderBy('enterDay')
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            final subDocs = snapshot.data!.docs;

                            // 바뀐 부분: ListView 대신 Column을 사용하여 하위 컬렉션의 데이터를 표시
                            return Column(
                              children: subDocs.map((subDoc) {
                                var data = subDoc.data() ?? {}; // 데이터가 널인 경우 빈 맵 사용
                                return GestureDetector(
                                  onTap: () async {
                                    var document = subDoc;
                                    mansID = document.id;
                                    Map<String, dynamic> userData = await getData(mansID);
                                    Timestamp timestamp = userData['enterDay'];
                                    DateTime dateTime = timestamp.toDate();
                                    formattedDate = DateFormat('yy/MM/dd').format(dateTime);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return viewInsa(
                                          userData,
                                          formattedDate,
                                        );
                                      },
                                    );
                                  },
                                  child: OrganizationCard(
                                    image: data['image'] != null
                                        ? Image.asset(data['image'])
                                        : Icon(Icons.image_outlined),
                                    name: data['name'] ?? '', // 이름이 널인 경우 빈 문자열 사용
                                    grade: data['grade'] ?? '', // 포지션이 널인 경우 빈 문자열 사용
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
              });
        });
  }


  Widget viewInsa(
    Map<String, dynamic> data,
    String formattedDate,
  ) {
    return AlertDialog(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('asset/img/husky_Logo.png'),
            // 이미지 경로 설정
            radius: 80, // 원의 반지름 설정
          ),
          SizedBox(
            height: 20,
          ),
          Center(child: Text(data['name'])),
          Center(child: Text(data['birthDay'])),
        ],
      ),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text('연락처 :'),
                SizedBox(
                  width: 10,
                ),
                Text(data['phoneNumber']),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            Row(
              children: [
                Text('차량번호 :'),
                SizedBox(
                  width: 10,
                ),
                Text(data['carNumber']),
              ],
            ),
            Row(
              children: [
                Text('경력 :'),
                SizedBox(
                  width: 10,
                ),
                Text(data['career']),
                SizedBox(
                  width: 10,
                ),
                Text('취미 :'),
                SizedBox(
                  width: 10,
                ),
                Text(data['hobby']),
              ],
            ),
            Row(
              children: [
                Text('입사일 :'),
                SizedBox(
                  width: 10,
                ),
                Text('$formattedDate'), //    이건 날짜를 불러올수있는
                //위젯으로 변경후 불러와야함
              ],
            ),
            Row(
              children: [
                Text('상의 :'),
                SizedBox(
                  width: 10,
                ),
                Text(data['tShirtSize']),
                SizedBox(
                  width: 10,
                ),
                Text('하의 :'),
                SizedBox(
                  width: 10,
                ),
                Text(data['pantsSize']),
              ],
            ),
            Row(
              children: [
                Text('신발 :'),
                SizedBox(
                  width: 10,
                ),
                Text(data['footSize']),
                SizedBox(
                  width: 10,
                ),
                Text('키 :'),
                SizedBox(
                  width: 10,
                ),
                Text(data['cm']),
              ],
            ),
            Row(
              children: [
                Text('몸무게 :'),
                SizedBox(
                  width: 10,
                ),
                Text(data['kg']),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//선택한 직원 신상 불러오기
Future<Map<String, dynamic>> getData(String documentId) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance
            .collection('user')
            .doc(documentId)
            .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> data = documentSnapshot.data()!;
      if (data != null) {
        return data;
      } else {
        print('문서 데이터가 null입니다.');
        // 데이터가 null인 경우에 대한 처리를 추가합니다.
      }
    } else {
      print('문서가 존재하지 않습니다.');
      // 문서가 존재하지 않는 경우에 대한 처리를 추가합니다.
    }
  } catch (e) {
    print('데이터를 가져오는 중에 오류가 발생했습니다: $e');
    // 오류가 발생한 경우에 대한 처리를 추가합니다.
  }

  // 모든 분기에서 return 문을 추가하여 반환 유형이 Future<Map<String, dynamic>>을 만족시킵니다.
  return {};
}
