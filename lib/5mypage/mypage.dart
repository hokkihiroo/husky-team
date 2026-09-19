import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:team_husky/5mypage/authorization/authorization.dart';
import 'package:team_husky/5mypage/management/management.dart';
import 'package:team_husky/5mypage/management/manegement/menues/teamMenues/brandManage.dart';
import 'package:team_husky/5mypage/mylicense/myLicenseUpdate.dart';
import 'package:team_husky/5mypage/myschedule/myschedule.dart';
import 'package:team_husky/user/user_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import 'mysalary/mySalary.dart';
import 'updatePicture/mypicture.dart';

class MyPage extends StatefulWidget {
  const MyPage({
    super.key,
    required this.name,
    required this.uid,
    required this.team,
    required this.email,
    required this.grade,
    required this.birthDay,
    required this.picUrl,
  });

  final String name;
  final String uid;
  final String team;
  final String email;
  final int grade;
  final String birthDay;
  final String picUrl;

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final String cjAdress = 'zSvgctyCZUnOx8rYMioF';

  static const Color navy = Color(0xFF17233C);
  static const Color gold = Color(0xFFC6A667);
  static const Color background = Color(0xFFF5F6F8);
  static const Color textDark = Color(0xFF20242B);
  static const Color textGrey = Color(0xFF747B87);

  void _launchWebsite(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showProfilePicture() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: MyPicture(
            uid: widget.uid,
            team: widget.team,
          ),
        );
      },
    );
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const UserScreen(),
      ),
    );
  }

  Widget _menuButton({
    required IconData icon,
    required String title,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 76,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE4E7EC),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: navy.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: navy,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF9AA1AC),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _adminButton({
    required IconData icon,
    required String title,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FB),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFE1E4E9),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: navy,
              size: 21,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: textDark,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Color(0xFF8B929D),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: background,
      
        // 프로필 영역
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(142),
          child: Container(
            decoration: const BoxDecoration(
              color: navy,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 12, 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _showProfilePicture,
                      child: Container(
                        width: 78,
                        height: 78,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: gold,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.18),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          backgroundColor: const Color(0xFFD9DDE4),
                          backgroundImage: widget.picUrl.isNotEmpty
                              ? NetworkImage(widget.picUrl)
                              : null,
                          child: widget.picUrl.isEmpty
                              ? const Icon(
                            Icons.person_rounded,
                            size: 42,
                            color: Colors.white,
                          )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFFC9CED8),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '생년월일  ${widget.birthDay}',
                            style: const TextStyle(
                              color: Color(0xFFC9CED8),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _logout,
                      tooltip: '로그아웃',
                      icon: const Icon(
                        Icons.logout_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      
        // 본문
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '내 메뉴',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 12),
      
                // 급여명세서 / 브랜드관리
                Row(
                  children: [
                    _menuButton(
                      icon: Icons.payments_outlined,
                      title: '급여명세서',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MySalary(
                              name: widget.name,
                              uid: widget.uid,
                              team: widget.team,
                              management: false,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    _menuButton(
                      icon: Icons.directions_car_outlined,
                      title: '브랜드관리',
                      onPressed: () {
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
                    ),
                  ],
                ),
      
                const SizedBox(height: 24),
      
                // 관리자 메뉴
                if (widget.grade == 1 || widget.grade == 2) ...[
                  const Text(
                    '관리자',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFFE3E6EB),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _adminButton(
                          icon: Icons.admin_panel_settings_outlined,
                          title: '관리자 페이지',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Management(
                                  name: widget.name,
                                ),
                              ),
                            );
                          },
                        ),
                        if (widget.grade == 2) ...[
                          const SizedBox(height: 10),
                          _adminButton(
                            icon: Icons.security_outlined,
                            title: '관리자 권한 설정',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Authorization(),
                                ),
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
      
                // 앱 버전
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFFE5E8ED),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        size: 18,
                        color: textGrey,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          '버전 3.0  ·  디자인, 기능 대폭 수정',
                          style: TextStyle(
                            fontSize: 12,
                            color: textGrey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      
        // 하단 회사 정보
        bottomNavigationBar: Container(
          height: 78,
          color: navy,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '(주) 팀허스키',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Copyright © Team.HUSKY 2018',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFFBFC5D0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  const siteUrl =
                      'https://sites.google.com/view/teamhusky-privacy?usp=sharing';
      
                  _launchWebsite(siteUrl);
                },
                child: const Text(
                  '개인정보 처리방침',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}