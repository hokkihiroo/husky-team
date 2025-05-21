import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/2car_management_system/team2/team2_adress_const.dart';

class OutCarCard extends StatelessWidget {
  final String myName;
  final String carNumber;
  final String name;
  final String dataAdress;
  final int location;
  final String dataId;
  final String movedLocation;
  final String wigetName;
  final String movingTime;

  String CarListAdress = CARLIST + formatTodayDate();


  OutCarCard({
    super.key,
    required this.carNumber,
    required this.name, required this.location, required this.dataId, required this.myName, required this.dataAdress, required this.movedLocation, required this.wigetName, required this.movingTime
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            carNumber,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color:
                  name != null && name.isNotEmpty ? Colors.yellow : Colors.red,
            ),
          ),
          Text(
            name != null && name.isNotEmpty ? name : '비었음',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: name != null && name.isNotEmpty
                  ? Colors.yellow
                  : Colors.black,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20),
              backgroundColor: Colors.white, // 버튼 색상
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // 버튼 둥글게
              ),
            ),
            onPressed: () async {
              // CarListAdress = CARLIST + formatTodayDate();
              // print(CarListAdress);

              try {
                await FirebaseFirestore.instance
                    .collection(FIELD) // 컬렉션 이름을 지정하세요
                    .doc(dataId) // 삭제할 문서의 ID를 지정하세요
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
                  'outName':name,
                  'outLocation': location,
                  'movedLocation': movedLocation,
                  'wigetName': wigetName,
                  'movingTime': movingTime,
                });
              } catch (e) {
                print(e);
                print('데이터가 존재하지 않아 업데이트 할게 없습니당');
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('하루 지난 데이터 입니다 '),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('확인'),
                          ),
                        ],
                      );
                    });
              }
            },
            child: Text(
              '출차완료',
              style: TextStyle(
                fontSize: 16, // 텍스트 크기 증가
                fontWeight: FontWeight.bold, // 텍스트를 굵게
                color: Colors.black, // 텍스트 색상
              ),
            ),
          ),
        ],
      ),
    );
  }
}
