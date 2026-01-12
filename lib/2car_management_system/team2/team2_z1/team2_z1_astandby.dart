import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/2car_management_system/team2/team2_z1/team2_z1_standbycard.dart';

import '../team2_adress_const.dart';

class StandBy extends StatefulWidget {
  final String name;

  const StandBy({
    super.key,
    required this.name,
  });

  @override
  State<StandBy> createState() => _StandByState();
}

class _StandByState extends State<StandBy> {
  String Color5List = COLOR5 + formatTodayDate();

  String dataId = ''; //차번호 클릭시 그 차번호에 고유 아이디값
  String carNumber = ''; // 차번호 클릭시 차번호 추출
  int location = 0; //차번호 클릭시 그차번호 위치
  String dataAdress = ''; // 차번호 클릭시 나오는 위치 주소값
  int color = 1; //출차누르면 값이 2로 바뀌고 1이아닌색생은 노랑으로 표시
  DateTime dateTime = DateTime.now();
  String name = ''; //픽업 하는 사람 이름
  String etc = ''; // 특이사항
  String remainTime = ''; // 경과시간
  String movedLocation = ''; //과거 이동위치
  String wigetName = ''; //추가할 이름들 뽑음
  String enterName = ''; //추가할 이름들 뽑음
  String movingTime = ''; //이동할 시각들 뽑음
  String carModelFrom = ''; // 눌럿을때 파베에서 차종뽑아서 전연변수에 넣은 값
  int selectedTabIndex = 0;

  late TextEditingController etcController;

  @override
  void initState() {
    super.initState();
    etcController = TextEditingController(text: etc ?? '');
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(FIELD)
          .where('color', isEqualTo: 5)
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

        final List<QueryDocumentSnapshot> displayList = docs.where((doc) {
          final int docLocation = doc['location'];
          return docLocation == 0 || docLocation == 5;
        }).toList();


        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // 가로 아이템 개수
            crossAxisSpacing: 10.0, // 가로 간격
            mainAxisSpacing: 18.0, // 세로 간격
            childAspectRatio: 1.6, // 아이템의 가로세로 비율
          ),
          itemCount: displayList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                //  활성화 시키면 bar 가 바뀜 데이터 클릭시마다
                Color5List = COLOR5 + formatTodayDate();
                var document = displayList[index];
                dataId = document.id;
                name = displayList[index]['name'];
                enterName = displayList[index]['enterName'];
                carNumber = displayList[index]['carNumber'];
                carModelFrom = displayList[index]['carModel'];
                location = displayList[index]['location'];
                color = displayList[index]['color'];
                etc = displayList[index]['etc'];
                wigetName = displayList[index]['wigetName'];
                movedLocation = displayList[index]['movedLocation'];
                Timestamp createdAt = displayList[index]['createdAt'];
                dateTime = createdAt.toDate();
                remainTime = getRemainTime(dateTime);
                //     dataAdress = CheckLocation(location); //파이어베이스 데이터주소

                String getMovingTime = getTodayTime();
                final BuildContext rootContext = context;

