import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/2car_management_system/team4/team4_adress.dart';

class Team4OutcarCard extends StatelessWidget {
  final String myName;
  final String carNumber;
  final String name;
  final String dataAdress;
  final int location;
  final int color;
  final String dataId;
  final String movedLocation;
  final String wigetName;
  final String movingTime;
  final String etc;
  final int choolchaNum;

  String CarListAdress = TEAM4CARLIST + Team4formatTodayDate();

  Team4OutcarCard({
    super.key,
    required this.carNumber,
    required this.name,
    required this.location,
    required this.dataId,
    required this.myName,
    required this.dataAdress,
    required this.movedLocation,
    required this.wigetName,
    required this.movingTime,
    required this.color,
    required this.choolchaNum,
    required this.etc,
  });

  @override
  Widget build(BuildContext context) {
    // etc 최대 20자를 10자씩 두 줄로 표시
    String etcLine1 = etc.length > 10 ? etc.substring(0, 10) : etc;
    String etcLine2 = etc.length > 10
        ? etc.substring(10, etc.length > 20 ? 20 : etc.length)
        : '';

    return Container(
      height: 70,
      color: Colors.black,
      child: Column(
        children: [
          SizedBox(
            height: 58,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  choolchaNum.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),

                Text(
                  carNumber,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: color == 4
                        ? Colors.green
                        : (name.isNotEmpty ? Colors.yellow : Colors.red),
                  ),
                ),

                // 기존 name 위치에 etc 표시
                SizedBox(
                  width: 130,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        etcLine1,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (etcLine2.isNotEmpty)
                        Text(
                          etcLine2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),

                color == 4
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          minimumSize: const Size(0, 40),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          try {
                            await FirebaseFirestore.instance
                                .collection(TEAM4FIELD)
                                .doc(dataId)
                                .update({
                              'color': 1,
                              'name': '',
                            });
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: const Text(
                          '회차완료',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          minimumSize: const Size(0, 40),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          try {
                            await FirebaseFirestore.instance
                                .collection(TEAM4FIELD)
                                .doc(dataId)
                                .delete();

                            print('문서 삭제 완료');
                          } catch (e) {
                            print('문서 삭제 오류: $e');
                          }

                          try {
                            await FirebaseFirestore.instance
                                .collection(CarListAdress)
                                .doc(dataId)
                                .update({
                              'out': FieldValue.serverTimestamp(),
                              'outName': name,
                              'outLocation': location,
                              'movedLocation': movedLocation,
                              'wigetName': wigetName,
                              'movingTime': movingTime,
                            });

                            print('출차완료 업데이트 완료');
                          } catch (e) {
                            print('데이터가 존재하지 않아 업데이트 할게 없습니당');

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('하루 지난 데이터 입니다 '),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('확인'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: const Text(
                          '출차완료',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
