import 'package:flutter/material.dart';
import 'package:team_husky/1insa/Insa.dart';
import 'package:team_husky/3notice/gongji.dart';
import 'package:team_husky/layout/default_layout.dart';

import '../2car_management_system/car_mainview.dart';
import '../4event/event_main.dart';
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

  // ============================================================
  // 행사 페이지 접근 허용 팀 ID
  //
  // 나중에 행사 페이지를 사용할 팀의 팀 ID를 여기에 입력
  //
  // 예)
  // return [
  //   '팀ID1',
  //   '팀ID2',
  // ];
  // ============================================================

  List<String> eventAllowedTeams() {
    return [
      'e46miKLAbe8CjR1RsQkR',
      // '허용할팀ID2',
    ];
  }

  // ============================================================
  // 기존 제한 사용자
  //
  // 기존 restrictedEmails() 기능은 그대로 유지
  // ============================================================

  bool isRestrictedUser() {
    return restrictedEmails().contains(widget.email);
  }

  // ============================================================
  // 행사 페이지 접근 가능 여부
  //
  // 이메일이 아니라 현재 로그인한 직원의 팀 ID(widget.team)로 확인
  // ============================================================

  bool canAccessEvent() {
    return eventAllowedTeams().contains(widget.team);
  }

  // ============================================================
  // 행사 접근 제한 팝업 표시 여부
  // ============================================================

  bool eventDialogShown = false;

  @override
  void initState() {
    super.initState();

    controller = TabController(
      length: 5,
      vsync: this,
      initialIndex: 1,
    );

    controller.addListener(tabListner);
  }

  @override
  void dispose() {
    controller.removeListener(tabListner);
    controller.dispose();
    super.dispose();
  }

  // ============================================================
  // 탭 변경
  // ============================================================

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
        title = '행사전용(베타테스트)';
      } else if (index == 4) {
        title = 'MyPage';
      }
    });

    // ==========================================================
    // 행사 페이지 접근 확인
    //
    // 일단 EventMain을 보여준 다음
    // 허용되지 않은 팀이면 팝업 표시
    // ==========================================================

    if (controller.index == 3 &&
        !canAccessEvent() &&
        !eventDialogShown) {
      eventDialogShown = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        showEventRestrictedDialog();
      });
    }
  }

  // ============================================================
  // 기존 제한 사용자 팝업
  // ============================================================

  void showRestrictedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('안내'),
          content: const Text(
            '해당 메뉴에 접근할 수 없습니다.',
          ),
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

  // ============================================================
  // 행사 접근 제한 팝업
  //
  // EventMain을 먼저 보여준 뒤 팝업 표시
  // 확인 → 시설 페이지 이동
  // ============================================================

  void showEventRestrictedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 100,
            vertical: 40,
          ),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 상단 남색 영역
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(
                    12,
                    12,
                    12,
                    12,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFF17233C),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: const Color(0xFFC6A667)
                              .withOpacity(0.18),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock_outline_rounded,
                          color: Color(0xFFE6D19A),
                          size: 18,
                        ),
                      ),
                      const SizedBox(height: 7),
                      const Text(
                        '행사전용',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // 안내 내용
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    12,
                    12,
                    12,
                    12,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '접근 권한이 없습니다.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF303641),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        '행사전용 메뉴는\n지정된 팀만 사용할 수 있습니다.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF737B89),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // 확인 버튼
                      SizedBox(
                        width: double.infinity,
                        height: 34,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();

                            // 팝업 표시 상태 초기화
                            eventDialogShown = false;

                            // 기존 기능 유지: 시설 페이지로 이동
                            controller.animateTo(1);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            const Color(0xFF17233C),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(9),
                            ),
                          ),
                          child: const Text(
                            '확인',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: index == 0 || index == 1 || index == 4
          ? null
          : title,

      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          // ==========================================================
          // 조직
          // ==========================================================

          Organization(
            grade: widget.grade,
          ),

          // ==========================================================
          // 시설
          // ==========================================================

          CarManagementSystem(
            name: widget.name,
            team: widget.team,
          ),

          // ==========================================================
          // 공지
          // ==========================================================

          Notication(),

          // ==========================================================
          // 행사
          //
          // 여기서는 접근을 막지 않음
          // EventMain이 먼저 화면에 표시되고
          // tabListner에서 팀 ID를 확인하여 팝업 표시
          // ==========================================================

          EventMain(
            name: widget.name,

          ),

          // ==========================================================
          // 내정보
          // ==========================================================

          MyPage(
            name: widget.name,
            email: widget.email,
            grade: widget.grade,
            team: widget.team,
            uid: widget.myUid,
            birthDay: widget.birthDay,
            picUrl: widget.picUrl,
          ),
        ],
      ),

      // ============================================================
      // 하단 네비게이션
      // ============================================================

      bottomNavigationBar: NavigationBar(
        selectedIndex: index,

        onDestinationSelected: (int selectedIndex) {
          // ========================================================
          // 기존 제한 사용자
          //
          // 시설(index 1)만 접근 가능
          // ========================================================

          if (isRestrictedUser() && selectedIndex != 1) {
            showRestrictedDialog();
            return;
          }

          // ========================================================
          // 행사도 여기서는 막지 않음
          //
          // 먼저 EventMain으로 이동
          // 이후 tabListner에서 팀 ID 확인
          // ========================================================

          controller.animateTo(selectedIndex);
        },

        height: 70,

        backgroundColor: Colors.white,

        elevation: 3,

        indicatorColor: const Color(0xFFE8EEF7),

        labelBehavior:
        NavigationDestinationLabelBehavior.alwaysShow,

        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.perm_identity_outlined,
            ),
            selectedIcon: Icon(
              Icons.perm_identity,
            ),
            label: '조직',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.drive_eta_outlined,
            ),
            selectedIcon: Icon(
              Icons.drive_eta,
            ),
            label: '시설',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.notifications_outlined,
            ),
            selectedIcon: Icon(
              Icons.notifications,
            ),
            label: '공지',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.auto_stories_outlined,
            ),
            selectedIcon: Icon(
              Icons.auto_stories,
            ),
            label: '행사',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.menu_outlined,
            ),
            selectedIcon: Icon(
              Icons.menu,
            ),
            label: '내정보',
          ),
        ],
      ),
    );
  }
}