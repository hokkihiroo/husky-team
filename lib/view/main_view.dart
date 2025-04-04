import 'package:flutter/material.dart';
import 'package:team_husky/1insa/Insa.dart';
import 'package:team_husky/3notice/gongji.dart';
import 'package:team_husky/layout/default_layout.dart';
import '../2car_management_system/car_mainview.dart';
import '../4education/education.dart';
import '../5mypage/mypage.dart';

class MainView extends StatefulWidget {
  const MainView({
    super.key,
    required this.myUid,
    required this.name,
    required this.team,
    required this.email,
    required this.grade,
    required this.birthDay,
    required this.picUrl,
  });

  final String myUid;
  final String name;
  final String team;
  final String email;
  final int grade;
  final String birthDay;
  final String picUrl;

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView>
    with SingleTickerProviderStateMixin {
  String title = '조직도';
  late TabController controller;
  int index = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = TabController(length: 5, vsync: this);
    controller.addListener(tabListner);
  }

  @override
  void dispose() {
    controller.removeListener(tabListner);
    super.dispose();
  }

  void tabListner() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: title,
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          Organization(
            grade: widget.grade,
          ),
          CarManagementSystem(
            name: widget.name, team: widget.team,
          ),
          Notication(),
          Education(),
          MyPage(
            name: widget.name,
            email: widget.email,
            grade: widget.grade,
            team: widget.team,
            uid: widget.myUid,
            birthDay: widget.birthDay,
            picUrl:widget.picUrl,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          controller.animateTo(index);
          if (index == 0) {
            title = '조직도';
          } else if (index == 1) {
            title = '시설';
          } else if (index == 2) {
            title = '공지사항';
          } else if (index == 3) {
            title = '교육';
          } else if (index == 4) {
            title = 'MyPage';
          }
        },
        currentIndex: index,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.perm_identity_outlined,
            ),
            label: '조직',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.drive_eta_outlined,
            ),
            label: '시설',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications_outlined,
            ),
            label: '공지',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.auto_stories_outlined,
            ),
            label: '교육',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu_outlined,
            ),
            label: '내정보',
          ),
        ],
      ),
    );
  }
}
