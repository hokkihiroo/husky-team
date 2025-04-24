import 'package:flutter/material.dart';
import 'package:team_husky/2car_management_system/team2/team2_oil_list.dart';


class OilView extends StatefulWidget {
  const OilView({super.key, required this.name});

  final String name;

  @override
  State<OilView> createState() => _Team3ViewState();
}

class _Team3ViewState extends State<OilView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title:  Text(
          '제네시스 청주',
          style: TextStyle(
            color: Color(0xFFC6A667), // 골드 컬러로 고급스러움 강조
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Center(
              child: Text(
                '${DateTime.now().year}년 ${DateTime.now().month}월 ${DateTime.now().day}일',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Divider(
              color: Colors.white, // 선 색상
              thickness: 2.0, // 선 두께
            ),

            Text(
              '시승차 주유관리',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

             SizedBox(height: 10,),
            TeamOilList(
            ),
          ],
        ),
      ),
    );
  }
}

