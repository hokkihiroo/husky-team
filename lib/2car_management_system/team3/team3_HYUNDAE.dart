// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:team_husky/2car_management_system/team3/team3_HYUNDAE_card.dart';
// import 'package:team_husky/2car_management_system/team3/team3_adress_const.dart';
//
// class Team3Hyundae extends StatefulWidget {
//   const Team3Hyundae({super.key});
//
//   @override
//   State<Team3Hyundae> createState() => _Team3HyundaeState();
// }
//
// class _Team3HyundaeState extends State<Team3Hyundae> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: FirebaseFirestore.instance
//           .collection(Team3FIELD)
//           .orderBy('createdAt')
//           .snapshots(),
//       builder: (BuildContext context,
//           AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//
//         // fetchCarNames(); // 시승차 목록을 시승차 스케줄 추가시 목록에 자동으로 추가하는 함수
//
//         final docs = snapshot.data!.docs;
//
//         return ListView.builder(
//           itemCount: docs.length, // 안전하게 리스트 길이만큼 반복
//           itemBuilder: (BuildContext context, int index) {
//             return Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10.0),
//               child: GestureDetector(
//                 onTap: () async {
//                   //  활성화 시키면 bar 가 바뀜 데이터 클릭시마다
//                   // CarListAdress = CARLIST + formatTodayDate();
//                   // var document = filteredDocs[index];
//                   // dataId = document.id;
//                   // name = filteredDocs[index]['name'];
//                   // carNumber = filteredDocs[index]['carNumber'];
//                   // location = filteredDocs[index]['location'];
//                   // color = filteredDocs[index]['color'];
//                   // etc = filteredDocs[index]['etc'];
//                   // wigetName = filteredDocs[index]['wigetName'];
//                   // movedLocation = filteredDocs[index]['movedLocation'];
//                   // movingTime = filteredDocs[index]['movingTime'];
//                   // Timestamp createdAt = filteredDocs[index]['createdAt'];
//                   // dateTime = createdAt.toDate();
//                   // remainTime = getRemainTime(dateTime);
//                   // //     dataAdress = CheckLocation(location); //파이어베이스 데이터주소
//                   //
//                   // String getMovingTime = getTodayTime();
//                   // print(location);
//                   // print(location);
//                   // print(location);
//                   // print(location);
//                   // showDialog(
//                   //   context: context,
//                   //   builder: (BuildContext context) {
//                   //     return bottomTwo(
//                   //       carNumber,
//                   //       name,
//                   //       color,
//                   //       location,
//                   //       dateTime,
//                   //       //  dataAdress,
//                   //       dataId,
//                   //       etc,
//                   //       remainTime,
//                   //       movedLocation,
//                   //       wigetName,
//                   //       movingTime,
//                   //       getMovingTime,
//                   //     );
//                   //   },
//                   // );
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.only(bottom: 10),
//                   child: Team3HyundaeCard(
//                     oilCount: docs[index]['oilCount'],
//                     name: docs[index]['name'],
//                   ),
//                 ),
//               ),
//             );
//
//           },
//
//         );
//       },
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/2car_management_system/team3/team3_HYUNDAE_card.dart';
import 'package:team_husky/2car_management_system/team3/team3_adress_const.dart';

class Team3Hyundae extends StatefulWidget {
  final String brandName;
  final int brandNum;

  const Team3Hyundae(
      {super.key, required this.brandName, required this.brandNum});

  @override
  State<Team3Hyundae> createState() => _Team3HyundaeState();
}

class _Team3HyundaeState extends State<Team3Hyundae> {
  String carName = ''; // 차이름
  String oilCount = ''; //차번호 클릭시 그 차번호에 고유 아이디값
  String dataId = ''; //차번호 클릭시 그 차번호에 고유 아이디값

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(Team3FIELD)
          .orderBy('createdAt')
          .snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        // 데이터가 없을 때 처리
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              "데이터가 없습니다!",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          );
        }

        final docs = snapshot.data!.docs
            .where((doc) => doc['carNumber'] == '${widget.brandName}')
            .toList()
          ..sort((a, b) => a['createdAt'].compareTo(b['createdAt']));

        return ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(), // 부드러운 스크롤

          itemCount: docs.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 5.0,
                vertical: index == docs.length - 1
                    ? 5.0
                    : 10.0, // 마지막 데이터일 때만 여유 공간 추가
              ),
              child: GestureDetector(
                onTap: () async {

                  carName = docs[index]['carName'];
                  oilCount = docs[index]['oilCount'];
                  var document = docs[index];
                  dataId = document.id;

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return bottomTwo(
                        carName,
                        oilCount,
                        dataId,

                      );
                    },
                  );
                },
                child: Team3HyundaeCard(
                  name: docs[index]['carName'],
                  oilCount: docs[index]['oilCount'],
                  brandNum: widget.brandNum,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget bottomTwo(
      carName,
      oilCount,
      dataId,
      ) {
    TextEditingController _textController = TextEditingController();

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(
        carName,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(context); // 취소


                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('$carName'),
                      content: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: "새로운 값 입력",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // 취소
                          },
                          child: Text('취소'),
                        ),
                        TextButton(
                          onPressed: () async{
                            String newValue = _textController.text;
                            print('새로운 값: $newValue'); // 여기서 값 처리
                            Navigator.pop(context);

                            try {
                              await FirebaseFirestore.instance
                                  .collection(Team3FIELD)
                                  .doc(dataId)
                                  .update({
                                'oilCount': newValue,
                              });
                            } catch (e) {
                              print(e);
                            }

                          },
                          child: Text('확인'),
                        ),
                      ],
                    );
                  },
                );


              },
              child: Text(
                '수정하기',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                '취소',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
