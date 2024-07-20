import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:team_husky/2car_management_system/team1/team1_adress_const.dart';
import 'package:team_husky/2car_management_system/team1/team1_outcar_card.dart';

class OutCar extends StatefulWidget {
  final String name;

  const OutCar({super.key, required this.name});

  @override
  State<OutCar> createState() => _OutCarState();
}

class _OutCarState extends State<OutCar> {
  int location = 0; //차번호 클릭시 그차번호 위치
  String dataAdress = ''; // 차번호 클릭시 나오는 위치 주소값
  String movedLocation = ''; //과거 이동위치


  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> stream1 =
        FirebaseFirestore.instance.collection(LOTARY).snapshots();
    Stream<QuerySnapshot> stream2 =
        FirebaseFirestore.instance.collection(OUTSIDE).snapshots();
    Stream<QuerySnapshot> stream3 =
        FirebaseFirestore.instance.collection(MAIN).snapshots();
    Stream<QuerySnapshot> stream4 =
        FirebaseFirestore.instance.collection(MOON).snapshots();
    Stream<QuerySnapshot> stream5 =
        FirebaseFirestore.instance.collection(SINSA).snapshots();

    // Combine the streams
    Stream<List<QuerySnapshot>> combinedStream = CombineLatestStream.list([
      stream1,
      stream2,
      stream3,
      stream4,
      stream5,
    ]);
    return StreamBuilder<List<QuerySnapshot>>(
      stream: combinedStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<QuerySnapshot>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        // snapshot.data는 각 스트림의 QuerySnapshot을 포함하는 리스트입니다.
        List<QuerySnapshot> querySnapshots = snapshot.data!;

        // 각 컬렉션의 문서를 모두 포함하는 리스트를 만듭니다.
        List<DocumentSnapshot> allDocuments = [];
        for (QuerySnapshot querySnapshot in querySnapshots) {
          allDocuments.addAll(querySnapshot.docs);
        }

        // 예제에서는 모든 문서를 하나의 리스트로 표시합니다.
        return Column(
          children: allDocuments.map((doc) {
            int color = doc['color'];
            location = doc['location'];
            dataAdress = CheckLocation(location); //파이어베이스 데이터주소

            if (color == 2) {
              return OutCarCard(
                carNumber: doc['carNumber'],
                name: doc['name'],
                location: location,
                dataId: doc.id,
                myName: widget.name,
                dataAdress: dataAdress,
                movedLocation: doc['movedLocation'],
                wigetName: doc['wigetName'],
                movingTime: doc['movingTime'],
              );
            } else {
              return Container(); // color가 2가 아닐 경우 빈 컨테이너 반환
            }
          }).toList(),
        );
      },
    );
  }
}
