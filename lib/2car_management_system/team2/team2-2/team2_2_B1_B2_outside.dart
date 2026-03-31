import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String option8 = ''; //A-1,A-2,C,D 시승상태
  String option9 = ''; //시승예약 고객 성함
  //아래는 없음

  String option10 = '';
  String option11 = '';
  String option12 = '';

  late TextEditingController etcController;

  //주유잔량 하이패스 킬로미터 넣는함수 (아래)
  void showIntInputBottomSheet(
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
    BuildContext rootContext, // 화면 context (show용)
  ) {
    final TextEditingController fuelController = TextEditingController();
    final TextEditingController hipassController = TextEditingController();
    final TextEditingController totalKmController = TextEditingController();

    showModalBottomSheet(
      context: rootContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // 👈 카드 느낌
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 50,
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: MediaQuery.of(context).size.width.clamp(0, 290), // ⭐ 여기
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '차량 정보 입력',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _inputField(
                    controller: fuelController,
                    label: '주유 잔량 (숫자만)',
                    suffix: 'km',
                    maxLength: 4,
                  ),
                  const SizedBox(height: 12),
                  _inputField(
                    controller: hipassController,
                    label: '하이패스 (숫자만)',
                    suffix: '원',
                    maxLength: 6,
                  ),
                  const SizedBox(height: 12),
                  _inputField(
                    controller: totalKmController,
                    label: '총 킬로수 (숫자만)',
                    suffix: 'km',
                    maxLength: 6,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 48,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('취소'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            if (fuelController.text.isEmpty ||
                                hipassController.text.isEmpty ||
                                totalKmController.text.isEmpty) {
                              return;
                            }

                            final int fuel = int.parse(fuelController.text);
                            final int hiPass = int.parse(hipassController.text);
                            final int totalKm =
                                int.parse(totalKmController.text);

                            // 🔥 Firebase 저장
                            try {
                              await FirebaseFirestore.instance
                                  .collection(FIELD)
                                  .doc(dataId)
                                  .update({
                                'option2': hiPass, //하이패스
                                'option3': fuel, //기름잔량
                                'option4': totalKm, //총거리
                              });
                            } catch (e) {
                              print('문서 삭제 오류: $e');
                            }

                            try {
                              await repo.createData(
                                dataId: dataId,
                                state: '데이터가 변경됨',
                                wayToDrive: option5,
                                repairName: widget.name,
                                totalKmBefore: option4,
                                leftGasBefore: option3,
                                hiPassBefore: option2,
                                totalKmAfter: totalKm,
                                leftGasAfter: fuel,
                                hiPassAfter: hiPass,
                              );
                            } catch (e) {
                              print('문서 삭제 오류: $e');
                            }

                            Navigator.pop(sheetContext);

                            bottomColor5Final(
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
                                rootContext,
                                fuel,
                                hiPass,
                                totalKm);
                          },
                          child: const Text(
                            '저장',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.yellow),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void bottomColor5Final(
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
    String movingTime, //최신화된 3대 (하이패스 총킬로수 주유잔량) 최종적용 함수
    String getMovingTime,
    String carModelFrom,
    String option1,
    int option2,
    int option3,
    int option4,
    String option5,
    BuildContext rootContext, // 화면 context (show용)
    int fuel,
    int hiPass,
    int totalKm,
  ) {
    showDialog(
      context: rootContext,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            '변경 내용 확인',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '입력한 정보가 아래와 같이 반영되었습니다.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),

              // 헤더
              Row(
                children: [
                  SizedBox(
                      width: 70,
                      child: Text('메뉴',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(
                      child: Text('전',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(
                      child: Text('후',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
              SizedBox(height: 8),
              Divider(),

              // 주유 잔량
              Row(
                children: [
                  SizedBox(width: 70, child: Text('주유 잔량')),
                  Expanded(
                      child: Text('$option3', textAlign: TextAlign.center)),
                  Expanded(child: Text('$fuel', textAlign: TextAlign.center)),
                ],
              ),
              SizedBox(height: 8),

              // 하이패스
              Row(
                children: [
                  SizedBox(width: 70, child: Text('하이패스')),
                  Expanded(
                      child: Text('$option2', textAlign: TextAlign.center)),
                  Expanded(child: Text('$hiPass', textAlign: TextAlign.center)),
                ],
              ),
              SizedBox(height: 8),

              // 총 킬로수
              Row(
                children: [
                  SizedBox(width: 70, child: Text('총 킬로수')),
                  Expanded(
                      child: Text('$option4', textAlign: TextAlign.center)),
                  Expanded(
                      child: Text('$totalKm', textAlign: TextAlign.center)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  const SizedBox(width: 70, child: Text('변경한 사람')),
                  const Expanded(
                    child: SizedBox(), // ⭐ 빈 칸 유지
                  ),
                  Expanded(
                    child: Text(
                      widget.name,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text(
                    '확인',
                    style: TextStyle(
                      color: Colors.yellow,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _inputField({
    required TextEditingController controller, //이함수는 상잔 주유잔량 하이패스 킬로미터 내용그리는함수
    required String label,
    required int maxLength,
    String? suffix,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(maxLength),
      ],
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        // ⭐ 여기
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

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
                option5 = displayList[index]['option5']; //시승차 기타
                option6 = displayList[index]['option6']; //3종 최근변경자 이름
                option7 = displayList[index]
                    ['option7']; //시승차 타입 (고객= 0 시승차 60= 1 70=2 80=3 90=4
                option8 = displayList[index]['option8']; //A-1,A-2,C,D 시승상태
                option9 = displayList[index]['option9']; ////시승예약고객 성함

                //아래없음
                option10 = displayList[index]['option10']; //시승차 예비용
                option11 = displayList[index]['option11']; //시승차 예비용
                option12 = displayList[index]['option12']; //시승차 예비용

                showDialog(
                  context: rootContext,
                  builder: (BuildContext Color5Context) {
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
                      rootContext,
                      Color5Context,
                      option1,
                      option2,
                      //하이패스
                      option3,
                      //주유
                      option4,
                      //총킬로수
                      option5,
                      //기본시승 비대면시승
                      option6,
                      //3대 변경자
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
    BuildContext rootContext, // 메인화면 context (show용)
    BuildContext context, // 컬러5화면 context (show용)
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
                      final nowLocation =
                          getLocationName(location); //시승차 위치파악함수
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
                          'option1': '', //최종 3개 (하이패스 잔량 총거리 변경자)
                          'option5': option5, //현재 시승상태 대면 비대면 현장
                          'option8': option8, // 시승상태 A-1 A-2 C D

                          //아래는 아직없음
                          'option2': 0,
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
                          wayToDrive: option5,
                          totalKmBefore: option4,
                          leftGasBefore: option3,
                          hiPassBefore: option2,
                          prepareName: widget.name,
                        wayToDrive2: option8,);
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
                                      'option5': '기본시승', //시승상태 기본 비교 비대면
                                      'option8': 'A-1', //A-1 A-2 C D
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
                    child: Column(
                      children: [
                        Text(
                          '기본시승',
                          style: TextStyle(
                            fontSize: 11, // 텍스트 크기 증가
                            fontWeight: FontWeight.bold, // 텍스트를 굵게
                            color: Colors.black87, // 텍스트 색상
                          ),
                        ),
                        Text(
                          'A-1',
                          style: TextStyle(
                            fontSize: 11, // 텍스트 크기 증가
                            fontWeight: FontWeight.bold, // 텍스트를 굵게
                            color: Colors.black87, // 텍스트 색상
                          ),
                        ),
                      ],
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
                                      'option5': '비교시승', //시승상태 기본 비교 비대면
                                      'option8': 'A-1', //A-1 A-2 C D
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
                    child: Column(
                      children: [
                        Text(
                          '비교시승',
                          style: TextStyle(
                            fontSize: 11, // 텍스트 크기 증가
                            fontWeight: FontWeight.bold, // 텍스트를 굵게
                            color: Colors.black87, // 텍스트 색상
                          ),
                        ),
                        Text(
                          'A-1',
                          style: TextStyle(
                            fontSize: 11, // 텍스트 크기 증가
                            fontWeight: FontWeight.bold, // 텍스트를 굵게
                            color: Colors.black87, // 텍스트 색상
                          ),
                        ),
                      ],
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
                                      'option5': '비대면시승', //시승상태 기본 비교 비대면
                                      'option8': 'A-1', //A-1 A-2 C D
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
                    child: Column(
                      children: [
                        Text(
                          '비대면',
                          style: TextStyle(
                            fontSize: 11, // 텍스트 크기 증가
                            fontWeight: FontWeight.bold, // 텍스트를 굵게
                            color: Colors.black87, // 텍스트 색상
                          ),
                        ),
                        Text(
                          'A-1',
                          style: TextStyle(
                            fontSize: 11, // 텍스트 크기 증가
                            fontWeight: FontWeight.bold, // 텍스트를 굵게
                            color: Colors.black87, // 텍스트 색상
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ), //대면비대면
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
                                      'option5': '현장동승', //시승상태 기본 비교 비대면
                                      'option8': 'A-2', //A-1 A-2 C D
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
                    child: Column(
                      children: [
                        Text(
                          '현장동승',
                          style: TextStyle(
                            fontSize: 11, // 텍스트 크기 증가
                            fontWeight: FontWeight.bold, // 텍스트를 굵게
                            color: Colors.black87, // 텍스트 색상
                          ),
                        ),
                        Text(
                          'A-2',
                          style: TextStyle(
                            fontSize: 11, // 텍스트 크기 증가
                            fontWeight: FontWeight.bold, // 텍스트를 굵게
                            color: Colors.black87, // 텍스트 색상
                          ),
                        ),
                      ],
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
                                      'option5': '현장비동승', //시승상태 기본 비교 비대면
                                      'option8': 'A-2', //A-1 A-2 C D
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
                    child: Column(
                      children: [
                        Text(
                          '현비동승',
                          style: TextStyle(
                            fontSize: 11, // 텍스트 크기 증가
                            fontWeight: FontWeight.bold, // 텍스트를 굵게
                            color: Colors.black87, // 텍스트 색상
                          ),
                        ),
                        Text(
                          'A-2',
                          style: TextStyle(
                            fontSize: 11, // 텍스트 크기 증가
                            fontWeight: FontWeight.bold, // 텍스트를 굵게
                            color: Colors.black87, // 텍스트 색상
                          ),
                        ),
                      ],
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
                                      'option5': '현장비대면', //시승상태 기본 비교 비대면
                                      'option8': 'A-2', //A-1 A-2 C D
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
                    child: Column(
                      children: [
                        Text(
                          '현비대면',
                          style: TextStyle(
                            fontSize: 11, // 텍스트 크기 증가
                            fontWeight: FontWeight.bold, // 텍스트를 굵게
                            color: Colors.black87, // 텍스트 색상
                          ),
                        ),
                        Text(
                          'A-2',
                          style: TextStyle(
                            fontSize: 11, // 텍스트 크기 증가
                            fontWeight: FontWeight.bold, // 텍스트를 굵게
                            color: Colors.black87, // 텍스트 색상
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ), //현장
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
                                      'option5': '교육', //시승상태 기본 비교 비대면
                                      'option8': 'C', //A-1 A-2 C D
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
                      '교육 C',
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
                                      'option5': '답사', //시승상태 기본 비교 비대면
                                      'option8': 'C', //A-1 A-2 C D
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
                      '답사 C',
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
                                      'option5': '컬러확인', //시승상태 기본 비교 비대면
                                      'option8': 'C', //A-1 A-2 C D
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
                      '컬러 C',
                      style: TextStyle(
                        fontSize: 11, // 텍스트 크기 증가
                        fontWeight: FontWeight.bold, // 텍스트를 굵게
                        color: Colors.black87, // 텍스트 색상
                      ),
                    ),
                  ),
                ),
              ],
            ), //교육답사컬러
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
                                      'name': '주유',
                                      'option5': '주유', //시승상태 기본 비교 비대면
                                      'option8': 'C', //A-1 A-2 C D
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
                      '주유 C',
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
                                      'option5': '인도픽업', //시승상태 기본 비교 비대면
                                      'option8': 'D', //A-1 A-2 C D
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
                      '인도 D',
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
                      backgroundColor: Colors.brown,
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

                      showDialog(
                        context: rootContext,
                        builder: (bottomColor5EtcContext) => bottomColor5Etc(
                          bottomColor5EtcContext,
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
                          option6,
                          option8,
                        ),
                      );
                    },
                    child: Text(
                      '기타',
                      style: TextStyle(
                        fontSize: 13, // 텍스트 크기 증가
                        fontWeight: FontWeight.bold, // 텍스트를 굵게
                        color: Colors.grey, // 텍스트 색상
                      ),
                    ),
                  ),
                ),
              ],
            ), //상태리스트이동
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
                        wayToDrive: option5,
                        totalKmBefore: option4,
                        leftGasBefore: option3,
                        hiPassBefore: option2,
                        movedName:widget.name,
                        wayToDrive2: '이동',

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
                        wayToDrive: option5,
                        totalKmBefore: option4,
                        leftGasBefore: option3,
                        hiPassBefore: option2,
                        movedName:widget.name,
                        wayToDrive2: '이동',
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
                        wayToDrive: option5,
                        totalKmBefore: option4,
                        leftGasBefore: option3,
                        hiPassBefore: option2,
                        movedName:widget.name,
                        wayToDrive2: '이동',

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
            ), //이동

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
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
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
                      showIntInputBottomSheet(
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
                        rootContext,
                      ); // 2️⃣ 바텀시트 열기
                    },
                    child: Text(
                      '데이터수정',
                      style: TextStyle(
                          fontSize: 15, // 텍스트 크기 증가
                          fontWeight: FontWeight.bold, // 텍스트를 굵게
                          color: Colors.black),
                    ),
                  ),
                ),
              ],
            ), //특이사항
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

  Widget bottomColor5Etc(
    //기타 클릭시
    BuildContext bottomColor5EtcContext, // 컬러5Etc화면 context (show용)
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
    String option6,
    String option8,
  ) {
    return AlertDialog(
      title: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black54,
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
          Navigator.pop(bottomColor5EtcContext); //  다이얼로그 닫기
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StateList(
                dataId: dataId,
              ),
            ),
          );
        },
        child: Text(
          '차량 상태 리스트보기(클릭)',
          style: TextStyle(
            fontSize: 13, // 텍스트 크기 증가
            fontWeight: FontWeight.bold, // 텍스트를 굵게
            color: Colors.yellow, // 텍스트 색상
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                    Navigator.pop(bottomColor5EtcContext); //  다이얼로그 닫기

                    try {
                      await FirebaseFirestore.instance
                          .collection(FIELD)
                          .doc(dataId)
                          .update(
                            name.isEmpty
                                ? {
                                    'name': 'VP',
                                    'option5': 'VIP시승', //시승상태 기본 비교 비대면
                                    'option8': 'A-1', //A-1 A-2 C D
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
                  child: Column(
                    children: [
                      Text(
                        'VIP시승',
                        style: TextStyle(
                          fontSize: 11, // 텍스트 크기 증가
                          fontWeight: FontWeight.bold, // 텍스트를 굵게
                          color: Colors.black87, // 텍스트 색상
                        ),
                      ),
                      Text(
                        'A-1',
                        style: TextStyle(
                          fontSize: 11, // 텍스트 크기 증가
                          fontWeight: FontWeight.bold, // 텍스트를 굵게
                          color: Colors.black87, // 텍스트 색상
                        ),
                      ),
                    ],
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
                    Navigator.pop(bottomColor5EtcContext); //  다이얼로그 닫기

                    try {
                      await FirebaseFirestore.instance
                          .collection(FIELD)
                          .doc(dataId)
                          .update(
                            name.isEmpty
                                ? {
                                    'name': '인도',
                                    'option5': '찾아가는시승', //시승상태 기본 비교 비대면
                                    'option8': 'A-1', //A-1 A-2 C D
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
                  child: Column(
                    children: [
                      Text(
                        '찾아가는시승',
                        style: TextStyle(
                          fontSize: 11, // 텍스트 크기 증가
                          fontWeight: FontWeight.bold, // 텍스트를 굵게
                          color: Colors.black87, // 텍스트 색상
                        ),
                      ),
                      Text(
                        'A-1',
                        style: TextStyle(
                          fontSize: 11, // 텍스트 크기 증가
                          fontWeight: FontWeight.bold, // 텍스트를 굵게
                          color: Colors.black87, // 텍스트 색상
                        ),
                      ),
                    ],
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
                    Navigator.pop(bottomColor5EtcContext); //  다이얼로그 닫기

                    try {
                      await FirebaseFirestore.instance
                          .collection(FIELD)
                          .doc(dataId)
                          .update(
                            name.isEmpty
                                ? {
                                    'name': '오너',
                                    'option5': '오너스시승', //시승상태 기본 비교 비대면
                                    'option8': 'A-1', //A-1 A-2 C D
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
                  child: Column(
                    children: [
                      Text(
                        '오너스시승',
                        style: TextStyle(
                          fontSize: 11, // 텍스트 크기 증가
                          fontWeight: FontWeight.bold, // 텍스트를 굵게
                          color: Colors.black87, // 텍스트 색상
                        ),
                      ),
                      Text(
                        'A-1',
                        style: TextStyle(
                          fontSize: 11, // 텍스트 크기 증가
                          fontWeight: FontWeight.bold, // 텍스트를 굵게
                          color: Colors.black87, // 텍스트 색상
                        ),
                      ),
                    ],
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
                    Navigator.pop(bottomColor5EtcContext); //  다이얼로그 닫기

                    try {
                      await FirebaseFirestore.instance
                          .collection(FIELD)
                          .doc(dataId)
                          .update(
                            name.isEmpty
                                ? {
                                    'name': '시그',
                                    'option5': '시그니처시승', //시승상태 기본 비교 비대면
                                    'option8': 'A-1', //A-1 A-2 C D
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
                  child: Column(
                    children: [
                      Text(
                        '시그니처',
                        style: TextStyle(
                          fontSize: 11, // 텍스트 크기 증가
                          fontWeight: FontWeight.bold, // 텍스트를 굵게
                          color: Colors.black87, // 텍스트 색상
                        ),
                      ),
                      Text(
                        'A-1',
                        style: TextStyle(
                          fontSize: 11, // 텍스트 크기 증가
                          fontWeight: FontWeight.bold, // 텍스트를 굵게
                          color: Colors.black87, // 텍스트 색상
                        ),
                      ),
                    ],
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
                    Navigator.pop(bottomColor5EtcContext); //  다이얼로그 닫기

                    try {
                      await FirebaseFirestore.instance
                          .collection(FIELD)
                          .doc(dataId)
                          .update(
                            name.isEmpty
                                ? {
                                    'name': '오너',
                                    'option5': '오너스현장', //시승상태 기본 비교 비대면
                                    'option8': 'A-2', //A-1 A-2 C D
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
                  child: Column(
                    children: [
                      Text(
                        '오너스현장',
                        style: TextStyle(
                          fontSize: 11, // 텍스트 크기 증가
                          fontWeight: FontWeight.bold, // 텍스트를 굵게
                          color: Colors.black87, // 텍스트 색상
                        ),
                      ),
                      Text(
                        'A-2',
                        style: TextStyle(
                          fontSize: 11, // 텍스트 크기 증가
                          fontWeight: FontWeight.bold, // 텍스트를 굵게
                          color: Colors.black87, // 텍스트 색상
                        ),
                      ),
                    ],
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
                    Navigator.pop(bottomColor5EtcContext); //  다이얼로그 닫기

                    try {
                      await FirebaseFirestore.instance
                          .collection(FIELD)
                          .doc(dataId)
                          .update(
                            name.isEmpty
                                ? {
                                    'name': '수리',
                                    'option5': '시승차수리', //시승상태 기본 비교 비대면
                                    'option8': 'C', //A-1 A-2 C D
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
                    '수리 C',
                    style: TextStyle(
                      fontSize: 11, // 텍스트 크기 증가
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
                    Navigator.pop(bottomColor5EtcContext); //  다이얼로그 닫기

                    try {
                      await FirebaseFirestore.instance
                          .collection(FIELD)
                          .doc(dataId)
                          .update(
                            name.isEmpty
                                ? {
                                    'name': '장기',
                                    'option5': '장기시승', //시승상태 기본 비교 비대면
                                    'option8': 'C', //A-1 A-2 C D
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
                    '장기 C',
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
                    Navigator.pop(bottomColor5EtcContext); //  다이얼로그 닫기

                    try {
                      await FirebaseFirestore.instance
                          .collection(FIELD)
                          .doc(dataId)
                          .update(
                            name.isEmpty
                                ? {
                                    'name': '지원',
                                    'option5': '외부지원', //시승상태 기본 비교 비대면
                                    'option8': 'C', //A-1 A-2 C D
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
                    '지원 C',
                    style: TextStyle(
                      fontSize: 11, // 텍스트 크기 증가
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
    );
  }
}
