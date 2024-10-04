import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/5mypage/management/manegement/3manageGongji/gongji_category_list_card.dart';
import 'package:team_husky/5mypage/management/manegement/3manageGongji/gongji_category_select.dart';

class ManageGongjiList extends StatefulWidget {
  String name ='';
  ManageGongjiList({super.key,required this.name});

  @override
  State<ManageGongjiList> createState() => _ManageGongjiListState();
}

class _ManageGongjiListState extends State<ManageGongjiList> {
  String? documentID = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '공지선택',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('gongji')
                  .orderBy('createdAt')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
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
                        documentID = document.id;
                        print(documentID);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManageSelectCategory(
                              category: data['category'],
                              documentID: '$documentID',
                              name: widget.name,

                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        child: ManageGongjiCategoryCaard(
                          category: data['category'],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),

            // ScheduleList(),
          ],
        ),
      ),
    );
  }
}
