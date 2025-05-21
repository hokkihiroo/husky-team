import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:team_husky/2car_management_system/team1/team1_adress_const.dart';
import 'package:team_husky/2car_management_system/team1/team1_car_list.dart';
import 'package:team_husky/2car_management_system/team1/team1_carschedule.dart';
import 'package:team_husky/2car_management_system/team1/team1_carschedule_view.dart';
import 'package:team_husky/2car_management_system/team1/team1_model.dart';
import 'package:team_husky/2car_management_system/team1/team1_outcar.dart';
import 'package:another_telephony/telephony.dart';
class Team1View extends StatefulWidget {
  const Team1View({super.key, required this.name});

  final String name;

  @override
  State<Team1View> createState() => _Team1ViewState();
}

class _Team1ViewState extends State<Team1View> {
  String carNumber = '';
  String CarListAdress = CARLIST + formatTodayDate();
  Telephony telephony = Telephony.instance;
  String CarScheduleAdress = formatTodayDate();
  String dayOfWeek = '';

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      requestSmsPermission(context);
    }
    DateTime now = DateTime.now();
    dayOfWeek = getDayOfWeek(now);
  }

  void requestSmsPermission(BuildContext context) async {
    bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
    if (permissionsGranted ?? false) {
      print("퍼미션이 허용되었습니다.");
    } else {
      print('SMS 및 전화 수신에 대한 퍼미션이 거부되었습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    '현대모터스튜디오 강남',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CarSchedule()),
                  );
                },
                child: Text(
                  '시승차',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Divider(
                color: Colors.white, // 선 색상
                thickness: 2.0, // 선 두께
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '시승차 현황 ($CarScheduleAdress) $dayOfWeek',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        CarScheduleAdress = formatTodayDate();
                        DateTime now = DateTime.now();
                        dayOfWeek = getDayOfWeek(now);
                      });
                    },
                    child: Text(
                      '새로고침',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              CarScheduleView(
                CarScheduleAdress: CarScheduleAdress,
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Colors.white, // 선 색상
                thickness: 2.0, // 선 두께
              ),
              _LocationName(),
              SizedBox(
                height: 20,
              ),
              _Lists(
                name: widget.name,
              ),
              Divider(
                color: Colors.white, // 선 색상
                thickness: 2.0, // 선 두께
              ),
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        '출차중',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              OutCar(
                name: widget.name,
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        bottomNavigationBar: bottomOne());
  }

  Widget bottomOne() {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 5,
          ),
          Expanded(
            flex: 3,
            child: SizedBox(
              height: 100,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle:
                      TextStyle(fontWeight: FontWeight.w800, fontSize: 25),
                ),
                onPressed: () {
                  CarListAdress = CARLIST + formatTodayDate();
                  print(CarListAdress);
                  carNumber = '0000';
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          '입차번호',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                        actions: [
                          TextField(
                            keyboardType: TextInputType.number,
                            autofocus: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9]')),
                            ],
                            maxLength: 4,
                            decoration: InputDecoration(
                              hintText: '입차번호를 입력해주세요',
                            ),
                            onChanged: (value) {
                              carNumber = value;
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 20.0), // 버튼의 위아래 패딩 조정
                                  ),
                                  onPressed: () async {
                                    String documentId = FirebaseFirestore
                                        .instance
                                        .collection(LOTARY)
                                        .doc()
                                        .id;
                                    try {
                                      await FirebaseFirestore.instance
                                          .collection(LOTARY)
                                          .doc(documentId)
                                          .set({
                                        'carNumber': carNumber,
                                        'name': '',
                                        'createdAt':
                                            FieldValue.serverTimestamp(),
                                        'location': 0,
                                        'color': 1,
                                        'etc': '',
                                        'movedLocation': '로터리',
                                        'wigetName': '',
                                        'movingTime': '',
                                      });
                                    } catch (e) {}

                                    try {
                                      await FirebaseFirestore.instance
                                          .collection(CarListAdress)
                                          .doc(documentId)
                                          .set({
                                        'carNumber': carNumber,
                                        'enterName': widget.name,
                                        'enter': FieldValue.serverTimestamp(),
                                        'out': '',
                                        'outName': '',
                                        'outLocation': 5,
                                        'etc': '',
                                        'movedLocation': '',
                                        'wigetName': '',
                                        'movingTime': '',
                                      });
                                    } catch (e) {}
                                    Navigator.pop(context);
                                  },
                                  child: Text('입력'),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    String documentId = FirebaseFirestore
                                        .instance
                                        .collection(LOTARY)
                                        .doc()
                                        .id;
                                    try {
                                      await FirebaseFirestore.instance
                                          .collection(LOTARY)
                                          .doc(documentId)
                                          .set({
                                        'carNumber': carNumber,
                                        'name': '',
                                        'createdAt':
                                            FieldValue.serverTimestamp(),
                                        'location': 0,
                                        'color': 1,
                                        'etc': '작업차량',
                                        'movedLocation': '로터리',
                                        'wigetName': '',
                                        'movingTime': '',
                                      });
                                    } catch (e) {}

                                    try {
                                      await FirebaseFirestore.instance
                                          .collection(CarListAdress)
                                          .doc(documentId)
                                          .set({
                                        'carNumber': carNumber,
                                        'enterName': widget.name,
                                        'enter': FieldValue.serverTimestamp(),
                                        'out': '',
                                        'outName': '',
                                        'outLocation': 5,
                                        'etc': '작업차량',
                                        'movedLocation': '',
                                        'wigetName': '',
                                        'movingTime': '',
                                      });
                                    } catch (e) {}
                                    Navigator.pop(context);
                                  },
                                  child: Text('작업'),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: ElevatedButton(
                                    onPressed: () async {
                                      String documentId = FirebaseFirestore
                                          .instance
                                          .collection(LOTARY)
                                          .doc()
                                          .id;
                                      try {
                                        await FirebaseFirestore.instance
                                            .collection(LOTARY)
                                            .doc(documentId)
                                            .set({
                                          'carNumber': carNumber,
                                          'name': '',
                                          'createdAt':
                                              FieldValue.serverTimestamp(),
                                          'location': 0,
                                          'color': 1,
                                          'etc': '직원',
                                          'movedLocation': '로터리',
                                          'wigetName': '',
                                          'movingTime': '',
                                        });
                                      } catch (e) {}

                                      try {
                                        await FirebaseFirestore.instance
                                            .collection(CarListAdress)
                                            .doc(documentId)
                                            .set({
                                          'carNumber': carNumber,
                                          'enterName': widget.name,
                                          'enter': FieldValue.serverTimestamp(),
                                          'out': '',
                                          'outName': '',
                                          'outLocation': 5,
                                          'etc': '직원',
                                          'movedLocation': '',
                                          'wigetName': '',
                                          'movingTime': '',
                                        });
                                      } catch (e) {}
                                      Navigator.pop(context);
                                    },
                                    child: Text('직원')),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('ENTER'),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 100,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle:
                      TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CarList(),
                    ),
                  );
                },
                child: Icon(
                  Icons.description_outlined,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
        ],
      ),
      color: Colors.black,
    );
  }
}


class _LocationName extends StatelessWidget {
  const _LocationName({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Text(
              '로터',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Text(
              '외벽',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ),
          Expanded(
            child: Text(
              '광장',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Text(
              '문앞',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Text(
              '신사',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Lists extends StatelessWidget {
  final String name;

  const _Lists({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              RotaryList(
                name: name,
                location: LOTARY,
                reverse: 1,
                check: () {},
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              RotaryList(
                name: name,
                location: OUTSIDE,
                reverse: 1,
                check: () {},
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              RotaryList(
                name: name,
                location: MAIN,
                reverse: 1,
                check: () {},
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              RotaryList(
                name: name,
                location: MOON,
                reverse: 1,
                check: () {},
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              RotaryList(
                name: name,
                location: SINSA,
                reverse: 1,
                check: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
