import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:team_husky/2car_management_system/team2/team2_adress_const.dart';
import 'package:team_husky/2car_management_system/team2/team2_carschedule.dart';
import 'package:team_husky/2car_management_system/team2/team2_carschedule_view.dart';
import 'package:team_husky/2car_management_system/team2/team2_electric.dart';
import 'package:team_husky/2car_management_system/team2/team2_ipcha_view.dart';
import 'package:team_husky/2car_management_system/team2/team2_oil_view.dart';

import 'team2_car_list.dart';
import 'team2_model.dart';
import 'team2_outcar.dart';

class Team2View extends StatefulWidget {
  const Team2View({super.key, required this.name});

  final String name;

  @override
  State<Team2View> createState() => _Team2ViewState();
}

class _Team2ViewState extends State<Team2View> {
  String carNumber = '';
  String CarListAdress = CARLIST + formatTodayDate();
  String Color5List = COLOR5 + formatTodayDate();
  String CarScheduleAdress = formatTodayDate();
  String dayOfWeek = '';
  int bottomAction = 0;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    dayOfWeek = getDayOfWeek(now);

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
                    '제네시스 청주',
                    style: TextStyle(
                      color: Color(0xFFC6A667), // 골드 컬러로 고급스러움 강조
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => OilView(name: widget.name,)),
                  // );

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Electric()),
                  );
                },
                child: Text(
                  '전기차',
                  style: TextStyle(
                    color: Color(0xFFC6A667), // 골드 컬러로 고급스러움 강조
                    decorationColor: Colors.white,
                    // 줄 색상
                    decorationThickness: 2, // 줄 두께
                  ),
                ),
              ),
              // SizedBox(
              //   width: 15,
              // ),
              // GestureDetector(
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => Team2CarSchedule()),
              //     );
              //   },
              //   child: Text(
              //     '시승',
              //     style: TextStyle(
              //       color: Color(0xFFC6A667), // 골드 컬러로 고급스러움 강조
              //       // 줄긋기 설정
              //       decorationColor: Colors.white,
              //       // 줄 색상
              //       decorationThickness: 2, // 줄 두께
              //     ),
              //   ),
              // ),
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
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     IconButton(
              //       icon: Icon(Icons.refresh), // 새로고침 아이콘
              //       color: Colors.green,
              //       onPressed: () {
              //         setState(() {
              //           CarScheduleAdress = formatTodayDate();
              //           DateTime now = DateTime.now();
              //           dayOfWeek = getDayOfWeek(now);
              //         });
              //       },
              //     ),
              //     Text(
              //       '시승차 현황 ($CarScheduleAdress) $dayOfWeek',
              //       style: TextStyle(
              //         fontSize: 15,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ],
              // ),
              // Team2CarSchduleView(
              //   CarScheduleAdress: CarScheduleAdress,
              // ),
              // Divider(
              //   color: Colors.white, // 선 색상
              //   thickness: 2.0, // 선 두께
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  Text(
                    '입차 대기',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(

                    onTap: () {
                      String topic = '시승차입니다';
                      String hint = '시승차번호를 입력해주세요';
                      int color = 5;

                      doEnterAction(topic,hint,color);
                    },
                    child: Text(
                      '시승차',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                  )

                ],
              ),
              SizedBox(
                height: 10,
              ),
              Team2IpchaView(
                name: widget.name,
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
                height: 10,
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
              height: 80,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle:
                      TextStyle(fontWeight: FontWeight.w800, fontSize: 25),
                ),
                onPressed: () => doEnterAction('고객차입니다','번호를 입력해주세요', 1),
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
              height: 80,
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

  void doEnterAction(topic,hint,color) {




    CarListAdress = CARLIST + formatTodayDate();
    Color5List = COLOR5 + formatTodayDate();
    carNumber = '0000';
    final targetCollection = (color == 5) ? Color5List : CarListAdress;

    print(targetCollection); // 어떤 컬렉션으로 들어가는지 확인

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            topic,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: color == 5 ? Colors.purple : Colors.black, // 기본색은 원하는 색으로 변경
            ),
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
                hintText: hint,
                hintStyle: TextStyle(
                  color: color == 5 ? Colors.purple : Colors.grey, // 기본 힌트 색은 회색
                ),
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
                          .collection(FIELD)
                          .doc()
                          .id;
                      try {
                        await FirebaseFirestore.instance
                            .collection(FIELD)
                            .doc(documentId)
                            .set({
                          'carNumber': carNumber,
                          'name': '',
                          'createdAt':
                          FieldValue.serverTimestamp(),
                          'location': 0,
                          'color': color,
                          'etc': '',
                          'movedLocation': '입차',
                          'wigetName': '',
                          'movingTime': '',
                          'carBrand': '',
                          'carModel': '',
                        });
                      } catch (e) {}

                      try {
                        await FirebaseFirestore.instance
                            .collection(targetCollection)
                            .doc(documentId)
                            .set({
                          'carNumber': carNumber,
                          'enterName': widget.name,
                          'enter': FieldValue.serverTimestamp(),
                          'out': '',
                          'outName': '',
                          'outLocation': 10,
                          'etc': '',
                          'movedLocation': '',
                          'wigetName': '',
                          'movingTime': '',
                          'carBrand': '',
                          'carModel': '',
                        });
                      } catch (e) {}
                      Navigator.pop(context);
                    },
                    child: Text('입력'),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          vertical: 20.0), // 버튼의 위아래 패딩 조정
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Text('취소'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
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
              '가벽',
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
              'A존',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'B존',
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
              'B2',
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
              '외부',
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

  _Lists({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              CarState(
                name: name,
                location: FIELD,
                reverse: 1,
                check: () {},
                fieldLocation: 1,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              CarState(
                name: name,
                location: FIELD,
                reverse: 1,
                check: () {},
                fieldLocation: 2,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              CarState(
                name: name,
                location: FIELD,
                reverse: 1,
                check: () {},
                fieldLocation: 3,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              CarState(
                name: name,
                location: FIELD,
                reverse: 1,
                check: () {},
                fieldLocation: 4,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              CarState(
                name: name,
                location: FIELD,
                reverse: 1,
                check: () {},
                fieldLocation: 5,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
