import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/2car_management_system/team2/team2-2/team2_4_1_stateList.dart';
import 'package:team_husky/2car_management_system/team2/team2-2/team2_4_3_repository.dart';
import 'package:team_husky/2car_management_system/team2/team2_adress_const.dart';
import 'package:team_husky/2car_management_system/team2/team2-1/team2_numbercard.dart';
import 'package:team_husky/2car_management_system/team2/team2-2/team2_3_standbycard.dart';

class B1B2Outside extends StatefulWidget {
  final String name;
  final int location;

  const B1B2Outside({
    super.key,
    required this.name,
    required this.location,
  });

  @override
  State<B1B2Outside> createState() => _B1B2OutsideStateState();
}

class _B1B2OutsideStateState extends State<B1B2Outside> {
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

  String option1 = ''; //컬러5에 들어갈 문서 필드에서 뽑아낸문서
  int option2 = 0; //하이패스잔액
  int option3 = 0; // 주유잔량
  int option4 = 0; //총킬로수
  String option5 = ''; //시승차상태 기본시승 비교시승 비대면 기타 등등
  String option6 = ''; //최근 3종 변경자 이름
  int option7 = 0; //시승차 타입 (고객= 0 시승차 60= 1 70=2 80=3 90=4
  String option8 = '';      //A-1,A-2,C,D 시승상태
  //아래는 없음

  String option9 = '';
  String option10 = '';
  String option11 = '';
  String option12 = '';

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
          return docLocation == widget.location;
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
                option5 = displayList[index]['option5'];//시승차 기타
                option6 = displayList[index]['option6']; //3종 최근변경자 이름
                option7 = displayList[index]['option7']; //시승차 타입 (고객= 0 시승차 60= 1 70=2 80=3 90=4
                option8 = displayList[index]['option8']; //A-1,A-2,C,D 시승상태


                option9 = displayList[index]['option9']; //시승차 예비용
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
                      option2, //하이패스
                      option3, //주유
                      option4, //총킬로수
                      option5, //기본시승 비대면시승
                      option6, //3대 변경자
                      option8, //3대 변경자
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
    String option1,
    int option2, //하이패스
    int option3, //주유잔량
    int option4, //총킬로수
    String option5, //기타
    String option6, //3대변경자
    String option8, //3대변경자
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
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '주유잔량: ${option3}km',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  '하이패스: $option2원',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  '총킬로수: ${option4}km',
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
        height: 380,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final nowLocation = getLocationName(location); //시승차 위치파악함수
                      Color5List = COLOR5 + formatTodayDate();
                      String documentId = FirebaseFirestore.instance
                          .collection(Color5List)
                          .doc()
                          .id;
                      try {
                        await FirebaseFirestore.instance
                            .collection(FIELD)
                            .doc(dataId)
                            .update({
                          'location': 0,
                          'option1': documentId,
                          //시승 출발시 시승차 리스트에 문서아이디가 필요하나 필드아이디와 동일시키는게 가장좋은 방법이나
                          // 추가로 시승이 나가면 앞서 나간 시승리스트에 같은 문서아이디에 모든 데이터를 덮어버리는 부분으로
                          // 새로운 문서아이디를 발급받아 진행시키려했더니 고객차량관리 창에서 해당 문서아이디를 못찾아
                          // 결국DB에 저장하는방법 선택
                        });
                      } catch (e) {
                        print(e);
                      }
                      Navigator.pop(context);

                      try {
                        await FirebaseFirestore.instance
                            .collection(Color5List)
                            .doc(documentId)
                            .set({
                          'carNumber': carNumber,
                          'enterName': widget.name,
                          //자가주차하면 여기에 자가라고 들어가게함/시승차는 자기이름들어감
                          'enter': FieldValue.serverTimestamp(),
                          'out': '',
                          'outName': '',
                          'outLocation': 10,
                          'etc': etc,
                          'movedLocation': '',
                          'wigetName': '',
                          'movingTime': FieldValue.serverTimestamp(),
                          'carBrand': '제네시스',
                          'carModel': carModelFrom,
                          'totalKm': option4,
                          'leftGas': option3,
                          'hiPass': option2,
                          'totalKmAfter': '',
                          'leftGasAfter': '',
                          'hiPassAfter': '',
                          'option1': '',    //최종 3개 (하이패스 잔량 총거리 변경자)
                          'option5': option5,     //현재 시승상태 대면 비대면 현장
                          'option8':option8,        // 시승상태 A-1 A-2 C D

                          //아래는 아직없음
                          'option2':'',
                          'option3': '',
                          'option4': '',
                          'option6': '',
                          'option7': '',
                          'option9': '',
                          'option10': '',





                        });
                      } catch (e) {}


