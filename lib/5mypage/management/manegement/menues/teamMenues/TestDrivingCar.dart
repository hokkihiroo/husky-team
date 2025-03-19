import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:team_husky/5mypage/management/manegement/0adress_const.dart';
import 'package:team_husky/5mypage/management/manegement/menues/teamMenues/TestDrivingCar_Card.dart';

class TestDrivingCar extends StatefulWidget {
  final String teamName;
  final String position;
  final String teamDocId;

  const TestDrivingCar({
    super.key,
    required this.teamName,
    required this.position,
    required this.teamDocId,
  });
  @override
  State<TestDrivingCar> createState() => _GangnamCarState();
}

class _GangnamCarState extends State<TestDrivingCar> {
  late String gangnamCarList; // 전역 변수로 선언
  String carName = '';
  String carNumber = '';
  String dataId = '';


  @override
  void initState() {
    super.initState();
    print('initState 호출됨');

    gangnamCarList = getGangnamCarList(widget.teamDocId);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar 추가
        title: Text(
          '${widget.position} ${widget.teamName} 시승차',
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
                  .collection(gangnamCarList)
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
                            carName = docs[index]['carName'];
                            carNumber = docs[index]['carNumber'];
                            var document = docs[index];
                            dataId = document.id;

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return butto(
                                  carName,
                                  carNumber,
                                  dataId,
                                );
                              },
                            );
                          },
                          child: TestDrivingCarCard(
                            carName: docs[index]['carName'],
                            carNumber: docs[index]['carNumber'],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    carName = '비어있음';
                    carNumber = '비어있음';
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return addCar();
                      },
                    );
                  },
                  child: Text('차량추가'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget addCar() {
    return AlertDialog(
      title: Text(
        '시승차 추가',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      actions: [
        TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: '차종',
          ),
          onChanged: (value) {
            carName = value;
          },
        ),
        SizedBox(
          height: 30,
        ),
        TextField(
          decoration: InputDecoration(
            hintText: '차 번호',
          ),
          onChanged: (value) {
            carNumber = value;
          },
        ),
        SizedBox(
          height: 20,
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
                      .collection(gangnamCarList)
                      .doc()
                      .id;
                  try {
                    await FirebaseFirestore.instance
                        .collection(gangnamCarList)
                        .doc(documentId)
                        .set({
                      'carName': carName,
                      'carNumber': carNumber,
                      'createdAt': FieldValue.serverTimestamp(),
                      'oilCount' :'0',
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
    carName,
    carNumber,
    dataId,
  ) {
    return AlertDialog(
      title: Column(
        children: [
          Text('차량이름: $carName'),
          Text('차량번호: $carNumber'),
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
                        .collection(gangnamCarList) // 컬렉션 이름을 지정하세요
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