                showDialog(
                  context: rootContext,
                  builder: (BuildContext context) {
                    return bottomColor5(
                      carNumber,
                      name,
                      color,
                      location,
                      dateTime,
                      dataId,
                      etc,
                      remainTime,
                      movedLocation,
                      wigetName,
                      movingTime,
                      getMovingTime,
                      carModelFrom,
                    );
                  },
                );
              },
              child: StandByCard(
                carNumber: displayList[index]['carNumber'],
                name: displayList[index]['name'],
                color: displayList[index]['color'],
                etc: displayList[index]['etc'],
                carBrand: displayList[index]['carBrand'],
                carModel: displayList[index]['carModel'],
                location: displayList[index]['location'],
              ),
            );
          },
        );
      },
    );
  }

  Widget bottomColor5(
      String carNumber,
      String name,
      int color,
      int location,
      DateTime dateTime,
      String dataId,
      String etc,
      String remainTime,
      String movedLocation,
      String wigetName,
      String movingTime,
      String getMovingTime,
      String carModelFrom,
      ) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '차종: $carModelFrom',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  '차량번호: $carNumber',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  '경과: $remainTime',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: 60,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await FirebaseFirestore.instance
                        .collection(FIELD)
                        .doc(dataId)
                        .update({
                      'location': 11,
                      'name':'',
                    });
                  } catch (e) {
                    print(e);
                  }
                  Navigator.pop(context);
                  // try {
                  //   await FirebaseFirestore.instance
                  //       .collection(Color5List)
                  //       .doc(dataId)
                  //       .update({
                  //     'out': FieldValue.serverTimestamp(),
                  //     'outName': name,
                  //     'wigetName': wigetName,
                  //     'etc': '$etc/시승취소',
                  //   });
                  // } catch (e) {
                  //   print(e);
                  //   print('데이터가 존재하지 않아 업데이트 할게 없습니당');
                  //   showDialog(
                  //       context: context,
                  //       builder: (BuildContext context) {
                  //         return AlertDialog(
                  //           title: Text('하루 지난 데이터 입니다 '),
                  //           actions: [
                  //             ElevatedButton(
                  //               onPressed: () {
                  //                 Navigator.pop(context);
                  //               },
                  //               child: Text('확인'),
                  //             ),
                  //           ],
                  //         );
                  //       });
                  // }
                },
                child: Text(
                  '시승취소',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      content: Container(
        width: MediaQuery.of(context).size.width.clamp(0, 290),
        height: 320,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      backgroundColor: Colors.grey, // 버튼 색상
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // 버튼 둥글게
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                      try {
                        await FirebaseFirestore.instance
                            .collection(FIELD)
                            .doc(dataId)
                            .update({
                          'name': '대면',
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      '대면',
                      style: TextStyle(
                        fontSize: 17, // 텍스트 크기 증가
                        fontWeight: FontWeight.bold, // 텍스트를 굵게
                        color: Colors.black87, // 텍스트 색상
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      backgroundColor: Colors.grey, // 버튼 색상
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // 버튼 둥글게
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);

                      try {
                        await FirebaseFirestore.instance
                            .collection(FIELD)
                            .doc(dataId)
                            .update({
                          'name': '비대',
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      '비대면',
                      style: TextStyle(
                        fontSize: 17, // 텍스트 크기 증가
                        fontWeight: FontWeight.bold, // 텍스트를 굵게
                        color: Colors.black87, // 텍스트 색상
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      backgroundColor: Colors.grey, // 버튼 색상
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // 버튼 둥글게
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                      try {
                        await FirebaseFirestore.instance
                            .collection(FIELD)
                            .doc(dataId)
                            .update({
                          'name': '현동',
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      '현장동승',
                      style: TextStyle(
                        fontSize: 17, // 텍스트 크기 증가
                        fontWeight: FontWeight.bold, // 텍스트를 굵게
                        color: Colors.black87, // 텍스트 색상
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      backgroundColor: Colors.grey, // 버튼 색상
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // 버튼 둥글게
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);

                      try {
                        await FirebaseFirestore.instance
                            .collection(FIELD)
                            .doc(dataId)
                            .update({
                          'name': '현비',
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      '현장비동승',
                      style: TextStyle(
                        fontSize: 17, // 텍스트 크기 증가
                        fontWeight: FontWeight.bold, // 텍스트를 굵게
                        color: Colors.black87, // 텍스트 색상
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      backgroundColor: Colors.grey, // 버튼 색상
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // 버튼 둥글게
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                      try {
                        await FirebaseFirestore.instance
                            .collection(FIELD)
                            .doc(dataId)
                            .update({
                          'name': '주유',
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      '주유',
                      style: TextStyle(
                        fontSize: 17, // 텍스트 크기 증가
                        fontWeight: FontWeight.bold, // 텍스트를 굵게
                        color: Colors.black87, // 텍스트 색상
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      backgroundColor: Colors.grey, // 버튼 색상
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // 버튼 둥글게
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);

                      try {
                        await FirebaseFirestore.instance
                            .collection(FIELD)
                            .doc(dataId)
                            .update({
                          'name': '인도',
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      '인도',
                      style: TextStyle(
                        fontSize: 17, // 텍스트 크기 증가
                        fontWeight: FontWeight.bold, // 텍스트를 굵게
                        color: Colors.black87, // 텍스트 색상
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      backgroundColor: Colors.grey, // 버튼 색상
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // 버튼 둥글게
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                      try {
                        await FirebaseFirestore.instance
                            .collection(FIELD)
                            .doc(dataId)
                            .update({
                          'name': '컬러',
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      '컬러확인',
                      style: TextStyle(
                        fontSize: 17, // 텍스트 크기 증가
                        fontWeight: FontWeight.bold, // 텍스트를 굵게
                        color: Colors.black87, // 텍스트 색상
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      backgroundColor: Colors.grey, // 버튼 색상
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // 버튼 둥글게
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);

                      try {
                        await FirebaseFirestore.instance
                            .collection(FIELD)
                            .doc(dataId)
                            .update({
                          'name': '교육',
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      '교육용',
                      style: TextStyle(
                        fontSize: 17, // 텍스트 크기 증가
                        fontWeight: FontWeight.bold, // 텍스트를 굵게
                        color: Colors.black87, // 텍스트 색상
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        vertical: 18, // ⬅ 두께(높이) 증가
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600, // 글자도 살짝 더 굵게
                        fontSize: 17,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      etcController.text = etc;

                      setState(() {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('특이사항'),
                                content: Container(
                                  width: MediaQuery.of(context)
                                      .size
                                      .width
                                      .clamp(0, 290),
                                  height: 150,
                                  child: Column(
                                    children: [
                                      TextField(
                                        controller: etcController,
                                        maxLength: 20,
                                        decoration: InputDecoration(
                                          hintText: '특이사항 20자까지가능',
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
                                                          .collection(FIELD)
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
                    child: Text(
                      '특이사항입력하기',
                      style: TextStyle(
                        fontSize: 15, // 텍스트 크기 증가
                        fontWeight: FontWeight.bold, // 텍스트를 굵게
                        color: Colors.yellow, // 텍스트 색상
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Text(
              '$etc',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            // Row(
            //   children: [
            //     SizedBox(
            //       width: 5,
            //     ),
            //     Expanded(
            //       flex: 2,
            //       child: ElevatedButton(
            //         style: ElevatedButton.styleFrom(
            //           textStyle:
            //               TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            //         ),
            //         onPressed: () async {
            //           Navigator.pop(context);
            //
            //           // try {
            //           //   await FirebaseFirestore.instance
            //           //       .collection(dataAdress)
            //           //       .doc(dataId)
            //           //       .update({
            //           //     'color': 1,
            //           //   });
            //           // } catch (e) {
            //           //   print(e);
            //           // }
            //         },
            //         child: Text('출차취소'),
            //       ),
            //     ),
            //     Expanded(
            //       child: ElevatedButton(
            //           style: ElevatedButton.styleFrom(
            //             textStyle: TextStyle(
            //                 fontWeight: FontWeight.w500, fontSize: 18),
            //           ),
            //           onPressed: () async {
            //             // try {
            //             //   await FirebaseFirestore.instance
            //             //       .collection(dataAdress) // 컬렉션 이름을 지정하세요
            //             //       .doc(dataId) // 삭제할 문서의 ID를 지정하세요
            //             //       .delete();
            //             //   print('문서 삭제 완료');
            //             // } catch (e) {
            //             //   print('문서 삭제 오류: $e');
            //             // }
            //             // Navigator.pop(context);
            //             //
            //             // try {
            //             //   await FirebaseFirestore.instance
            //             //       .collection(CarListAdress)
            //             //       .doc(dataId)
            //             //       .update({
            //             //     'out': FieldValue.serverTimestamp(),
            //             //     'outName': widget.name,
            //             //     'outLocation': location,
            //             //     'movedLocation': '$movedLocation',
            //             //     'wigetName': wigetName,
            //             //     'movingTime': movingTime,
            //             //   });
            //             // } catch (e) {
            //             //   print(e);
            //             //   print('데이터가 존재하지 않아 업데이트 할게 없습니당');
            //             //   showDialog(
            //             //       context: context,
            //             //       builder: (BuildContext context) {
            //             //         return AlertDialog(
            //             //           title: Text('하루 지난 데이터 입니다 '),
            //             //           actions: [
            //             //             ElevatedButton(
            //             //               onPressed: () {
            //             //                 Navigator.pop(context);
            //             //               },
            //             //               child: Text('확인'),
            //             //             ),
            //             //           ],
            //             //         );
            //             //       });
            //             // }
            //           },
            //           child: Text('출차완료')),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
