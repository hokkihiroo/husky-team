import 'package:flutter/material.dart';
import 'package:team_husky/1insa/Insa.dart';
import 'package:team_husky/3notice/gongji.dart';
import 'package:team_husky/layout/default_layout.dart';
import '../2car_management_system/car_mainview.dart';
import '../4education/education.dart';
import '../5mypage/mypage.dart';
import 'adress.dart';

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
  String title = '시설';
  late TabController controller;
  int index = 1;

  bool isRestrictedUser() {
    return restrictedEmails().contains(widget.email);
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = TabController(length: 5, vsync: this,initialIndex: 1,);
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
    });
  }

  void showRestrictedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('안내'),
          content: const Text('해당 메뉴에 접근할 수 없습니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: index == 0 || index == 1 || index == 4 ? null : title,
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (int index) {
          // 제한 사용자 + 시설(1) 제외 탭 클릭 시
          if (isRestrictedUser() && index != 1) {
            showRestrictedDialog();
            return;
          }

          controller.animateTo(index);
        },
        height: 70,
        backgroundColor: Colors.white,
        elevation: 3,
        indicatorColor: const Color(0xFFE8EEF7),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.perm_identity_outlined),
            selectedIcon: Icon(Icons.perm_identity),
            label: '조직',
          ),
          NavigationDestination(
            icon: Icon(Icons.drive_eta_outlined),
            selectedIcon: Icon(Icons.drive_eta),
            label: '시설',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications),
            label: '공지',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_stories_outlined),
            selectedIcon: Icon(Icons.auto_stories),
            label: '교육',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_outlined),
            selectedIcon: Icon(Icons.menu),
            label: '내정보',
          ),
        ],
      ),
    );
  }
}
