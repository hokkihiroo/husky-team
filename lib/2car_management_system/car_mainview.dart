import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/2car_management_system/team1/team1_view.dart';
import 'package:team_husky/2car_management_system/team2/team2_view.dart';
import 'package:team_husky/2car_management_system/team2/team2_z1_view.dart';
import 'package:team_husky/2car_management_system/team3/team3_view.dart';
import 'package:team_husky/2car_management_system/team4/team4_view.dart';

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
  final String cjAdress='zSvgctyCZUnOx8rYMioF'; //브랜드관리는 청주 주소에있어서 청주 문서 아이디를 담아 바깥에서 브랜드관리 들어갈때 사용


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Container(
          width: 300,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                ),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // 텍스트를 왼쪽으로 정렬
                  children: const [
                    Icon(Icons.edit), // 아이콘
                    SizedBox(width: 8), // 아이콘과 텍스트 사이의 간격
                    Text('브랜드관리'), // 텍스트
                  ],
                ),
              ),
              TextButton.icon(
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
                  Icons.logout,
                  color: Colors.black,
                ),
                label: const Text(
                  '로그아웃',
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
          ),
        ),
        iconTheme: IconThemeData(color: Colors.blue),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  if (team == 'PJcc0iQSHShpJvONGBC7' || team == 'e46miKLAbe8CjR1RsQkR') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Team1View(name: name)),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('입장 불가'),
                          content: Text('해당 팀만 접근가능합니다.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('확인'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Container(
                  width: 300.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black87, Colors.blueGrey],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      // 깊은 그림자
                      BoxShadow(
                        color: Colors.black54,
                        offset: Offset(4, 4),
                        blurRadius: 10.0,
                      ),
                      // 밝은 하이라이트 효과
                      BoxShadow(
                        color: Colors.white24,
                        offset: Offset(-4, -4),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 도시적 빌딩 느낌의 아이콘
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[800], // 배경색 추가
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black38,
                                offset: Offset(2, 2),
                                blurRadius: 4.0,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.apartment, // 빌딩 느낌의 Flutter 기본 아이콘
                            size: 35,
                            color: Colors.lightBlueAccent,
                          ),
                        ),
                        SizedBox(width: 15.0),
                        // 텍스트 정보
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '강남 [HMS]',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.lightBlueAccent,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.8,
                                  shadows: [
                                    Shadow(
                                      color: Colors.blueAccent.withOpacity(0.5),
                                      offset: Offset(1, 1),
                                      blurRadius: 2.0,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                '차량관리 시스템',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.lightBlueAccent,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.8,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black26,
                                      offset: Offset(1, 1),
                                      blurRadius: 1.5,
                                    ),
                                  ],
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
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (team == 'zSvgctyCZUnOx8rYMioF' ||
                          team == 'e46miKLAbe8CjR1RsQkR') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Team2View(name: name)),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('입장 불가'),
                              content: Text('해당 팀만 접근가능합니다.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('확인'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Container(
                      width: 145.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF1E1E1E), Color(0xFF3A3A3A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          // 깊은 그림자 (하단/오른쪽)
                          BoxShadow(
                            color: Colors.black87,
                            offset: Offset(6, 6),
                            blurRadius: 12.0,
                          ),
                          // 밝은 하이라이트 (상단/왼쪽)
                          BoxShadow(
                            color: Colors.white24,
                            offset: Offset(-4, -4),
                            blurRadius: 8.0,
                          ),
                        ],
                        border: Border.all(
                          color: Color(0xFFC6A667), // 고급스러운 골드 테두리
                          width: 1.5,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '청주 [GENESIS]',
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFFC6A667),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                                shadows: [
                                  Shadow(
                                    color: Colors.black38,
                                    offset: Offset(1, 1),
                                    blurRadius: 2.0,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              '고객차 차량관리',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFFC6A667),
                                // 골드 컬러
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.8,
                                shadows: [
                                  Shadow(
                                    color: Colors.black38,
                                    offset: Offset(1, 1),
                                    blurRadius: 2.0,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  GestureDetector(
                    onTap: () {
                      if (team == 'zSvgctyCZUnOx8rYMioF' ||
                          team == 'e46miKLAbe8CjR1RsQkR') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Team2Z1View(name: name)),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('입장 불가'),
                              content: Text('해당 팀만 접근가능합니다.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('확인'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Container(
                      width: 145.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF1E1E1E), Color(0xFF3A3A3A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          // 깊은 그림자 (하단/오른쪽)
                          BoxShadow(
                            color: Colors.black87,
                            offset: Offset(6, 6),
                            blurRadius: 12.0,
                          ),
                          // 밝은 하이라이트 (상단/왼쪽)
                          BoxShadow(
                            color: Colors.white24,
                            offset: Offset(-4, -4),
                            blurRadius: 8.0,
                          ),
                        ],
                        border: Border.all(
                          color: Color(0xFFC6A667), // 고급스러운 골드 테두리
                          width: 1.5,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '청주 [GENESIS]',
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFFC6A667),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                                shadows: [
                                  Shadow(
                                    color: Colors.black38,
                                    offset: Offset(1, 1),
                                    blurRadius: 2.0,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              '시승차 상태관리',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFFC6A667),
                                // 골드 컬러
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.8,
                                shadows: [
                                  Shadow(
                                    color: Colors.black38,
                                    offset: Offset(1, 1),
                                    blurRadius: 2.0,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  if (team == 'NWIXrK7TWAq7gW8x1w1b' ||
                      team == 'e46miKLAbe8CjR1RsQkR') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Team3View(
                                name: name,
                              )),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('입장 불가'),
                          content: Text('해당 팀만 접근가능합니다.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('확인'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Container(
                  width: 300.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orangeAccent, Colors.yellow], // 고양시 느낌의 따뜻한 색상
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        offset: Offset(4, 4),
                        blurRadius: 10.0,
                      ),
                      BoxShadow(
                        color: Colors.white24,
                        offset: Offset(-4, -4),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 왼쪽 아이콘: 고양이 느낌의 아이콘
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.black12, // 고양이 털 색상 느낌
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black38,
                                offset: Offset(2, 2),
                                blurRadius: 4.0,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.storage_outlined, // 🚗 시승차 느낌의 아이콘
                            size: 35,
                            color: Colors.amberAccent, // 노란색 포인트 유지
                          ),
                        ),
                        SizedBox(width: 15.0),
                        // 텍스트 정보
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '고양 [HMS]',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.brown[700],
                                  // 고양이 털 느낌의 색상
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.8,
                                  shadows: [
                                    Shadow(
                                      color: Colors.orange.withOpacity(0.5),
                                      offset: Offset(1, 1),
                                      blurRadius: 2.0,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                '시승차 상태관리',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.brown[700],
                                  // 고양이 털 느낌의 색상
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.8,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black26,
                                      offset: Offset(1, 1),
                                      blurRadius: 1.5,
                                    ),
                                  ],
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
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  if (team == 'B71qHzRliuN9iQeTygTe' ||
                      team == 'e46miKLAbe8CjR1RsQkR') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Team4View(name: name)),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('입장 불가'),
                          content: Text('해당 팀만 접근가능합니다.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('확인'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Container(
                  width: 300.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF0D1B2A), // 거의 검정에 가까운 남색
                        Color(0xFF1B263B), // 중간톤 네이비
                        Color(0xFF415A77), // 청회색 포인트
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal.withOpacity(0.3), // 부드러운 하단 그림자
                        offset: Offset(4, 4),
                        blurRadius: 10.0,
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.8), // 상단 밝은 반사광
                        offset: Offset(-3, -3),
                        blurRadius: 6.0,
                      ),
                    ],
                    border: Border.all(
                      color: Color(0xFF76C7C0), // 민트빛 테두리
                      width: 1.5,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 산뜻한 원형 아이콘
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF0F2027), // 어두운 남색-청록
                                Color(0xFF203A43), // 중간 톤 딥블루
                                Color(0xFF2C5364), // 약간 밝은 청회색
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.tealAccent.withOpacity(0.4),
                                offset: Offset(2, 2),
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.wb_sunny_outlined,
                            size: 35,
                            color: Color(0xFFFFC107), // 앰버톤 노랑 (머스타드 느낌)
                          ),
                        ),
                        SizedBox(width: 15.0),
                        // 텍스트 정보
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '수지 [GENESIS]',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFFFFC107), // 앰버톤 노랑 (머스타드 느낌)
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                  shadows: [
                                    Shadow(
                                      color: Colors.white.withOpacity(0.5),
                                      offset: Offset(0.5, 0.5),
                                      blurRadius: 1.0,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                '차량관리 시스템',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFFFC107), // 앰버톤 노랑 (머스타드 느낌)
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.2,
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
            ],
          ),
        ),
      ),
    );
  }
}
