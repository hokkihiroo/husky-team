import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
              .orderBy('order')
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
                        workerName = docs[index]['workerName'];
                        var document = docs[index];
                        dataId = document.id;

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return butto(
                              workerName,
                              dataId,
                            );
                          },
                        );
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
        '직원추가후 시설밖으로 \n 나갔다가 다시 입장하세요',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      actions: [
        TextField(
          autofocus: true,
          maxLength: 4, // 2️⃣ 최대 4글자
          decoration: const InputDecoration(
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
                  if (workerName.trim().isEmpty) {
                    return;
                  }
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
                      'order': DateTime.now().millisecondsSinceEpoch,


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

  Widget butto(
      workerName,
      dataId,
      ) {
    return AlertDialog(
      title: Column(
        children: [
          Text('직원이름: $workerName'),
        ],
      ),
      content: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () async {
                  try {
                    await FirebaseFirestore.instance
                        .collection(TEAM4MEMBER) // 컬렉션 이름을 지정하세요
                        .doc(dataId) // 삭제할 문서의 ID를 지정하세요
                        .delete();
                    print('문서 삭제 완료');
                    Navigator.pop(context);
                  } catch (e) {
                    print('문서 삭제 오류: $e');
                  }
                },
                child: Text('삭제')),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('취소 ')),
          ],
        ),
      ),
    );
  }

}
