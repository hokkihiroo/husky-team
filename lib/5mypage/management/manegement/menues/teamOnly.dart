import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'teamMenues/teamMenu.dart';

class TeamOnly extends StatelessWidget {
  const TeamOnly({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder(
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

              final docs = snapshot.data!.docs
                  .where((doc) => doc['name'] != '퇴사자') // '퇴사자'를 제외
                  .toList();


              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 한 줄에 표시할 개수 설정
                  crossAxisSpacing: 20, // 가로 간격 설정 (값 증가)
                  mainAxisSpacing: 20, // 세로 간격 설정 (값 증가)
                ),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: docs.length,
                itemBuilder: (context, index) {

                  final doc = docs[index];
                  final docId = doc.id;

                  return _buildSquareButton(
                    context: context,
                    label: docs[index]['name'],
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TeamMenu(
                            teamName: docs[index]['name'],
                            position: docs[index]['position'],
                            teamDocId: docId,
                          ),
                        ),
                      );
                    },
                    position: docs[index]['position'],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSquareButton({
    required BuildContext context,
    required String label,
    required String position,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(80, 80),
        // 정사각형 크기를 줄임
        backgroundColor: Colors.orange,
        shadowColor: Colors.orange.withOpacity(0.5),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // 모서리를 약간 둥글게
        ),
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            position,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12, // 텍스트 크기 조정
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15, // 텍스트 크기 조정
            ),
          ),
        ],
      ),
    );
  }
}
