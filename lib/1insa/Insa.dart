import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
                          position: docs[index]['position'],
                          name: docs[index]['name'],
                        ),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection(INSA)
                              .doc(docs[index].id)
                              .collection('list')
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
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
                                return OrganizationCard(
                                  name: data['name'] ?? '', // 이름이 널인 경우 빈 문자열 사용
                                  team: data['team'] ?? '', // 팀이 널인 경우 빈 문자열 사용
                                  position: data['position'] ?? '', // 포지션이 널인 경우 빈 문자열 사용
                                );
                              },
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
}
