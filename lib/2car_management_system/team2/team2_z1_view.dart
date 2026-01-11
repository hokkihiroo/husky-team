import 'package:flutter/material.dart';
import 'package:team_husky/2car_management_system/team2/team2_z1_standby.dart';

class Team2Z1View extends StatefulWidget {
  const Team2Z1View({super.key, required this.name});

  final String name;

  @override
  State<Team2Z1View> createState() => _Team2Z1ViewState();
}

class _Team2Z1ViewState extends State<Team2Z1View> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          '제네시스청주 시승차 현황',
          style: TextStyle(
            color: Color(0xFFC6A667), // 골드 컬러로 고급스러움 강조
          ),
        ),
        iconTheme: IconThemeData(
          color: Color(0xFFC6A667), // 골드 컬러
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
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
                  '스탠바이',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            StandBy(
              // name: widget.name,
              // domesticBrands: domesticBrands,
              // importedFamousBrands: importedFamousBrands,
              // otherBrands: otherBrands,
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              color: Colors.white, // 선 색상
              thickness: 2.0, // 선 두께
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'B1',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

    );
  }
}
