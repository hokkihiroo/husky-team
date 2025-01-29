import 'package:flutter/material.dart';
import 'package:team_husky/5mypage/management/manegement/2moveInsa/2moveInsa.dart';
import 'package:team_husky/5mypage/management/manegement/3manageGongji/manageGongji.dart';
import 'package:team_husky/5mypage/management/manegement/4scchedule/4schedule.dart';
import 'package:team_husky/5mypage/management/manegement/5educationManage/education.dart';
import 'package:team_husky/5mypage/management/manegement/6license/licenseManage.dart';
import 'package:team_husky/5mypage/management/manegement/menues/teamOnly.dart';

import 'manegement/1makeTeam/1makeTeam.dart';
import 'manegement/3manageGongji/gongji_category_list.dart';
import 'manegement/7salaryManage/salaryManage.dart';

class Management extends StatefulWidget {
  final String name;

  Management({super.key, required this.name});

  @override
  State<Management> createState() => _ManagementState();
}

class _ManagementState extends State<Management> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '관리자 설정',
          style: TextStyle(
            color: Colors.white, // 텍스트를 흰색으로 변경
            fontWeight: FontWeight.bold, // 굵은 글씨
            fontSize: 20, // 텍스트 크기 증가
            letterSpacing: 1.2, // 글자 간격 추가
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        // 아이콘 색상 변경
        centerTitle: true,
        // 제목 중앙 정렬
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.black], // 그라데이션 색상
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3), // 그림자 색상
                offset: Offset(0, 4), // 그림자 위치
                blurRadius: 10, // 그림자 흐림 정도
              ),
            ],
          ),
        ),
        elevation: 0, // AppBar 그림자 제거
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildStyledButton(
                context: context,
                label: '팀 개설',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MakeTeam()),
                  );
                },
              ),
              SizedBox(height: 15),
              _buildStyledButton(
                context: context,
                label: '인사이동 / 직위, 포지션 변경',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MoveInsa()),
                  );
                },
              ),
              SizedBox(height: 15),
              _buildStyledButton(
                context: context,
                label: '공지사항 관리',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ManageGongjiList(name: widget.name)),
                  );
                },
              ),
              SizedBox(height: 15),
              _buildStyledButton(
                context: context,
                label: '스케줄 관리',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ManageSchedule()),
                  );
                },
              ),
              SizedBox(height: 15),
              _buildStyledButton(
                context: context,
                label: '교육자료 등록/삭제',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EducationManage(name: widget.name)),
                  );
                },
              ),
              SizedBox(height: 15),
              _buildStyledButton(
                context: context,
                label: '운전면허관리',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LicenseManage(
                        name: widget.name,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 15),
              _buildStyledButton(
                context: context,
                label: '급여관리',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SalaryManage(
                        name: widget.name,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 15),

              TeamOnly(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStyledButton({
    required BuildContext context,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 20),
        minimumSize: Size(double.infinity, 50),
        backgroundColor: Colors.blueAccent,
        shadowColor: Colors.blue.withOpacity(0.5),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
