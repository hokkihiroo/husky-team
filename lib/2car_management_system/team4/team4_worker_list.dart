import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/2car_management_system/team4/team4_adress.dart';
import 'package:team_husky/2car_management_system/team4/team4_worker_memberCard.dart';

class WorkerList extends StatefulWidget {
  const WorkerList({super.key});

  @override
  State<WorkerList> createState() => _WorkerListState();
}

class _WorkerListState extends State<WorkerList> {
  String workerName = '';
  String dataId = '';



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.amber, // ← 뒤로가기 버튼 색상
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              '근무자명단',
              style: TextStyle(
                color: Colors.amber,
              ),
            ),
            GestureDetector(
              onTap: () {
                workerName = '비어있음';
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return addWorker();
                  },
                );
              },
              child: Text(
                '추가하기',
                style: TextStyle(
                  color: Colors.amber,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(TEAM4MEMBER)
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
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        // carName = docs[index]['carName'];
                        // carNumber = docs[index]['carNumber'];
                        // var document = docs[index];
                        // dataId = document.id;
                        //
                        // showDialog(
                        //   context: context,
                        //   builder: (BuildContext context) {
                        //     return butto(
                        //       carName,
                        //       carNumber,
                        //       dataId,
                        //     );
                        //   },
                        // );
                      },
                      child: WorkerMemberCard(
                        workerName: docs[index]['workerName'],
                          ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget addWorker() {
    return AlertDialog(
      title: Text(
        '직원추가',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      actions: [
        TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: '직원이름',
          ),
          onChanged: (value) {
            workerName = value;
          },
        ),
        SizedBox(
          height: 30,
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                  EdgeInsets.symmetric(vertical: 20.0), // 버튼의 위아래 패딩 조정
                ),
                onPressed: () async {
                  String documentId = FirebaseFirestore.instance
                      .collection(TEAM4MEMBER)
                      .doc()
                      .id;
                  try {
                    await FirebaseFirestore.instance
                        .collection(TEAM4MEMBER)
                        .doc(documentId)
                        .set({
                      'workerName': workerName,
                      'createdAt': FieldValue.serverTimestamp(),
                    });
                  } catch (e) {}

                  Navigator.pop(context);
                },
                child: Text('입력'),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                  EdgeInsets.symmetric(vertical: 20.0), // 버튼의 위아래 패딩 조정
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('취소'),
              ),
            ),
          ],
        ),
      ],
    );
  }

}
