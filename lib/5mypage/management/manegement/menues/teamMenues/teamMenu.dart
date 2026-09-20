import 'package:flutter/material.dart';
import 'package:team_husky/5mypage/management/manegement/menues/teamMenues/TestDrivingCar.dart';
import 'package:team_husky/5mypage/management/manegement/menues/teamMenues/changeStaffNum.dart';
import 'package:team_husky/5mypage/management/manegement/menues/teamMenues/forGenesis.dart';

import 'brandManage.dart';

class TeamMenu extends StatelessWidget {
  final String teamName;
  final String position;
  final String teamDocId;
  final int grade = 1;

  const TeamMenu({
    super.key,
    required this.teamName,
    required this.position,
    required this.teamDocId,
  });

  static const Color navy = Color(0xFF17233C);
  static const Color navyLight = Color(0xFF253452);
  static const Color gold = Color(0xFFC6A667);
  static const Color textDark = Color(0xFF303641);
  static const Color textGrey = Color(0xFF737B89);
  static const Color background = Color(0xFFF4F5F7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: navy,
        foregroundColor: Colors.white,
        title: Text(
          '$position $teamName 전용',
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 팀 정보 카드
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 17,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    navy,
                    navyLight,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: navy.withOpacity(0.18),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: gold.withOpacity(0.16),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(
                      Icons.settings_rounded,
                      color: gold,
                      size: 23,
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          teamName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$position 전용 관리 메뉴',
                          style: const TextStyle(
                            color: Color(0xFFD5DAE3),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 메뉴 제목
            const Row(
              children: [
                Text(
                  '관리 메뉴',
                  style: TextStyle(
                    color: textDark,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Divider(
                    color: Color(0xFFDDE1E7),
                    thickness: 1,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 시승차 관리
            _buildMenuCard(
              context: context,
              icon: Icons.directions_car_rounded,
              title: '시승차관리',
              subtitle: '현대전용',
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
            ),

            const SizedBox(height: 10),

            // 직원순서 변경
            _buildMenuCard(
              context: context,
              icon: Icons.format_list_numbered_rounded,
              title: '직원순서 변경',
              subtitle: '직원 표시 순서 관리',
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
            ),

            const SizedBox(height: 10),

            // 브랜드 관리
            _buildMenuCard(
              context: context,
              icon: Icons.directions_car_filled_rounded,
              title: '브랜드관리',
              subtitle: '브랜드 및 차종 관리 · 삭제가능',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BrandManage(
                      teamDocId: teamDocId,
                      grade: grade,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            // 제네시스
            _buildMenuCard(
              context: context,
              icon: Icons.auto_awesome_rounded,
              title: '시승차관리',
              subtitle: '제네시스전용',
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          width: double.infinity,
          height: 72,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE2E5EA),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
            ),
            child: Row(
              children: [
                // 골드 포인트
                Container(
                  width: 4,
                  height: 34,
                  decoration: BoxDecoration(
                    color: gold,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),

                const SizedBox(width: 12),

                // 아이콘
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: navy.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: navy,
                    size: 21,
                  ),
                ),

                const SizedBox(width: 13),

                // 텍스트
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: textDark,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: textGrey,
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF9AA1AC),
                  size: 21,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}