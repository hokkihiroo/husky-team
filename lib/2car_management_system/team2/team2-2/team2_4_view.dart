import 'package:flutter/material.dart';
import 'package:team_husky/2car_management_system/team2/team2-2/team2_2_B1_B2_outside.dart';
import 'package:team_husky/2car_management_system/team2/team2-2/team2_1_standby.dart';
import 'package:team_husky/2car_management_system/team2/team2-2/team2_5_carList.dart';

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
            StandBy(name: widget.name,

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
            SizedBox(
              height: 10,
            ),
            B1B2Outside(name:widget.name, location: 11,    //b1 데이터 11
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
                  'B2',
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
            B1B2Outside(name:widget.name, location: 12,    //b2 데이터 12
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
                  '외부주차장',
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
            B1B2Outside(name:widget.name, location: 13,    //외부 데이터 13
            ),
          ],
        ),
      ),

        bottomNavigationBar: bottomOne());
  }
  Widget bottomOne() {
    return BottomAppBar(
      child: Row(
        children: [
          SizedBox(
            width: 5,
          ),

          Expanded(
            child: SizedBox(
              height: 80,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle:
                  TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CarListz1(),
                    ),
                  );
                },
                child: Icon(
                  Icons.description_outlined,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
        ],
      ),
      color: Colors.black,
    );
  }
}
