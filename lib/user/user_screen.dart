import 'package:flutter/material.dart';
import 'package:team_husky/user/ResetPasswordPage.dart';
import 'package:team_husky/user/custom_text_form.dart';
import 'package:team_husky/user/user_auth.dart';
import 'package:team_husky/user/user_resume.dart';

import '../view/splash_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  String id = '';
  String password = '';

  // ============================================================
  // 디자인 색상
  // ============================================================

  static const Color navy = Color(0xFF17233C);
  static const Color navyLight = Color(0xFF253452);

  static const Color gold = Color(0xFFC6A667);
  static const Color goldLight = Color(0xFFE6D19A);

  static const Color background = Color(0xFFF3F1EC);
  static const Color textDark = Color(0xFF202632);
  static const Color textGrey = Color(0xFF7A808B);

  @override
  Widget build(BuildContext context) {
    final double screenHeight =
        MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: background,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // ==================================================
                // 상단 로고 영역
                // ==================================================

                Container(
                  width: double.infinity,
                  height: screenHeight < 700 ? 260 : 310,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        navy,
                        navyLight,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(45),
                      bottomRight: Radius.circular(45),
                    ),
                  ),
                  child: Stack(
                    children: [
                      // 은은한 장식 원
                      Positioned(
                        top: -80,
                        right: -70,
                        child: Container(
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: gold.withOpacity(0.08),
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: -100,
                        left: -80,
                        child: Container(
                          width: 240,
                          height: 240,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.04),
                          ),
                        ),
                      ),

                      // 로고
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 15,
                          ),
                          child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,

                                  // 이미지와 주변 흰색 영역 사이 경계선
                                  border: Border.all(
                                    color: const Color(0xFFD9DEE8),
                                    width: 1.5,
                                  ),

                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.25),
                                      blurRadius: 25,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'asset/img/logo.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 18),

                              const Text(
                                'TEAM HUSKY',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight:
                                  FontWeight.w900,
                                  letterSpacing: 3,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                'EMPLOYEE ONLY',
                                style: TextStyle(
                                  color: goldLight,
                                  fontSize: 11,
                                  fontWeight:
                                  FontWeight.w700,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ==================================================
                // 로그인 카드
                // ==================================================

                Transform.translate(
                  offset: const Offset(0, -25),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        24,
                        20,
                        22,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(25),
                        border: Border.all(
                          color: const Color(0xFFE4E1D9),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.10),
                            blurRadius: 25,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          // ==================================================
                          // 로그인 제목
                          // ==================================================

                          const Padding(
                            padding: EdgeInsets.only(
                              left: 5,
                            ),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '직원 로그인',
                                  style: TextStyle(
                                    color: textDark,
                                    fontSize: 24,
                                    fontWeight:
                                    FontWeight.w900,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  '팀허스키 직원 전용 서비스입니다.',
                                  style: TextStyle(
                                    color: textGrey,
                                    fontSize: 13,
                                    fontWeight:
                                    FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 22),

                          // ==================================================
                          // 아이디
                          // ==================================================

                          Container(
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.03),
                                  blurRadius: 8,
                                  offset:
                                  const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: CustomTextForm(
                              hintText: '아이디',
                              onChanged:
                                  (String value) {
                                id = value;
                              },
                              icon: const Icon(
                                Icons
                                    .account_circle_outlined,
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // ==================================================
                          // 비밀번호
                          // ==================================================

                          Container(
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.03),
                                  blurRadius: 8,
                                  offset:
                                  const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: CustomTextForm(
                              hintText: '비밀번호',
                              onChanged:
                                  (String value) {
                                password = value;
                              },
                              obscureText: true,
                              icon: const Icon(
                                Icons.lock_outline,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // ==================================================
                          // 로그인 버튼
                          // ==================================================

                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: navy,
                                foregroundColor:
                                Colors.white,
                                elevation: 4,
                                shadowColor: navy
                                    .withOpacity(0.35),
                                shape:
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                    16,
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                try {
                                  final newUser =
                                  await AUTH
                                      .signInWithEmailAndPassword(
                                    email: id,
                                    password: password,
                                  );

                                  if (newUser.user != null) {
                                    Navigator
                                        .pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return SplashScreen();
                                        },
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              },
                              child: const Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.login,
                                    size: 21,
                                  ),
                                  SizedBox(width: 9),
                                  Text(
                                    '로그인',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                      FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // ==================================================
                          // 비밀번호 찾기
                          // ==================================================

                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: OutlinedButton(
                              style:
                              OutlinedButton.styleFrom(
                                foregroundColor: navy,
                                side: const BorderSide(
                                  color: Color(0xFFD5D2C9),
                                ),
                                shape:
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                    15,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ResetPasswordPage();
                                    },
                                  ),
                                );
                              },
                              child: const Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons
                                        .lock_reset_outlined,
                                    size: 19,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    '비밀번호 찾기',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight:
                                      FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ==================================================
                // 이력서 작성 영역
                // ==================================================

                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    18,
                    0,
                    18,
                    0,
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: navy,
                      borderRadius:
                      BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color:
                          Colors.black.withOpacity(0.10),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // 아이콘
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: gold.withOpacity(0.16),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: gold.withOpacity(0.6),
                            ),
                          ),
                          child: const Icon(
                            Icons
                                .description_outlined,
                            color: goldLight,
                            size: 24,
                          ),
                        ),

                        const SizedBox(width: 13),

                        // 텍스트
                        const Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                '신규 직원이신가요?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight:
                                  FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '이력서를 작성하여 직원 등록을 진행하세요.',
                                style: TextStyle(
                                  color:
                                  Color(0xFFB8C0CF),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        // 이력서 작성 버튼
                        SizedBox(
                          height: 43,
                          child: ElevatedButton(
                            style:
                            ElevatedButton.styleFrom(
                              backgroundColor: gold,
                              foregroundColor: navy,
                              elevation: 0,
                              padding:
                              const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              shape:
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(
                                  13,
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return UserResume();
                                  },
                                ),
                              );
                            },
                            child: const Text(
                              '이력서 작성',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight:
                                FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ==================================================
                // 하단 안내
                // ==================================================

                const SizedBox(height: 35),

                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 25,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 25,
                            height: 1,
                            color: gold,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'TEAM HUSKY',
                            style: TextStyle(
                              color: textGrey,
                              fontSize: 10,
                              fontWeight:
                              FontWeight.w800,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 25,
                            height: 1,
                            color: gold,
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        '해당 앱은 팀허스키 직원 전용앱입니다.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: textGrey,
                          fontSize: 11,
                        ),
                      ),

                      const SizedBox(height: 4),

                      const Text(
                        'Copyright © Team.HUSKY 2018',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFA2A6AD),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ================================================================
// 기존 MyDialog
// ================================================================

class MyDialog extends StatelessWidget {
  const MyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Text(
        '아이디와 비밀번호를 확인하세요.',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            '닫기',
          ),
        ),
      ],
    );
  }
}