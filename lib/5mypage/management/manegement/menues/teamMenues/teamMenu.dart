import 'package:flutter/material.dart';
import 'package:team_husky/5mypage/management/manegement/menues/teamMenues/TestDrivingCar.dart';
import 'package:team_husky/5mypage/management/manegement/menues/teamMenues/changeStaffNum.dart';
import 'package:team_husky/5mypage/management/manegement/menues/teamMenues/forGenesis.dart';

import 'brandManage.dart';

class TeamMenu extends StatelessWidget {
  final String teamName;
  final String position;
  final String teamDocId;
  final int grade=1;

  const TeamMenu({
    super.key,
    required this.teamName,
    required this.position,
    required this.teamDocId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$position $teamName 전용'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50), // 너비를 화면 전체로 설정
              backgroundColor: Colors.black, // 버튼 배경색
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // 둥근 모서리
              ),
              padding: EdgeInsets.symmetric(horizontal: 20), // 버튼 안쪽 여백
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TestDrivingCar(
                    teamName: teamName,
                    position: position,
                    teamDocId: teamDocId,
                  ),
                ),
              );
            },
            child: Text(
              '시승차 관리',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),

          SizedBox(height: 20), // 버튼 간 간격
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50), // 너비를 화면 전체로 설정
              backgroundColor: Colors.black, // 버튼 배경색
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // 둥근 모서리
              ),
              padding: EdgeInsets.symmetric(horizontal: 20), // 버튼 안쪽 여백
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeStaffNum(
                    teamName: teamName,
                    position: position,
                    teamDocId: teamDocId,
                  ),
                ),
              );
            },
            child: Text(
              '직원순서 변경',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          SizedBox(height: 20), // 버튼 간 간격

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50), // 너비를 화면 전체로 설정
              backgroundColor: Colors.black, // 버튼 배경색
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // 둥근 모서리
              ),
              padding: EdgeInsets.symmetric(horizontal: 20), // 버튼 안쪽 여백
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BrandManage(
                    teamDocId: teamDocId, grade: grade,
                  ),
                ),
              );
            },
            child: Text(
              '브랜드관리(삭제가능)(공통)',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          SizedBox(height: 20), // 버튼 간 간격

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50), // 너비를 화면 전체로 설정
              backgroundColor: Colors.black, // 버튼 배경색
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // 둥근 모서리
              ),
              padding: EdgeInsets.symmetric(horizontal: 20), // 버튼 안쪽 여백
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ForGenesis(
                    teamDocId: teamDocId,
                  ),
                ),
              );
            },
            child: Text(
              '시승차관리(제네시스)',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
