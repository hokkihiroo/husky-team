import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/2car_management_system/team2/team2_adress_const.dart';
import 'package:team_husky/2car_management_system/team2/team2_numbercard.dart';
import 'package:team_husky/2car_management_system/team2/team2_z1_standbycard.dart';

class StandBy extends StatefulWidget {
  const StandBy({super.key});

  @override
  State<StandBy> createState() => _StandByState();
}

class _StandByState extends State<StandBy> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(FIELD)
          .where('color', isEqualTo: 5)
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

        // location이 0인 항목만 필터링

        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // 가로 아이템 개수
            crossAxisSpacing: 10.0, // 가로 간격
            mainAxisSpacing: 18.0, // 세로 간격
            childAspectRatio: 1.6, // 아이템의 가로세로 비율
          ),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                // //  활성화 시키면 bar 가 바뀜 데이터 클릭시마다
                // CarListAdress = CARLIST + formatTodayDate();
                // Color5List = COLOR5 + formatTodayDate();
                // var document = filteredDocs[index];
                // dataId = document.id;
                // name = filteredDocs[index]['name'];
                // enterName = filteredDocs[index]['enterName'];
                // carNumber = filteredDocs[index]['carNumber'];
                // carModelFrom = filteredDocs[index]['carModel'];
                // location = filteredDocs[index]['location'];
                // color = filteredDocs[index]['color'];
                // etc = filteredDocs[index]['etc'];
                // wigetName = filteredDocs[index]['wigetName'];
                // movedLocation = filteredDocs[index]['movedLocation'];
                // Timestamp createdAt = filteredDocs[index]['createdAt'];
                // dateTime = createdAt.toDate();
                // remainTime = getRemainTime(dateTime);
                // //     dataAdress = CheckLocation(location); //파이어베이스 데이터주소

                // String getMovingTime = getTodayTime();
                // final BuildContext rootContext = context;

                // showDialog(
                //   context: rootContext,
                //   builder: (BuildContext context) {
                //     if (color == 5) {
                //       return bottomColor5(
                //         carNumber,
                //         name,
                //         color,
                //         location,
                //         dateTime,
                //         dataId,
                //         etc,
                //         remainTime,
                //         movedLocation,
                //         wigetName,
                //         movingTime,
                //         getMovingTime,
                //         carModelFrom,
                //       );
                //     } else {
                //       return bottomTwo(
                //         carNumber,
                //         name,
                //         color,
                //         location,
                //         dateTime,
                //         dataId,
                //         etc,
                //         remainTime,
                //         movedLocation,
                //         wigetName,
                //         movingTime,
                //         getMovingTime,
                //         carModelFrom,
                //         enterName,
                //         rootContext,
                //         context,
                //       );
                //     }
                //   },
                // );
              },
              child: StandByCard(
                carNumber: docs[index]['carNumber'],
                name: docs[index]['name'],
                color: docs[index]['color'],
                etc: docs[index]['etc'],
                carBrand: docs[index]['carBrand'],
                carModel: docs[index]['carModel'],
                location: docs[index]['location'],
              ),
            );
          },
        );
      },
    );
  }
}
