import 'package:flutter/material.dart';
import 'package:team_husky/2car_management_system/team1/team1_view.dart';
import 'package:team_husky/2car_management_system/team2/team2_view.dart';

class CarManagementSystem extends StatelessWidget {
  const CarManagementSystem({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 15,),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Team1View(name: name)),
            );
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
                      color:Colors.lightBlueAccent,
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
                          'HMS 강남',
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
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Team2View(name: name)),
            );
          },
          child: Container(
            width: 300.0,
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 고급스러운 제네시스 로고 느낌의 아이콘
                  // 고급스러운 자동차 아이콘
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF2A2A2A),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          offset: Offset(3, 3),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.directions_car, // 자동차 아이콘
                      size: 35,
                      color: Color(0xFFC6A667), // 골드 컬러로 고급스러움 강조
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
                          '제네시스 청주',
                          style: TextStyle(
                            fontSize: 20,
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
                          '차량관리 시스템',
                          style: TextStyle(
                            fontSize: 16,
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
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

