import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/2car_management_system/team4/team4_adress.dart';
import 'package:team_husky/2car_management_system/team4/team4_outcar_card.dart';

class Team4OutCar extends StatefulWidget {
  final String name;

  const Team4OutCar({super.key, required this.name});

  @override
  State<Team4OutCar> createState() => _Team4OutCarState();
}

class _Team4OutCarState extends State<Team4OutCar> {
  int location = 0; //차번호 클릭시 그차번호 위치
  String dataAdress = ''; // 차번호 클릭시 나오는 위치 주소값
  String movedLocation = ''; //과거 이동위치


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(TEAM4FIELD)
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
        final filteredDocs = docs
            .where((doc) => doc['color'] == 2 || doc['color'] == 4)
            .toList();

        return ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredDocs.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Team4OutcarCard(
                  carNumber: filteredDocs[index]['carNumber'],
                  name: filteredDocs[index]['name'],
                  dataId: filteredDocs[index].id,
                  location:  filteredDocs[index]['location'],
                  myName: widget.name,
                  dataAdress: TEAM4CARLIST,
                  movedLocation: filteredDocs[index]['movedLocation'],
                  wigetName: filteredDocs[index]['wigetName'],
                  movingTime: filteredDocs[index]['movingTime'],
                  color:  filteredDocs[index]['color'],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
