import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/2car_management_system/team3/team3_HYUNDAE.dart';

class Team3View extends StatefulWidget {
  const Team3View({super.key, required this.name});

  final String name;

  @override
  State<Team3View> createState() => _Team3ViewState();
}

class _Team3ViewState extends State<Team3View> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'HMS   고양',
          style: TextStyle(
            color: Colors.yellow, // 골드 컬러로 고급스러움 강조
          ),
        ),
        centerTitle: true, // 타이틀 중앙 정렬
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Divider(
              color: Colors.white, // 선 색상
              thickness: 2.0, // 선 두께
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '현대',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Team3Hyundae(brandName: '현대', brandNum: 1,),
            Divider(
              color: Colors.white, // 선 색상
              thickness: 2.0, // 선 두께
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '제네시스',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Team3Hyundae(brandName: '제네시스', brandNum: 2,),

            Divider(
              color: Colors.white, // 선 색상
              thickness: 2.0, // 선 두께
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '헤리티지',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Team3Hyundae(brandName: '헤리티지', brandNum: 3,),

          ],
        ),
      ),
    );
  }
}

// class _Lists extends StatelessWidget {
//
//   const _Lists({super.key,});
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//
//       child:   Column(
//         children: [
//           Team3Hyundae(
//           ),
//         ],
//       ),
//     );
//   }
// }
