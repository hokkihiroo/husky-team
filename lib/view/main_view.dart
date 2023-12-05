import 'package:flutter/material.dart';
import 'package:team_husky/car_management_system/car_mainview.dart';
import 'package:team_husky/layout/default_layout.dart';
import 'package:team_husky/mypage/mypage.dart';

class MainView extends StatefulWidget {
  const MainView({super.key, required this.name });

  final String name;

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
          Center(
            child: Text(
              '개발중입니다',
              style: TextStyle(
                fontSize: 40,
              ),
            ),
          ),
          CarManagementSystem(name: widget.name,),
          Center(
            child: Text(
              '개발중입니다',
              style: TextStyle(
                fontSize: 40,
              ),
            ),
          ),
          Center(
            child: Text(
              '개발중입니다',
              style: TextStyle(
                fontSize: 40,
              ),
            ),
          ),
          MyPage(),
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
            title = '지역 시스템';
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
            label: '지역',
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
