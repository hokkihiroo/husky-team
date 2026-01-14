import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/2car_management_system/team2/team2_adress_const.dart';
import 'package:team_husky/2car_management_system/team2/team2_electric_selector.dart';

import 'team2_numbercard.dart';

class CarState extends StatefulWidget {
  final String location;
  final int reverse;
  final VoidCallback check;
  final String name;
  final int fieldLocation;

  final Map<String, List<String>> domesticBrands;
  final Map<String, List<String>> importedFamousBrands;
  final Map<String, List<String>> otherBrands;

  const CarState({
    super.key,
    required this.location,
    required this.reverse,
    required this.check,
    required this.name,
    required this.fieldLocation,
    required this.domesticBrands,
    required this.importedFamousBrands,
    required this.otherBrands,
  });

  @override
  State<CarState> createState() => _CarStateState();
}

class _CarStateState extends State<CarState> {
  String dataId = ''; //차번호 클릭시 그 차번호에 고유 아이디값
  String carNumber = ''; // 차번호 클릭시 차번호 추출
  int location = 0; //차번호 클릭시 그차번호 위치
  String dataAdress = ''; // 차번호 클릭시 나오는 위치 주소값
  int color = 1; //출차누르면 값이 2로 바뀌고 1이아닌색생은 노랑으로 표시
  DateTime dateTime = DateTime.now();
  DateTime dateTime2 = DateTime.now(); //이동할 시각들 뽑음
  String name = ''; //픽업 하는 사람 이름
  String etc = ''; // 특이사항
  String remainTime = ''; // 경과시간
  String CarListAdress = CARLIST + formatTodayDate();
  String Color5List = COLOR5 + formatTodayDate();
  String movedLocation = ''; //과거 이동위치
  String wigetName = ''; //추가할 이름들 뽑음
  String enterName = ''; //자가주차 내역
  String movingTime = ''; //움직인 시간 / 거의 시승차로 씀

  String carModelFrom = ''; // 번호눌럿을때 차종 뽑아서 넣는 전연변수
  int selectedTabIndex = 0;

  int selectedNumber = 0; // 선택된 버튼 번호를 저장할 변수 이건 전기차 관련된 변수임

  late TextEditingController etcController;

  String option1 = ''; //컬러5에 들어갈 문서 필드에서 뽑아낸문서
  int option2 = 0; //하이패스잔액
  int option3 = 0; // 주유잔량
  int option4 = 0; //총킬로수
  String option5 = ''; //시승차 기타
  String option6 = '';
  String option7 = '';

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
        final filteredDocs = docs
            .where((doc) => doc['location'] == widget.fieldLocation)
            .toList();

