import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/car_management_system/team1/team1_adress_const.dart';
import 'package:team_husky/car_management_system/team1/team1_numbercard.dart';

class RotaryList extends StatefulWidget {
  final String location;
  final int reverse;
  final VoidCallback check;
  final String name;

  const RotaryList(
      {super.key,
      required this.location,
      required this.reverse,
      required this.check,
      required this.name});

  @override
  State<RotaryList> createState() => _RotaryListState();
}

class _RotaryListState extends State<RotaryList> {
  String dataId = ''; //차번호 클릭시 그 차번호에 고유 아이디값
  String carNumber = ''; // 차번호 클릭시 차번호 추출
  int location = 0; //차번호 클릭시 그차번호 위치
  String dataAdress = ''; // 차번호 클릭시 나오는 위치 주소값
  int color = 1; //출차누르면 값이 2로 바뀌고 1이아닌색생은 노랑으로 표시
  DateTime dateTime = DateTime.now();
  String name = ''; //픽업 하는 사람 이름
  String etc = ''; // 특이사항
  String remainTime = ''; // 경과시간
  String CarListAdress = CARLIST + formatTodayDate();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(widget.location)
          .orderBy('createdAt')
          .snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final docs = snapshot.data!.docs;
        return ListView.builder(
          reverse: widget.reverse == 1 ? true : false,
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: GestureDetector(
                onTap: () async {
                  // 활성화 시키면 bar 가 바뀜 데이터 클릭시마다

                  var document = docs[index];
                  dataId = document.id;
                  name = docs[index]['name'];
                  carNumber = docs[index]['carNumber'];
                  location = docs[index]['location'];
                  color = docs[index]['color'];
                  etc = docs[index]['etc'];
                  Timestamp createdAt = docs[index]['createdAt'];
                  dateTime = createdAt.toDate();
                  remainTime = getRemainTime(dateTime);
                  dataAdress = CheckLocation(location); //파이어베이스 데이터주소

                  print('데이터 주소 : $dataAdress');
                  print('sdsdsdsdsdsddID: $dataId');

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return bottomTwo(carNumber, name, color, location,
                          dateTime, dataAdress, dataId, etc, remainTime);
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: NumberCard(
                    carNumber: docs[index]['carNumber'],
                    name: docs[index]['name'],
                    color: docs[index]['color'],
                    etc: docs[index]['etc'],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget bottomTwo(String carNumber, String name, int color, int location,
      DateTime dateTime, String dataAdress, String dataId, String etc,String remainTime) {
    return AlertDialog(
      title: Text('차량번호: $carNumber - $remainTime'),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                if (location != 0)
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18),
                        ),
                        onPressed: () async {
                          try {
                            await FirebaseFirestore.instance
                                .collection(dataAdress) // 컬렉션 이름을 지정하세요
                                .doc(dataId) // 삭제할 문서의 ID를 지정하세요
                                .delete();
                            print('문서 삭제 완료');
                          } catch (e) {
                            print('문서 삭제 오류: $e');
                          }
                          Navigator.pop(context);

                          try {
                            await FirebaseFirestore.instance
                                .collection(LOTARY)
                                .doc(dataId)
                                .set({
                              'carNumber': carNumber,
                              'color': color,
                              'createdAt': dateTime,
                              'location': 0,
                              'name': name,
                              'etc': etc,
                            });
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Text('로터')),
                  ),
                if (location != 0)
                  SizedBox(
                    width: 5,
                  ),
                if (location != 1)
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18),
                        ),
                        onPressed: () async {
                          try {
                            await FirebaseFirestore.instance
                                .collection(dataAdress) // 컬렉션 이름을 지정하세요
                                .doc(dataId) // 삭제할 문서의 ID를 지정하세요
                                .delete();
                            print('문서 삭제 완료');
                          } catch (e) {
                            print('문서 삭제 오류: $e');
                          }
                          Navigator.pop(context);

                          try {
                            await FirebaseFirestore.instance
                                .collection(OUTSIDE)
                                .doc(dataId)
                                .set({
                              'carNumber': carNumber,
                              'color': color,
                              'createdAt': dateTime,
                              'location': 1,
                              'name': name,
                              'etc': etc,
                            });
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Text('외벽')),
                  ),
                if (location != 1)
                  SizedBox(
                    width: 5,
                  ),
                if (location != 2)
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18),
                        ),
                        onPressed: () async {
                          try {
                            await FirebaseFirestore.instance
                                .collection(dataAdress) // 컬렉션 이름을 지정하세요
                                .doc(dataId) // 삭제할 문서의 ID를 지정하세요
                                .delete();
                            print('문서 삭제 완료');
                          } catch (e) {
                            print('문서 삭제 오류: $e');
                          }
                          Navigator.pop(context);

                          try {
                            await FirebaseFirestore.instance
                                .collection(MAIN)
                                .doc(dataId)
                                .set({
                              'carNumber': carNumber,
                              'color': color,
                              'createdAt': dateTime,
                              'location': 2,
                              'name': name,
                              'etc': etc,
                            });
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Text('광장')),
                  ),
                if (location != 2)
                  SizedBox(
                    width: 5,
                  ),
                if (location != 3)
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18),
                        ),
                        onPressed: () async {
                          try {
                            await FirebaseFirestore.instance
                                .collection(dataAdress) // 컬렉션 이름을 지정하세요
                                .doc(dataId) // 삭제할 문서의 ID를 지정하세요
                                .delete();
                            print('문서 삭제 완료');
                          } catch (e) {
                            print('문서 삭제 오류: $e');
                          }
                          Navigator.pop(context);

                          try {
                            await FirebaseFirestore.instance
                                .collection(MOON)
                                .doc(dataId)
                                .set({
                              'carNumber': carNumber,
                              'color': color,
                              'createdAt': dateTime,
                              'location': 3,
                              'name': name,
                              'etc': etc,
                            });
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Text('문앞')),
                  ),
                if (location != 4 && location != 3)
                  SizedBox(
                    width: 5,
                  ),
                if (location != 4)
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18),
                        ),
                        onPressed: () async {
                          try {
                            await FirebaseFirestore.instance
                                .collection(dataAdress) // 컬렉션 이름을 지정하세요
                                .doc(dataId) // 삭제할 문서의 ID를 지정하세요
                                .delete();
                            print('문서 삭제 완료');
                          } catch (e) {
                            print('문서 삭제 오류: $e');
                          }
                          Navigator.pop(context);

                          try {
                            await FirebaseFirestore.instance
                                .collection(SINSA)
                                .doc(dataId)
                                .set({
                              'carNumber': carNumber,
                              'color': color,
                              'createdAt': dateTime,
                              'location': 4,
                              'name': name,
                              'etc': etc,
                            });
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Text('신사')),
                  ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);

                      try {
                        await FirebaseFirestore.instance
                            .collection(dataAdress)
                            .doc(dataId)
                            .update({
                          'name': widget.name,
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text('픽업'),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);

                      try {
                        await FirebaseFirestore.instance
                            .collection(dataAdress)
                            .doc(dataId)
                            .update({
                          'name': '',
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text('픽업취소'),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);

                        try {
                          await FirebaseFirestore.instance
                              .collection(dataAdress)
                              .doc(dataId)
                              .update({
                            'color': 2,
                          });
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Text('출차')),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);

                      try {
                        await FirebaseFirestore.instance
                            .collection(dataAdress)
                            .doc(dataId)
                            .update({
                          'color': 1,
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text('출차취소'),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);

                        try {
                          await FirebaseFirestore.instance
                              .collection(dataAdress) // 컬렉션 이름을 지정하세요
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
                            'outName' :widget.name,
                            'outLocation' : location,
                          });
                        } catch (e) {
                          print(e);
                          print('데이터가 존재하지 않아 업데이트 할게 없습니당');
                        }
                      },
                      child: Text('출차완료')),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);

                        try {
                          await FirebaseFirestore.instance
                              .collection(dataAdress) // 컬렉션 이름을 지정하세요
                              .doc(dataId) // 삭제할 문서의 ID를 지정하세요
                              .delete();
                          print('문서 삭제 완료');
                        } catch (e) {
                          print('문서 삭제 오류: $e');
                        }
                      },
                      child: Text('차량삭제')),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 17),
                      ),
                      onPressed: () {
                        Navigator.pop(context);

                        setState(() {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('특이사항'),
                                  content: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 150,
                                    child: Column(
                                      children: [
                                        TextField(
                                          inputFormatters: [],
                                          maxLength: 15,
                                          decoration: InputDecoration(
                                            hintText: '특이사항 15자까지가능',
                                          ),
                                          onChanged: (value) {
                                            etc = value;
                                          },
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                                child: ElevatedButton(
                                                    onPressed: () async {
                                                      Navigator.pop(context);

                                                      try {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                dataAdress)
                                                            .doc(dataId)
                                                            .update({
                                                          'etc': etc,
                                                        });
                                                      } catch (e) {
                                                        print(e);
                                                      }
                                                    },
                                                    child: Text('등록'))),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('취소'))),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        });
                      },
                      child: Text('특이사항 입력')),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      textStyle:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);

                      try {
                        await FirebaseFirestore.instance
                            .collection(dataAdress)
                            .doc(dataId)
                            .update({
                          'etc': '',
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text('삭제'),
                  ),
                ),
              ],
            ),
            Text(
              '$etc',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
