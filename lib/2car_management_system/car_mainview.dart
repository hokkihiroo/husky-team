import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:team_husky/2car_management_system/team1/team1_view.dart';
import 'package:team_husky/2car_management_system/team2/team2-1/team2_view.dart';
import 'package:team_husky/2car_management_system/team2/team2-2/team2_4_view.dart';
import 'package:team_husky/2car_management_system/team3/team3_view.dart';
import 'package:team_husky/2car_management_system/team4/team4_view.dart';
import 'package:team_husky/2car_management_system/team5-Gwangju/team5-1/team5_mainView.dart';
import 'package:team_husky/2car_management_system/team5-Gwangju/team5-2/team5-2_mainview.dart';

import '../5mypage/management/manegement/menues/teamMenues/brandManage.dart';
import '../user/user_screen.dart';

class CarManagementSystem extends StatelessWidget {
  const CarManagementSystem({
    super.key,
    required this.name,
    required this.team,
  });

  final String name;
  final String team;

  final String cjAdress = 'zSvgctyCZUnOx8rYMioF';

  // =========================
  // 색상
  // =========================
  static const Color navy = Color(0xFF17233C);
  static const Color navyLight = Color(0xFF253452);

  static const Color gold = Color(0xFFC6A667);
  static const Color goldLight = Color(0xFFE6D19A);

  static const Color background = Color(0xFFF3F1EC);
  static const Color textDark = Color(0xFF202632);
  static const Color textGrey = Color(0xFF737B89);

  // =========================
  // 접근 불가
  // =========================
  void _showDenied(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            '입장 불가',
            style: TextStyle(
              color: textDark,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: const Text(
            '해당 팀만 접근 가능합니다.',
            style: TextStyle(
              color: textGrey,
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: navy,
              ),
              child: const Text(
                '확인',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // =========================
  // 차량관리 카드
  // =========================
  Widget _menuCard({
    required String location,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 76,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              navyLight,
              navy,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: gold.withOpacity(0.65),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: navy.withOpacity(0.14),
              blurRadius: 9,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                location,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: goldLight,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // 섹션 제목
  // =========================
  Widget _sectionTitle({
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 2,
        bottom: 7,
      ),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 18,
            decoration: BoxDecoration(
              color: gold,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 7),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: textDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                subtitle,
                style: const TextStyle(
                  color: textGrey,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      // ==========================================================
      // APP BAR
      // ==========================================================
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: navy,
        foregroundColor: Colors.white,
        centerTitle: true,

        title: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'TEAM HUSKY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.2,
              ),
            ),
            SizedBox(height: 1),
            Text(
              '차량관리 시스템',
              style: TextStyle(
                color: goldLight,
                fontSize: 9,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.3,
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
            tooltip: '로그아웃',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.logout_rounded,
              color: Colors.white,
              size: 21,
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),

      // ==========================================================
      // BODY
      // ==========================================================
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(14, 13, 14, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ======================================================
            // ① 강남 + 수지
            // ======================================================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // -------------------------
                // 강남
                // -------------------------
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle(
                        title: '강남 [HMS]',
                        subtitle: '차량관리 시스템',
                      ),

                      _menuCard(
                        location: '강남 [HMS]',
                        title: '차량관리 시스템',
                        onTap: () {
                          if (team == 'PJcc0iQSHShpJvONGBC7' ||
                              team == 'e46miKLAbe8CjR1RsQkR') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Team1View(
                                  name: name,
                                ),
                              ),
                            );
                          } else {
                            _showDenied(context);
                          }
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // -------------------------
                // 수지
                // -------------------------
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle(
                        title: '수지 [GENESIS]',
                        subtitle: '차량관리 시스템',
                      ),

                      _menuCard(
                        location: '수지 [GENESIS]',
                        title: '차량관리 시스템',
                        onTap: () {
                          if (team == 'B71qHzRliuN9iQeTygTe' ||
                              team == 'e46miKLAbe8CjR1RsQkR') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Team4View(
                                  name: name,
                                ),
                              ),
                            );
                          } else {
                            _showDenied(context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 17),

            // ======================================================
            // ② 청주
            // ======================================================
            _sectionTitle(
              title: '청주 [GENESIS]',
              subtitle: 'GENESIS 차량관리',
            ),

            Row(
              children: [
                // 고객차
                Expanded(
                  child: _menuCard(
                    location: '청주 [GENESIS]',
                    title: '고객차 차량관리',
                    onTap: () {
                      if (team == 'zSvgctyCZUnOx8rYMioF' ||
                          team == 'e46miKLAbe8CjR1RsQkR') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Team2View(
                              name: name,
                            ),
                          ),
                        );
                      } else {
                        _showDenied(context);
                      }
                    },
                  ),
                ),

                const SizedBox(width: 10),

                // 시승차
                Expanded(
                  child: _menuCard(
                    location: '청주 [GENESIS]',
                    title: '시승차 상태관리',
                    onTap: () {
                      if (team == 'zSvgctyCZUnOx8rYMioF' ||
                          team == 'e46miKLAbe8CjR1RsQkR') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Team2Z1View(
                              name: name,
                            ),
                          ),
                        );
                      } else {
                        _showDenied(context);
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 17),

            // ======================================================
            // ③ 광주
            // ======================================================
            _sectionTitle(
              title: '광주 [GENESIS]',
              subtitle: 'GENESIS 차량관리',
            ),

            Row(
              children: [
                // 고객차
                Expanded(
                  child: _menuCard(
                    location: '광주 [GENESIS]',
                    title: '고객차 차량관리',
                    onTap: () {
                      if (team == 'NWIXrK7TWAq7gW8x1w1b' ||
                          team == 'e46miKLAbe8CjR1RsQkR') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Team5Mainview(
                              name: name,
                            ),
                          ),
                        );
                      } else {
                        _showDenied(context);
                      }
                    },
                  ),
                ),

                const SizedBox(width: 10),

                // 시승차
                Expanded(
                  child: _menuCard(
                    location: '광주 [GENESIS]',
                    title: '시승차 상태관리',
                    onTap: () {
                      if (team == 'NWIXrK7TWAq7gW8x1w1b' ||
                          team == 'e46miKLAbe8CjR1RsQkR') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Team5_2Mainview(
                              name: name,
                            ),
                          ),
                        );
                      } else {
                        _showDenied(context);
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),
            // ======================================================
            // 브랜드관리
            // ======================================================
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BrandManage(
                      teamDocId: cjAdress,
                      grade: 0,
                    ),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                height: 62,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      navyLight,
                      navy,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: gold,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: navy.withOpacity(0.14),
                      blurRadius: 9,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '브랜드관리',
                            style: TextStyle(
                              color: goldLight,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            '차량 브랜드 및 브랜드 설정 관리',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 9.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: goldLight,
                      size: 22,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 17),

            // ======================================================
            // 하단
            // ======================================================
            Center(
              child: Column(
                children: [
                  Container(
                    width: 30,
                    height: 1,
                    color: gold.withOpacity(0.7),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    'TEAM HUSKY',
                    style: TextStyle(
                      color: navy,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'VEHICLE MANAGEMENT SYSTEM',
                    style: TextStyle(
                      color: textGrey.withOpacity(0.6),
                      fontSize: 7,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}