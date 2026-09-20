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

  const Management({
    super.key,
    required this.name,
  });

  @override
  State<Management> createState() => _ManagementState();
}

class _ManagementState extends State<Management> {
  static const Color navy = Color(0xFF17233C);
  static const Color navyLight = Color(0xFF253452);
  static const Color gold = Color(0xFFC6A667);
  static const Color goldLight = Color(0xFFE6D19A);
  static const Color background = Color(0xFFF4F5F7);
  static const Color textDark = Color(0xFF202632);
  static const Color textGrey = Color(0xFF737B89);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: navy,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          '관리자 설정',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 안내 영역
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
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
                    color: Colors.black.withOpacity(0.12),
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
                      color: gold.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                        color: gold.withOpacity(0.45),
                      ),
                    ),
                    child: const Icon(
                      Icons.settings_rounded,
                      color: goldLight,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 13),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '관리자 설정',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '팀 운영에 필요한 설정을 관리합니다.',
                          style: TextStyle(
                            color: Color(0xFFD4D9E2),
                            fontSize: 13,
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

            const Padding(
              padding: EdgeInsets.only(left: 3),
              child: Text(
                '관리 메뉴',
                style: TextStyle(
                  color: textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 10),

            _buildStyledButton(
              context: context,
              icon: Icons.groups_rounded,
              label: '팀 개설',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MakeTeam(),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            _buildStyledButton(
              context: context,
              icon: Icons.swap_horiz_rounded,
              label: '인사이동 / 직위, 포지션 변경',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MoveInsa(),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            _buildStyledButton(
              context: context,
              icon: Icons.campaign_rounded,
              label: '공지사항 관리',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ManageGongjiList(name: widget.name),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            _buildStyledButton(
              context: context,
              icon: Icons.calendar_month_rounded,
              label: '스케줄 관리',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManageSchedule(),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            _buildStyledButton(
              context: context,
              icon: Icons.menu_book_rounded,
              label: '교육자료 등록/삭제',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EducationManage(name: widget.name),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            _buildStyledButton(
              context: context,
              icon: Icons.badge_rounded,
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

            const SizedBox(height: 10),

            _buildStyledButton(
              context: context,
              icon: Icons.payments_rounded,
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

            const SizedBox(height: 20),

            TeamOnly(),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(15),
        child: Ink(
          width: double.infinity,
          height: 62,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
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
          child: Row(
            children: [
              const SizedBox(width: 15),

              // 아이콘
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: navy.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  icon,
                  color: navy,
                  size: 21,
                ),
              ),

              const SizedBox(width: 13),

              // 메뉴명
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: textDark,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.1,
                  ),
                ),
              ),

              // 골드 포인트
              Container(
                width: 3,
                height: 24,
                decoration: BoxDecoration(
                  color: gold,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),

              const SizedBox(width: 10),

              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF9AA1AC),
                size: 21,
              ),

              const SizedBox(width: 13),
            ],
          ),
        ),
      ),
    );
  }
}