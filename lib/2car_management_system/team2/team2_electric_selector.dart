import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/2car_management_system/team2/team2_adress_const.dart';

class ElectricButtonDialog extends StatefulWidget {
  final String carNumber;
  final String name;
  final int color;
  final int location;
  final DateTime dateTime;
  final String dataId;
  final String etc;
  final String remainTime;
  final String movedLocation;
  final String wigetName;
  final String movingTime;
  final String getMovingTime;
  final String carModelFrom;

  const ElectricButtonDialog({
    Key? key,
    required this.carNumber,
    required this.name,
    required this.color,
    required this.location,
    required this.dateTime,
    required this.dataId,
    required this.etc,
    required this.remainTime,
    required this.movedLocation,
    required this.wigetName,
    required this.movingTime,
    required this.getMovingTime,
    required this.carModelFrom,
  }) : super(key: key);

  @override
  _ElectricButtonDialogState createState() => _ElectricButtonDialogState();
}

class _ElectricButtonDialogState extends State<ElectricButtonDialog> {
  int selectedNumber = 0; //전기차 충전 기기 번호
  int selectedLocation = 0; // 전기차 충전시 체류장소 인트화 시킴

  String ElectricList = ELECTRICLIST + electricDate(); //전기차 컬렉션주소 업데이트
  String ElectricDay =  electricDay(); //전기차 매일날짜 업데이트


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '차량번호: ${widget.carNumber}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 5),
              Text(
                '해당차종: ${widget.carModelFrom}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      '전기 충전 번호',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) {
                      final number = index + 1;
                      final isSelected = selectedNumber == number;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedNumber = number;
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue : Colors.white,
                            border: Border.all(color: isSelected ? Colors.blue : Colors.black45),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$number',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      '체류장소',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(3, (index) {
                      final number = index + 1;
                      final isSelected = selectedLocation == number;
                      final labels = ['차량내', '거점내', '기타장소'];

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedLocation = number;
                            print(selectedLocation);
                          });
                        },
                        child: Container(
                          width: 70,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue : Colors.white,
                            border: Border.all(color: isSelected ? Colors.blue : Colors.black45),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            labels[index],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            )

          ],
        ),
      ),
      actionsPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      actions: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  Navigator.pop(context);

                  if (selectedNumber == 0 || selectedLocation == 0) {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                          contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                          actionsPadding: const EdgeInsets.only(right: 12, bottom: 12),
                          title: Row(
                            children: [
                              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
                              SizedBox(width: 8),
                              Text(
                                '안내',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          content: Text(
                            '전기충전번호 혹은 체류장소가 선택되지 않았습니다.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          actions: [
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                '닫기',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                    return;
                  }

                  ElectricList = ELECTRICLIST + electricDate();
                  ElectricDay =  electricDay(); //전기차 입차 날짜 업데이트

                  String documentId = FirebaseFirestore
                      .instance
                      .collection(ElectricList)
                      .doc()
                      .id;

                  try {
                    await FirebaseFirestore.instance
                        .collection(ElectricList)
                        .doc(documentId)
                        .set({
                      'carNumber': widget.carNumber,
                      'enterName': widget.name,
                      'enter': FieldValue.serverTimestamp(),
                      'out': '',
                      'etc': widget.etc,
                      'carModel': widget.carModelFrom,
                      'theDay': ElectricDay,
                      'chargeNumber': selectedNumber,
                      'selectedLocation': selectedLocation,
                    });
                  } catch (e) {}
                },
                child: Text(
                  '전기차 등록',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  '취소',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
