import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/5mypage/management/manegement/3manageGongji/gongji_category_list_card.dart';
import 'package:team_husky/5mypage/management/manegement/3manageGongji/gongji_category_select.dart';

class ManageGongjiList extends StatefulWidget {
  String name = '';

  ManageGongjiList({
    super.key,
    required this.name,
  });

  @override
  State<ManageGongjiList> createState() => _ManageGongjiListState();
}

class _ManageGongjiListState extends State<ManageGongjiList> {
  String? documentID = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,

        title: const Text(
          '공지선택',
          style: TextStyle(
            color: Color(0xFF222222),
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),

        iconTheme: const IconThemeData(
          color: Color(0xFF222222),
        ),
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('gongji')
            .orderBy('createdAt')
            .snapshots(),

        builder: (
            BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
            ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
              ),
            );
          }

          final subDocs = snapshot.data?.docs ?? [];

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // 상단 안내 영역
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    8,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Row(
                    children: [

                      Container(
                        width: 44,
                        height: 44,

                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F1F1),
                          borderRadius: BorderRadius.circular(14),
                        ),

                        child: const Icon(
                          Icons.campaign_rounded,
                          color: Color(0xFF333333),
                          size: 24,
                        ),
                      ),

                      const SizedBox(width: 14),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              '공지 카테고리',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF222222),
                                letterSpacing: -0.3,
                              ),
                            ),

                            SizedBox(height: 4),

                            Text(
                              '등록할 공지의 카테고리를 선택해주세요.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF888888),
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // 카테고리 목록
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),

                  child: Column(
                    children: subDocs.map((subDoc) {

                      var data = subDoc.data() ?? {};

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

                        child: Container(
                          margin: const EdgeInsets.only(
                            bottom: 12,
                          ),

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),

                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.045),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),

                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),

                            child: Material(
                              color: Colors.transparent,

                              child: InkWell(
                                onTap: () async {

                                  var document = subDoc;

                                  documentID = document.id;

                                  print(documentID);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ManageSelectCategory(
                                            category: data['category'],
                                            documentID: '$documentID',
                                            name: widget.name,
                                          ),
                                    ),
                                  );
                                },

                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 4,
                                  ),

                                  child: ManageGongjiCategoryCaard(
                                    category: data['category'],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}