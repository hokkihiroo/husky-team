import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/2car_management_system/team5-Gwangju/team5-1/team5_outCar_card.dart';

import '../team5_adress.dart';

class Team5Outcar extends StatefulWidget {
  final String name;

  const Team5Outcar({super.key, required this.name});


  @override
  State<Team5Outcar> createState() => _OutCarState();
}

class _OutCarState extends State<Team5Outcar> {

  int location = 0; //차번호 클릭시 그차번호 위치
  String dataAdress = ''; // 차번호 클릭시 나오는 위치 주소값
  String movedLocation = ''; //과거 이동위치

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(TEAM5FIELD)
          .orderBy('option10')
          .snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final docs = snapshot.data!.docs;
        final filteredDocs = docs
            .where((doc) => doc['color'] == 2 || doc['color'] == 4)
            .toList();


        // 데이터 없으면 나오는 문구
        if (filteredDocs.isEmpty) {
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 24,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF111111),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF333333),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'FLOOR GUIDE',
                  style: TextStyle(
                    color: Color(0xFFB8B8B8),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 3,
                  ),
                ),

                const SizedBox(height: 8),

                Container(
                  height: 1,
                  color: const Color(0xFF444444),
                ),

                const SizedBox(height: 8),

                _floorItem(
                  floor: '7F',
                  title: '오너스 라운지',
                  subtitle: '루프탑 카페',
                ),
                _floorItem(
                  floor: '6F',
                  title: '특별한 전시공간',
                  subtitle: 'GV90 신차 등',
                ),
                _floorItem(
                  floor: '5F',
                  title: 'EV 전동화 모델',
                  subtitle: '전시공간',
                ),
                _floorItem(
                  floor: '4F',
                  title: '세단 전시공간',
                  subtitle: 'CMF 브랜드 큐브',
                ),
                _floorItem(
                  floor: '3F',
                  title: 'SUV 전시공간',
                  subtitle: '컬렉션 라운지 (상품)',
                ),
                _floorItem(
                  floor: '2F',
                  title: '시승 라운지',
                  subtitle: '시승 전후 대기공간',
                  isLast: true,
                ),
              ],
            ),
          );
        }

// 데이터 있으면 원래대로 출차모드
        return ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredDocs.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Team5OutcarCard(
                  carNumber: filteredDocs[index]['carNumber'],
                  name: filteredDocs[index]['name'],
                  option12: filteredDocs[index]['option12'],
                  etc: filteredDocs[index]['etc'],
                  dataId: filteredDocs[index].id,
                  location:  filteredDocs[index]['location'],
                  myName: widget.name,
                  dataAdress: TEAM5CARLIST,
                  movedLocation: filteredDocs[index]['movedLocation'],
                  wigetName: filteredDocs[index]['wigetName'],
                  color:  filteredDocs[index]['color'],
                  choolchaNum: index+1,
                ),
              ),
            );
          },
        );
      },
    );
  }
  Widget _floorItem({
    required String floor,
    required String title,
    required String subtitle,
    bool isLast = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 48,
                child: Text(
                  floor,
                  style: const TextStyle(
                    color: Color(0xFFC6A667),
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        subtitle,
                        style: const TextStyle(
                          color: Color(0xFFAAAAAA),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        if (!isLast)
          Container(
            height: 1,
            color: const Color(0xFF292929),
          ),
      ],
    );
  }

}
