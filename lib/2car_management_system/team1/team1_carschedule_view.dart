import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/2car_management_system/team1/team1_adress_const.dart';
import 'package:team_husky/2car_management_system/team1/team1_carschedule_view_card.dart';

class CarScheduleView extends StatefulWidget {
  const CarScheduleView({super.key});

  @override
  State<CarScheduleView> createState() => _CarScheduleViewState();
}

class _CarScheduleViewState extends State<CarScheduleView> {
  late String adress='';

  @override
  void initState() {
    super.initState();
    adress = formatTodayDate();

  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(CARSCHEDULE+adress)
          .orderBy('time')
          .snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }




        final docs = snapshot.data!.docs;



        return Column(
          children: docs.asMap().entries.map((entry) {
            int index = entry.key + 1; // 1부터 시작하는 인덱스
            var doc = entry.value;
            return CarScheduleViewCard(
              car: doc['car'],
              docId: doc.id,
              time: doc['time'],
              index: index,
              seat: doc['seat'],
            );
          }).toList(),
        );
      },
    );
  }
}
