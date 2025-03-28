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
            color: Colors.yellow, // 골드 컬러
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
            _Lists(),
            Divider(
              color: Colors.white, // 선 색상
              thickness: 2.0, // 선 두께
            ),
            Text(
              '현대',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Team3Hyundae(
              brandName: '현대',
              brandNum: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class _Lists extends StatelessWidget {
  const _Lists({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            child: Column(
              children: [
                Text(
                  '헤리티지',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Team3Hyundae(
                  brandName: '헤리티지',
                  brandNum: 3,
                ),
              ],
            ),
          ),
        ),
        Container(
          width: 2, // 선의 두께
          height: 270, // 화면 높이에 맞게 설정
          color: Colors.white.withOpacity(0.6), // 연한 흰색 (디자인적으로 부드럽게)
          margin: EdgeInsets.symmetric(vertical: 10), // 위아래 여백 추가
        ),
        Expanded(
          child: Container(
            child: Column(
              children: [
                Text(
                  '제네시스',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Team3Hyundae(
                  brandName: '제네시스',
                  brandNum: 2,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