                      await repo.createData(
                        dataId: dataId,
                        state: '$nowLocation > 스탠바이',
                        wayToDrive: name,
                      );
                    },
                    child: Text(
                      '스탠바이',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      backgroundColor: Colors.purple,
                      elevation: 4, // 살짝 입체감
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                          width: 2, // 👈 테두리 두께
                          color: Colors.purple,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 3,
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
                            .update(
                          name.isEmpty
                              ? {
                            'name': '기본',
                            'option5': '기본시승',  //시승상태 기본 비교 비대면
                            'option8': 'A-1',   //A-1 A-2 C D
                          }
                              : {
                            'name': '',
                            'option5': '',
                            'option8': '',
                          },
                        );

                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      '기본(A-1)',
                      style: TextStyle(
                        fontSize: 10, // 텍스트 크기 증가
                        fontWeight: FontWeight.w400, // 텍스트를 굵게
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
                            .update(
                          name.isEmpty
                              ? {
                            'name': '비교',
                            'option5': '비교시승',  //시승상태 기본 비교 비대면
                            'option8': 'A-1',   //A-1 A-2 C D
                          }
                              : {
                            'name': '',
                            'option5': '',
                            'option8': '',
                          },
                        );
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      '비교',
                      style: TextStyle(
                        fontSize: 13, // 텍스트 크기 증가
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
                            .update(
                          name.isEmpty
                              ? {
                            'name': '비대',
                            'option5': '비대면시승',  //시승상태 기본 비교 비대면
                            'option8': 'A-1',   //A-1 A-2 C D
                          }
                              : {
                            'name': '',
                            'option5': '',
                            'option8': '',
                          },
                        );
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      '비대면',
                      style: TextStyle(
                        fontSize: 13, // 텍스트 크기 증가
                        fontWeight: FontWeight.bold, // 텍스트를 굵게
                        color: Colors.black87, // 텍스트 색상
                      ),
                    ),
                  ),
                ),

              ],
            ),        //대면비대면
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
                            .update(
                          name.isEmpty
                              ? {
                            'name': '현장',
                            'option5': '현장시승',  //시승상태 기본 비교 비대면
                            'option8': 'A-2',   //A-1 A-2 C D
                          }
                              : {
                            'name': '',
                            'option5': '',
                            'option8': '',
                          },
                        );
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      '현장시승',
                      style: TextStyle(
                        fontSize: 14, // 텍스트 크기 증가
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
                            .update(
                          name.isEmpty
                              ? {
                            'name': '현비',
                            'option5': '현장비대면',  //시승상태 기본 비교 비대면
                            'option8': 'A-2',   //A-1 A-2 C D
                          }
                              : {
                            'name': '',
                            'option5': '',
                            'option8': '',
                          },
                        );
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      '현장비대면',
                      style: TextStyle(
                        fontSize: 14, // 텍스트 크기 증가
                        fontWeight: FontWeight.bold, // 텍스트를 굵게
                        color: Colors.black87, // 텍스트 색상
                      ),
                    ),
                  ),
                ),

              ],
            ),      //현장
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
                            .update(
                          name.isEmpty
                              ? {
                            'name': '교육',
                            'option5': '교육',  //시승상태 기본 비교 비대면
                            'option8': 'C',   //A-1 A-2 C D
                          }
                              : {
                            'name': '',
                            'option5': '',
                            'option8': '',
                          },
                        );
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      '교육',
                      style: TextStyle(
                        fontSize: 11, // 텍스트 크기 증가
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
                            .update(
                          name.isEmpty
                              ? {
                            'name': '답사',
                            'option5': '답사',  //시승상태 기본 비교 비대면
                            'option8': 'C',   //A-1 A-2 C D
                          }
                              : {
                            'name': '',
                            'option5': '',
                            'option8': '',
                          },
                        );
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      '답사',
                      style: TextStyle(
                        fontSize: 11, // 텍스트 크기 증가
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
                            .update(
                          name.isEmpty
                              ? {
                            'name': '주유',
                            'option5': '주유이동',  //시승상태 기본 비교 비대면
                            'option8': 'C',   //A-1 A-2 C D
                          }
                              : {
                            'name': '',
                            'option5': '',
                            'option8': '',
                          },
                        );
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      '주유',
                      style: TextStyle(
                        fontSize: 11, // 텍스트 크기 증가
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
                            .update(
                          name.isEmpty
                              ? {
                            'name': '컬러',
                            'option5': '컬러확인',  //시승상태 기본 비교 비대면
                            'option8': 'C',   //A-1 A-2 C D
                          }
                              : {
                            'name': '',
                            'option5': '',
                            'option8': '',
                          },
                        );
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      '컬러',
                      style: TextStyle(
                        fontSize: 11, // 텍스트 크기 증가
                        fontWeight: FontWeight.bold, // 텍스트를 굵게
                        color: Colors.black87, // 텍스트 색상
                      ),
                    ),
                  ),
                ),
              ],
            ),        //교육답사주유컬러
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
                            .update(
                          name.isEmpty
                              ? {
                            'name': '장기',
                            'option5': '장기시승',  //시승상태 기본 비교 비대면
                            'option8': 'C',   //A-1 A-2 C D
                          }
                              : {
                            'name': '',
                            'option5': '',
                            'option8': '',
                          },
                        );
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      '장기',
                      style: TextStyle(
                        fontSize: 11, // 텍스트 크기 증가
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
                            .update(
                          name.isEmpty
                              ? {
                            'name': '지원',
                            'option5': '외부지원',  //시승상태 기본 비교 비대면
                            'option8': 'C',   //A-1 A-2 C D
                          }
                              : {
                            'name': '',
                            'option5': '',
                            'option8': '',
                          },
                        );
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      '지원',
                      style: TextStyle(
                        fontSize: 11, // 텍스트 크기 증가
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
                            .update(
                          name.isEmpty
                              ? {
                            'name': '수리',
                            'option5': '차량수리',  //시승상태 기본 비교 비대면
                            'option8': 'C',   //A-1 A-2 C D
                          }
                              : {
                            'name': '',
                            'option5': '',
                            'option8': '',
                          },
                        );
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      '수리',
                      style: TextStyle(
                        fontSize: 11, // 텍스트 크기 증가
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
                            .update(
                          name.isEmpty
                              ? {
                            'name': '인도',
                            'option5': '인도픽업',  //시승상태 기본 비교 비대면
                            'option8': 'D',   //A-1 A-2 C D
                          }
                              : {
                            'name': '',
                            'option5': '',
                            'option8': '',
                          },
                        );
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      '인도',
                      style: TextStyle(
                        fontSize: 11, // 텍스트 크기 증가
                        fontWeight: FontWeight.bold, // 텍스트를 굵게
                        color: Colors.black87, // 텍스트 색상
                      ),
                    ),
                  ),
                ),
              ],
            ),        //상태리스트이동
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      backgroundColor: Colors.blueAccent, // 버튼 색상
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // 버튼 둥글게
                      ),
                    ),
                    onPressed: () async {
                     final nowLocation = getLocationName(location);
                      Navigator.pop(context);
                      try {
                        await FirebaseFirestore.instance
                            .collection(FIELD)
                            .doc(dataId)
                            .update({
                          'location': 11,
                        });
                      } catch (e) {
                        print(e);
                      }
                      await repo.createData(
                        dataId: dataId,
                        state: '$nowLocation -> B1',
                        wayToDrive: name,

                      );
                    },
                    child: Text(
                      'B1',
                      style: TextStyle(
                        fontSize: 13, // 텍스트 크기 증가
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
                      backgroundColor: Colors.blueAccent, // 버튼 색상
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // 버튼 둥글게
                      ),
                    ),
                    onPressed: () async {
                      final nowLocation = getLocationName(location);

                      try {
                        await FirebaseFirestore.instance
                            .collection(FIELD)
                            .doc(dataId)
                            .update({
                          'location': 12,
                        });
                      } catch (e) {
                        print(e);
                      }
                      Navigator.pop(context);


                      await repo.createData(
                        dataId: dataId,
                        state: '$nowLocation -> B2',
                        wayToDrive: name,

                      );

                    },
                    child: Text(
                      'B2',
                      style: TextStyle(
                        fontSize: 13, // 텍스트 크기 증가
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
                      backgroundColor: Colors.blueAccent, // 버튼 색상
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // 버튼 둥글게
                      ),
                    ),
                    onPressed: () async {
                      final nowLocation = getLocationName(location);


                      try {
                        await FirebaseFirestore.instance
                            .collection(FIELD)
                            .doc(dataId)
                            .update({
                          'location': 13,
                        });
                      } catch (e) {
                        print(e);
                      }
                      Navigator.pop(context);

                      await repo.createData(
                        dataId: dataId,
                        state: '$nowLocation -> 외부주차장',
                        wayToDrive: name,


                      );

                    },
                    child: Text(
                      '외부로',
                      style: TextStyle(
                        fontSize: 13, // 텍스트 크기 증가
                        fontWeight: FontWeight.bold, // 텍스트를 굵게
                        color: Colors.black87, // 텍스트 색상
                      ),
                    ),
                  ),
                ),
              ],
            ),      //이동

            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10, // ⬅ 두께(높이) 증가
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
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10, // ⬅ 두께(높이) 증가
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600, // 글자도 살짝 더 굵게
                        fontSize: 17,
                      ),
                    ),
                    onPressed: ()  {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StateList(dataId: dataId,),),
                      );
                    },
                    child: Text(
                      '상태',
                      style: TextStyle(
                        fontSize: 15, // 텍스트 크기 증가
                        fontWeight: FontWeight.bold, // 텍스트를 굵게
                        color: Colors.grey
                      ),
                    ),
                  ),
                ),
              ],
            ),         //특이사항
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
