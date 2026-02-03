import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/2car_management_system/team2/team2-2/team2_3_standbycard.dart';
import 'package:team_husky/2car_management_system/team2/team2-2/team2_4_3_repository.dart';

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
  final repo = StateRepository();
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

  late TextEditingController etcController;

  String option1 = ''; //컬러5에 들어갈 문서 필드에서 뽑아낸문서
  int option2 = 0; //하이패스잔액
  int option3 = 0; // 주유잔량
  int option4 = 0; //총킬로수
  String option5 = ''; //시승차 기타
  String option6 = ''; //최근 3종 변경자 이름
  int option7 = 0; //시승차 타입 (고객= 0 시승차 60= 1 70=2 80=3 90=4
  //아래아직없음
  String option8 = '';
  String option9 = '';
  String option10 = '';
  String option11 = '';
  String option12 = '';

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
                print(dataId);
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

                option1 = displayList[index]['option1']; //시승차 컬러5에 넣는 문서주소
                option2 =
                    int.tryParse(displayList[index]['option2'].toString()) ??
                        0; //하이패스 잔액
                option3 =
                    int.tryParse(displayList[index]['option3'].toString()) ??
                        0; //주유잔량
                option4 =
                    int.tryParse(displayList[index]['option4'].toString()) ??
                        0; //총킬로수
                option5 = displayList[index]['option5']; //시승차 기타
                option6 = displayList[index]['option6']; //3종 최근변경자 이름
                option7 = displayList[index]
                    ['option7']; //시승차 타입 (고객= 0 시승차 60= 1 70=2 80=3 90=4
                option8 = displayList[index]['option8']; //시승차 A-1 A-2 C D
                option9 = displayList[index]['option9']; //시승예약고객 성함

                //아래없음
                option10 = displayList[index]['option10']; //시승차 예비용
                option11 = displayList[index]['option11']; //시승차 예비용
                option12 = displayList[index]['option12']; //시승차 예비용

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
                      option1,
                      option2,
                      //하이패스
                      option3,
                      //주유
                      option4,
                      //총킬로수
                      option5,
                      //기타
                      option6,
                      //3대 변경자
                      option9, //시승예약고객 성함
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
                option9: displayList[index]['option9'],
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
    String option1,
    int option2, //하이패스
    int option3, //주유잔량
    int option4, //총킬로수
    String option5, //기타
    String option6, //3대변경자
    String option9, //3대변경자
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
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  '차량번호: $carNumber',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  '상태: $option5 $option8',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  '',
                  style: TextStyle(
                    fontSize: 13,
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
                  '주유잔량: ${formatKm(option3)}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  '하이패스: ${formatWon(option2)}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  '총킬로수: ${formatKm(option4)}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  '예약자:    $option9',
                  style: TextStyle(
                    fontSize: 13,
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
        width: MediaQuery.of(context).size.width.clamp(0, 290),
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                          'option1': '', //필드에 옵션1은 컬러5에 들어갈 문서 ID임
                          'option5': '', //시승상태  기본 비대면 등등
                          'option8': '', //C D A-1
                          'option9': '', //예약자성함
                        });
                      } catch (e) {
                        print(e);
                      }
                      Navigator.pop(context);
                      try {
                        await FirebaseFirestore.instance
                            .collection(Color5List)
                            .doc(option1)
                            .delete();
                      } catch (e) {
                        print('데이터가 존재하지 않습니다');
                      }
                      await repo.createData(
                        dataId: dataId,
                        state: '시승취소(B1)',
                        wayToDrive: option5,
                        totalKmBefore: option4,
                        leftGasBefore: option3,
                        hiPassBefore: option2,
                        wayToDrive2: '시승취소',
                      );
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      backgroundColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
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
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      padding: const EdgeInsets.symmetric(
                        vertical: 15, // ⬅ 두께(높이) 증가
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
                      String tempEtc = option9 ?? '';

                      showDialog(
                        context: context,
                        builder: (dialogContext) {
                          return AlertDialog(
                            title: const Text('고객성함'),
                            content: SizedBox(
                              width: MediaQuery.of(dialogContext)
                                  .size
                                  .width
                                  .clamp(0, 290),
                              child: TextFormField(
                                initialValue: tempEtc,
                                maxLength: 4,
                                decoration: const InputDecoration(
                                  hintText: '고객성함 입력',
                                  counterText: '',
                                ),
                                onChanged: (value) {
                                  tempEtc = value;
                                },
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('취소'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  final String newEtc = tempEtc.trim();

                                  try {
                                    await FirebaseFirestore.instance
                                        .collection(FIELD)
                                        .doc(dataId)
                                        .update({
                                      'option9': newEtc,
                                    });

                                    setState(() {
                                      etc = newEtc;
                                    });

                                    Navigator.pop(dialogContext);
                                  } catch (e) {
                                    print(e);
                                  }
                                  Navigator.pop(context);
                                },
                                child: const Text('등록'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      '고객이름넣기',
                      style: TextStyle(
                        fontSize: 13, // 텍스트 크기 증가
                        fontWeight: FontWeight.bold, // 텍스트를 굵게
                        color: Colors.black, // 텍스트 색상
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
                        vertical: 20, // ⬅ 두께(높이) 증가
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
                                        maxLength: 13,
                                        decoration: InputDecoration(
                                          hintText: '특이사항 13자까지가능',
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
            SizedBox(
              height: 5,
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
}
