import 'package:flutter/material.dart';
import 'package:team_husky/5mypage/management/manegement/2moveInsa/2moveInsa.dart';
import 'package:team_husky/5mypage/management/manegement/3manageGongji/manageGongji.dart';
import 'package:team_husky/5mypage/management/manegement/4scchedule/4schedule.dart';
import 'package:team_husky/5mypage/management/manegement/5gangnamCarManage/gangnamCar.dart';

import 'manegement/1makeTeam/1makeTeam.dart';
import 'manegement/3manageGongji/gongji_category_list.dart';
import 'manegement/6educationManage/education.dart';

class Management extends StatefulWidget {
  String name ='';
   Management({super.key,required this.name,});

  @override
  State<Management> createState() => _ManagementState();
}

class _ManagementState extends State<Management> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '관리자 페이지',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        centerTitle: true,

      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20),

              minimumSize: Size(double.infinity, 50),
            ),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return MakeTeam();
                }),
              );
            },
            child: Text('팀 개설'),
          ),
          SizedBox(height: 10,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20),

              minimumSize: Size(double.infinity, 50),
            ),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return MoveInsa();
                }),
              );
            },
            child: Text('인사이동 / 직위,포지션 변경'),
          ),
          SizedBox(height: 10,),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20),

              minimumSize: Size(double.infinity, 50),
            ),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return ManageGongjiList(name: widget.name,);
                }),
              );
            },
            child: Text('공지사항관리'),
          ),
          SizedBox(height: 10,),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20),

              minimumSize: Size(double.infinity, 50),
            ),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return ManageSchedule();
                }),
              );
            },
            child: Text('스케줄관리'),
          ),
          SizedBox(height: 10,),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20),

              minimumSize: Size(double.infinity, 50),
            ),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return GangnamCar();
                }),
              );
            },
            child: Text('강남 시승차등록/삭제'),
          ),
          SizedBox(height: 10,),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20),

              minimumSize: Size(double.infinity, 50),
            ),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return EducationManage(name: widget.name,);
                }),
              );
            },
            child: Text('교육자료 등록/삭제 '),
          ),
          
        ],
      ),
    );
  }
}