        return ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredDocs.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: GestureDetector(
                onTap: () async {
                  //  활성화 시키면 bar 가 바뀜 데이터 클릭시마다
                  CarListAdress = CARLIST + formatTodayDate();
                  Color5List = COLOR5 + formatTodayDate();
                  var document = filteredDocs[index];
                  dataId = document.id;
                  name = filteredDocs[index]['name'];
                  enterName = filteredDocs[index]['enterName'];
                  carNumber = filteredDocs[index]['carNumber'];
                  carModelFrom = filteredDocs[index]['carModel'];
                  location = filteredDocs[index]['location'];
                  color = filteredDocs[index]['color'];
                  etc = filteredDocs[index]['etc'];
                  wigetName = filteredDocs[index]['wigetName'];
                  movedLocation = filteredDocs[index]['movedLocation'];
                  final raw = filteredDocs[index]['movingTime'];
                  movingTime =
                      raw is Timestamp ? movingTimeGet(raw.toDate()) : '';
                  Timestamp createdAt = filteredDocs[index]['createdAt'];
                  dateTime = createdAt.toDate();
                  remainTime = getRemainTime(dateTime);
                  String getMovingTime = getTodayTime();
                  final BuildContext rootContext = context;
                  option1 = filteredDocs[index]['option1']; //시승차 컬러5에 넣는 문서주소
                  option2 = filteredDocs[index]['option2']; // 하이패스잔액
                  option3 = filteredDocs[index]['option3']; //주유잔량
                  option4 = filteredDocs[index]['option4']; //총킬로수
                  option5 = filteredDocs[index]['option5']; //시승차 기타
                  option6 = filteredDocs[index]['option6']; //시승차 예비용
                  option7 = filteredDocs[index]['option7']; //시승차 예비용

                  showDialog(
                    context: rootContext,
                    builder: (BuildContext context) {
                      if (color == 5) {
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
                          option1,
                          option2,
                          option3,
                          option4,
                          option5,
                        );
                      } else {
                        return bottomTwo(
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
                          enterName,
                          rootContext,
                          context,
                        );
                      }
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Team2NumberCard(
                    carNumber: filteredDocs[index]['carNumber'],
                    name: filteredDocs[index]['name'],
                    color: filteredDocs[index]['color'],
                    etc: filteredDocs[index]['etc'],
                    carBrand: filteredDocs[index]['carBrand'],
                    carModel: filteredDocs[index]['carModel'],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget bottomTwo(
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
    String enterName,
    BuildContext rootContext, // 화면 context (show용)
    BuildContext dialogContext, // bottomTwo 닫기용
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
          if (color != 3 && color != 6)
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
                        'color': color == 2 ? 1 : 2,
                      });
                    } catch (e) {
                      print(e);
                    }
                    Navigator.pop(context);
                  },
                  child: Text(
                    color == 2 ? '출차취소' : '출차하기',
                    style: TextStyle(
                      fontSize: 18, // 텍스트 크기 증가
                      fontWeight: FontWeight.bold, // 텍스트를 굵게
                      color: Colors.black87, // 텍스트 색상
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    backgroundColor: color == 2 ? Colors.orange : Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // 버튼 둥글게
                    ),
                  ),
                ),
              ),
            ),
          if (color == 3 || color == 6)
            Expanded(
              child: Container(
                height: 60,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await FirebaseFirestore.instance
                          .collection(FIELD) // 컬렉션 이름을 지정하세요
                          .doc(dataId) // 삭제할 문서의 ID를 지정하세요
                          .delete();
                      print('문서 삭제 완료');
                    } catch (e) {
                      print('문서 삭제 오류: $e');
                    }
                    Navigator.pop(context);
                    try {
                      await FirebaseFirestore.instance
                          .collection(CarListAdress)
                          .doc(dataId)
                          .update({
                        'out': FieldValue.serverTimestamp(),
                        'outName': name,
                        'outLocation': location,
                        'movedLocation': '$movedLocation',
                        'wigetName': wigetName,
                        'enterName': enterName,
                        'etc': etc,
                      });
                    } catch (e) {
                      print(e);
                      print('데이터가 존재하지 않아 업데이트 할게 없습니다');
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
                    '자가출차',
                    style: TextStyle(
                      fontSize: 18, // 텍스트 크기 증가
                      fontWeight: FontWeight.bold, // 텍스트를 굵게
                      color: Colors.black87, // 텍스트 색상
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    backgroundColor: Colors.blue, // 버튼 색상
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // 버튼 둥글게
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      content: Container(
        width: MediaQuery.of(context).size.width.clamp(0, 300),
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
                          'name':
                              (name == null || name.isEmpty) ? widget.name : '',
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      '차량픽업',
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
                      backgroundColor: Colors.blue, // 버튼 색상
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
                          'color': (color == 3) ? 1 : 3,
                          'enterName': (color == 3) ? '' : '자가주차', //자가주차누르면 기입됨
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      '자가주차',
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
            Container(
              height: 130,
              decoration: BoxDecoration(
                color: Colors.white, // 배경 색상
                border: Border.all(
                  color: Colors.black54, // 테두리 색상
                  width: 4, // 테두리 두께
                ),
                borderRadius: BorderRadius.circular(8), // 둥근 테두리
              ),
              child: Column(
                children: [
                  Text(
                    '이동',
                    style: TextStyle(
                      fontSize: 15, // 텍스트 크기 증가
                      fontWeight: FontWeight.bold, // 텍스트를 굵게
                      color: Colors.black87, // 텍스트 색상
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            backgroundColor: Colors.white60, // 버튼 색상
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8), // 버튼 둥글게
                            ),
                          ),
                          onPressed: () async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection(FIELD)
                                  .doc(dataId)
                                  .update({
                                'location': 2,
                                'wigetName': widget.name, //이게 입차한사람임
                              });
                            } catch (e) {
                              print(e);
                            }
                            Navigator.pop(context);
                          },
                          child: Text(
                            'A존',
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
                            backgroundColor: Colors.white60, // 버튼 색상
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8), // 버튼 둥글게
                            ),
                          ),
                          onPressed: () async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection(FIELD)
                                  .doc(dataId)
                                  .update({
                                'location': 3,
                                'wigetName': widget.name, //이게 입차한사람임
                              });
                            } catch (e) {
                              print(e);
                            }
                            Navigator.pop(context);
                          },
                          child: Text(
                            'B존',
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
                            backgroundColor: Colors.white60, // 버튼 색상
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8), // 버튼 둥글게
                            ),
                          ),
                          onPressed: () async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection(FIELD)
                                  .doc(dataId)
                                  .update({
                                'location': 4,
                                'wigetName': widget.name,
                              });
                            } catch (e) {
                              print(e);
                            }
                            Navigator.pop(context);
                          },
                          child: Text(
                            'B2',
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
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            backgroundColor: Colors.white60, // 버튼 색상
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8), // 버튼 둥글게
                            ),
                          ),
                          onPressed: () async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection(FIELD)
                                  .doc(dataId)
                                  .update({
                                'location': 1,
                                'wigetName': widget.name,
                              });
                            } catch (e) {
                              print(e);
                            }
                            Navigator.pop(context);
                          },
                          child: Text(
                            '가벽',
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
                            backgroundColor: Colors.white60, // 버튼 색상
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8), // 버튼 둥글게
                            ),
                          ),
                          onPressed: () async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection(FIELD)
                                  .doc(dataId)
                                  .update({
                                'location': 5,
                                'wigetName': widget.name,
                              });
                            } catch (e) {
                              print(e);
                            }
                            Navigator.pop(context);
                          },
                          child: Text(
                            '외부',
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
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 60),
                      backgroundColor: Colors.blueGrey, // 버튼 색상
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // 버튼 둥글게
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(dialogContext); // ✅ bottomTwo 닫기
                      showBrandSelectDialog(rootContext);
                    },
                    child: Text(
                      '브랜드넣기',
                      style: TextStyle(
                        fontSize: 14, // 텍스트 크기 증가
                        fontWeight: FontWeight.bold, // 텍스트를 굵게
                        color: Colors.black87, // 텍스트 색상
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    backgroundColor: Colors.green, // 버튼 색상
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // 버튼 둥글게
                    ),
                  ),
                  onPressed: () async {
                    try {
                      await FirebaseFirestore.instance
                          .collection(FIELD)
                          .doc(dataId)
                          .update({
                        'color': 4,
                      });
                    } catch (e) {
                      print(e);
                    }
                    Navigator.pop(context);
                  },
                  child: Text(
                    '회차',
                    style: TextStyle(
                      fontSize: 14, // 텍스트 크기 증가
                      fontWeight: FontWeight.bold, // 텍스트를 굵게
                      color: Colors.black87, // 텍스트 색상
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // 버튼 둥글게
                      ),
                      textStyle:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
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
                                  width: MediaQuery.of(context).size.width,
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
                                                try {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection(CarListAdress)
                                                      .doc(dataId)
                                                      .update({
                                                    'etc': etc,
                                                  });
                                                } catch (e) {
                                                  print(e);
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.blueGrey,
                                                // 버튼 배경색
                                                foregroundColor: Colors.white,
                                                // 텍스트 색상
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10),
                                                // 버튼 높이 설정
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12), // 둥근 모서리
                                                ),
                                              ),
                                              child: Text(
                                                '등록',
                                                style: TextStyle(
                                                  fontSize: 18, // 텍스트 크기
                                                  fontWeight:
                                                      FontWeight.bold, // 텍스트 굵게
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.blueGrey,
                                                // 버튼 배경색
                                                foregroundColor: Colors.white,
                                                // 텍스트 색상
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10),
                                                // 버튼 높이 설정
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12), // 둥근 모서리
                                                ),
                                              ),
                                              child: Text(
                                                '취소',
                                                style: TextStyle(
                                                  fontSize: 18, // 텍스트 크기
                                                  fontWeight:
                                                      FontWeight.bold, // 텍스트 굵게
                                                ),
                                              ),
                                            ),
                                          ),
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
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    backgroundColor: Colors.brown, // 버튼 색상
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // 버튼 둥글게
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return bottomEtc(
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
                  child: Text(
                    '기타',
                    style: TextStyle(
                      fontSize: 14, // 텍스트 크기 증가
                      fontWeight: FontWeight.bold, // 텍스트를 굵게
                      color: Colors.black87, // 텍스트 색상
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
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
          ],
        ),
      ),
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
    String option1,
    int option2,
    int option3,
    int option4,
    String option5,
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
                  '하이패스: $option2원',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  '총킬로수: $option4 km',
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '차량번호: $carModelFrom',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  '주유잔량: $option3 km',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  '기타: $option5',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: 120,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        await FirebaseFirestore.instance
                            .collection(FIELD)
                            .doc(dataId)
                            .update({
                          'location': 11,
                          'name': '',
                          'option1': '',
                          'etc':'',

                        });
                      } catch (e) {
                        print('문서 삭제 오류: $e');
                      }

                      try {
                        await FirebaseFirestore.instance
                            .collection(Color5List)
                            .doc(option1) //field컬렉션에 저장된 컬러5에 저장할 문서 아이디
                            .update({
                          'out': FieldValue.serverTimestamp(),
                          'outName': name,
                          'outLocation': location,
                          'wigetName': wigetName,
                          'etc': etc,
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
                      Navigator.pop(context);
                    },
                    child: Text(
                      '시승종료',
                      style: TextStyle(
                        fontSize: 18, // 텍스트 크기 증가
                        fontWeight: FontWeight.bold, // 텍스트를 굵게
                        color: Colors.black87, // 텍스트 색상
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      backgroundColor: Colors.red, // 버튼 색상
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // 버튼 둥글게
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              etc,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4, // 👈 글자 간격
                color: Colors.black, // 텍스트 색상
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomEtc(
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 공간을 나누기 위해 사용
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '차량번호: $carNumber',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 5), // 간격을 더 좁혀서 일관된 디자인
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
                onPressed: () {
                  // try {
                  //   await FirebaseFirestore.instance
                  //       .collection(FIELD) // 컬렉션 이름을 지정하세요
                  //       .doc(dataId) // 삭제할 문서의 ID를 지정하세요
                  //       .delete();
                  //   print('문서 삭제 완료');
                  // } catch (e) {
                  //   print('문서 삭제 오류: $e');
                  // }
                  // Navigator.pop(context);
                  // try {
                  //   await FirebaseFirestore.instance
                  //       .collection(CarListAdress)
                  //       .doc(dataId)
                  //       .update({
                  //     'out': FieldValue.serverTimestamp(),
                  //     'outName': name,
                  //     'outLocation': location,
                  //     'movedLocation': '$movedLocation',
                  //     'wigetName': wigetName,
                  //     'movingTime': movingTime,
                  //     'etc': etc,
                  //   });
                  // } catch (e) {
                  //   print(e);
                  //   print('데이터가 존재하지 않아 업데이트 할게 없습니다');
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
                  '출차완료',
                  style: TextStyle(
                    fontSize: 18, // 텍스트 크기 증가
                    fontWeight: FontWeight.bold, // 텍스트를 굵게
                    color: Colors.black87, // 텍스트 색상
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  backgroundColor: Colors.red, // 버튼 색상
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // 버튼 둥글게
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      content: Container(
        width: MediaQuery.of(context).size.width.clamp(0, 290),
        height: 260,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      backgroundColor: Colors.blue, // 버튼 색상
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // 버튼 둥글게
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(context); // 첫 번째 Dialog 닫기

                      if (carModelFrom == null || carModelFrom.trim().isEmpty) {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              titlePadding:
                                  const EdgeInsets.fromLTRB(24, 24, 24, 8),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(24, 0, 24, 16),
                              actionsPadding:
                                  const EdgeInsets.only(right: 12, bottom: 12),
                              title: Row(
                                children: [
                                  Icon(Icons.warning_amber_rounded,
                                      color: Colors.orange, size: 28),
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
                                '차종을 넣어주세요.',
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
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
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

                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ElectricButtonDialog(
                            carNumber: carNumber,
                            name: name,
                            color: color,
                            location: location,
                            dateTime: dateTime,
                            dataId: dataId,
                            etc: etc,
                            remainTime: remainTime,
                            movedLocation: movedLocation,
                            wigetName: wigetName,
                            movingTime: movingTime,
                            getMovingTime: getMovingTime,
                            carModelFrom: carModelFrom,
                          );
                        },
                      );
                    },
                    child: Text(
                      '전기차 등록',
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
                      try {
                        await FirebaseFirestore.instance
                            .collection(FIELD)
                            .doc(dataId)
                            .update({
                          'location': 0,
                        });
                      } catch (e) {
                        print(e);
                      }
                      Navigator.pop(context);
                    },
                    child: Text(
                      '입차대기로이동',
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
                      try {
                        await FirebaseFirestore.instance
                            .collection(FIELD)
                            .doc(dataId)
                            .update({
                          'etc': '',
                        });
                      } catch (e) {
                        print(e);
                      }
                      Navigator.pop(context);
                    },
                    child: Text(
                      '특이사항삭제',
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
                      try {
                        await FirebaseFirestore.instance
                            .collection(FIELD)
                            .doc(dataId)
                            .update({
                          'color': 1,
                        });
                      } catch (e) {
                        print(e);
                      }
                      Navigator.pop(context);
                    },
                    child: Text(
                      '출차취소',
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
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      '돌아가기',
                      style: TextStyle(
                        fontSize: 17, // 텍스트 크기 증가
                        fontWeight: FontWeight.bold, // 텍스트를 굵게
                        color: Colors.black, // 텍스트 색상
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showBrandSelectDialog(BuildContext rootContext) {
    showDialog(
      context: rootContext,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            String? selectedBrand;

            // 탭 인덱스에 따른 브랜드 맵 선택
            Map<String, List<String>> getSelectedBrandMap() {
              if (selectedTabIndex == 0) return widget.domesticBrands;
              if (selectedTabIndex == 1) return widget.importedFamousBrands;
              return widget.otherBrands;
            }

            return AlertDialog(
              title: const Text(
                '브랜드를 선택하세요',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width.clamp(0, 290),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// 🔘 탭 버튼
                    ToggleButtons(
                      isSelected: [
                        selectedTabIndex == 0,
                        selectedTabIndex == 1,
                        selectedTabIndex == 2,
                      ],
                      onPressed: (index) {
                        setState(() {
                          selectedTabIndex = index;
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      selectedColor: Colors.white,
                      fillColor: Colors.blue,
                      color: Colors.black,
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Text('국산'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Text('수입'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Text('기타'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    /// 🚗 브랜드 그리드
                    Container(
                      height: 350,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        padding: const EdgeInsets.all(8),
                        childAspectRatio: 1,
                        children:
                            getSelectedBrandMap().keys.map<Widget>((brand) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(6),
                              onTap: () {
                                Navigator.pop(dialogContext); // ✅ 브랜드 다이얼로그 닫기

                                Future.microtask(() {
                                  showDialog(
                                    context: rootContext, // ✅ 화면 context
                                    builder: (BuildContext carDialogContext) {
                                      return carModel(
                                        rootContext,
                                        carDialogContext, // ✅ 전달
                                        brand,
                                        getSelectedBrandMap(),
                                      );
                                    },
                                  );
                                });
                              },
                              child: Center(
                                child: Text(
                                  brand,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('닫기'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget carModel(
    BuildContext rootContext,
    BuildContext carDialogContext, // ✅ 추가
    String brand,
    Map<String, List<String>> brandModels,
  ) {
    return AlertDialog(
      title: Center(
        child: Text(
          brand,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      content: Container(
        height: 360,
        width: MediaQuery.of(rootContext).size.width.clamp(0, 290),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(10),
        ),
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          padding: const EdgeInsets.all(8),
          childAspectRatio: 1,
          children: brandModels[brand]!.map<Widget>((model) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () async {
                  Navigator.pop(carDialogContext); // ✅ carModel 닫기

                  try {
                    await FirebaseFirestore.instance
                        .collection(FIELD)
                        .doc(dataId)
                        .update({
                      'carBrand': brand,
                      'carModel': model,
                    });
                  } catch (e) {
                    print('업데이트 에러: $e');
                  }

                  try {
                    await FirebaseFirestore.instance
                        .collection((color == 5 ? Color5List : CarListAdress))
                        .doc(dataId)
                        .update({
                      'carBrand': brand,
                      'carModel': model,
                    });
                  } catch (e) {
                    print('업데이트 에러: $e');
                  }
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      model,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// 🔙 뒤로 → 브랜드 선택 다시 열기
            TextButton.icon(
              onPressed: () {
                Navigator.pop(carDialogContext); // 차종 닫기
                showBrandSelectDialog(rootContext); // 브랜드 다시 열기
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('뒤로'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(carDialogContext),
              child: const Text('닫기'),
            ),
          ],
        ),
      ],
    );
  }
}
