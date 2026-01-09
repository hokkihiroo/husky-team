import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/2car_management_system/team4/team4_adress.dart';
import 'package:team_husky/2car_management_system/team4/team4_electric_selector.dart';
import 'package:team_husky/2car_management_system/team4/team4_numbercard.dart';

class Team4IpchaView extends StatefulWidget {
  final String name;
  final int location;

  final Map<String, List<String>> domesticBrands;
  final Map<String, List<String>> importedFamousBrands;
  final Map<String, List<String>> otherBrands;

  final List<Map<String, dynamic>> memberList;

  const Team4IpchaView({
    super.key,
    required this.name,
    required this.location,
    required this.domesticBrands,
    required this.importedFamousBrands,
    required this.otherBrands,
    required this.memberList,
  });

  @override
  State<Team4IpchaView> createState() => _Team4IpchaViewState();
}

class _Team4IpchaViewState extends State<Team4IpchaView> {
  String dataId = ''; //차번호 클릭시 그 차번호에 고유 아이디값
  String carNumber = ''; // 차번호 클릭시 차번호 추출
  int location = 0; //차번호 클릭시 그차번호 위치
  String dataAdress = ''; // 차번호 클릭시 나오는 위치 주소값
  int color = 1; //출차누르면 값이 2로 바뀌고 1이아닌색생은 노랑으로 표시
  DateTime dateTime = DateTime.now();
  String name = ''; //픽업 하는 사람 이름
  String etc = ''; // 특이사항
  String remainTime = ''; // 경과시간
  String CarListAdress = TEAM4CARLIST + Team4formatTodayDate();
  String movedLocation = ''; //과거 이동위치
  String wigetName = ''; //추가할 이름들 뽑음
  String enterName = ''; //자가주차 내역
  String movingTime = ''; //이동할 시각들 뽑음
  String carModelFrom = ''; // 눌럿을때 파베에서 차종뽑아서 전연변수에 넣은 값
  int selectedTabIndex = 0; // 이건 브랜드 선택시 탭 번호 0이 국산1이 수입 2가 기타

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
          .collection(TEAM4FIELD)
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

        // location이 위젯의 위치값이랑 같은 항목만 필터링
        final filteredDocs =
            docs.where((doc) => doc['location'] == widget.location).toList();

        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5, // 가로 아이템 개수
            crossAxisSpacing: 10.0, // 가로 간격
            mainAxisSpacing: 18.0, // 세로 간격
            childAspectRatio: 1.4, // 아이템의 가로세로 비율
          ),
          itemCount: filteredDocs.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                //  활성화 시키면 bar 가 바뀜 데이터 클릭시마다
                CarListAdress = TEAM4CARLIST + Team4formatTodayDate();
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
                movingTime = filteredDocs[index]['movingTime'];
                Timestamp createdAt = filteredDocs[index]['createdAt'];
                dateTime = createdAt.toDate();
                remainTime = getRemainTime(dateTime);
                //     dataAdress = CheckLocation(location); //파이어베이스 데이터주소

                String getMovingTime = getTodayTime();
                final BuildContext rootContext = context;
                showDialog(
                  context: rootContext,
                  builder: (BuildContext context) {
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
                  },
                );
              },
              child: Team4NumberCard(
                carNumber: filteredDocs[index]['carNumber'],
                name: filteredDocs[index]['name'],
                color: filteredDocs[index]['color'],
                etc: filteredDocs[index]['etc'],
                carBrand: filteredDocs[index]['carBrand'],
                carModel: filteredDocs[index]['carModel'],
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
      BuildContext rootContext,   // 화면 context (show용)
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
                          .collection(TEAM4FIELD)
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
                          .collection(TEAM4FIELD) // 컬렉션 이름을 지정하세요
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
                        'etc': '$etc',
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
        width: MediaQuery.of(context).size.width.clamp(0, 290),
        height: 320,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 60,
                        vertical: 14,
                      ),
                      backgroundColor: Colors.blueGrey, // 버튼 색상
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // 버튼 둥글게
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(dialogContext); // ✅ bottomTwo 닫기
                      showBrandSelectDialog(rootContext);
                    },

                    child: Text(
                      '브랜드넣기',
                      style: TextStyle(
                        fontSize: 20, // 텍스트 크기 증가
                        fontWeight: FontWeight.bold, // 텍스트를 굵게
                        color: Colors.black87, // 텍스트 색상
                      ),
                    ),
                  ),
                ),
              ],
            ), // 브랜드 넣기 메뉴
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      backgroundColor: Colors.grey, // 버튼 색상
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // 버튼 둥글게
                      ),
                    ),
                    onPressed: () async {
                      try {
                        await FirebaseFirestore.instance
                            .collection(TEAM4FIELD)
                            .doc(dataId)
                            .update({
                          'location': location == 0 ? 1 : 0,
                        });
                      } catch (e) {
                        print(e);
                      }

                      Navigator.pop(context);
                    },
                    child: Text(
                      location == 0 ? '본관으로' : '별관으로',
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      backgroundColor: Colors.blue, // 버튼 색상
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // 버튼 둥글게
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);

                      try {
                        await FirebaseFirestore.instance
                            .collection(TEAM4FIELD)
                            .doc(dataId)
                            .update({
                          'color': (color == 3) ? 1 : 3,
                          'enterName': (color == 3) ? '' : '자가주차',
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
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent, // 버튼 색상
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // 버튼 둥글게
                        ),
                      ),
                      onPressed: () async {
                        Navigator.pop(context); // 첫 번째 Dialog 닫기

                        if (carModelFrom == null ||
                            carModelFrom.trim().isEmpty) {
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
                                actionsPadding: const EdgeInsets.only(
                                    right: 12, bottom: 12),
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
                            return Team4ElectricSelector(
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
                        '전기차',
                        style: TextStyle(
                          fontSize: 20, // 텍스트 크기 증가
                          fontWeight: FontWeight.w600, // 텍스트를 굵게
                          color: Colors.black, // 텍스트 색상
                        ),
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
                      backgroundColor: Colors.green, // 버튼 색상
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // 버튼 둥글게
                      ),
                    ),
                    onPressed: () async {
                      try {
                        await FirebaseFirestore.instance
                            .collection(TEAM4FIELD)
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
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // 버튼 둥글게
                      ),
                      textStyle:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                    ),
                    onPressed: () async {
                      try {
                        await FirebaseFirestore.instance
                            .collection(TEAM4FIELD)
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
                      '지우기',
                      style: TextStyle(
                        fontSize: 13, // 텍스트 크기 증가
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
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 60,
                        vertical: 15,
                      ),
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
                                          etc = value; // ⭐ 기존 + 신규가 이미 합쳐진 값
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
                                                              TEAM4FIELD)
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
                                                          .collection(
                                                              CarListAdress)
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
            SizedBox(height: 5,),
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

                  await FirebaseFirestore.instance
                      .collection(TEAM4FIELD)
                      .doc(dataId)
                      .update({
                    'carBrand': brand,
                    'carModel': model,
                  });

                  await FirebaseFirestore.instance
                      .collection(CarListAdress)
                      .doc(dataId)
                      .update({
                    'carBrand': brand,
                    'carModel': model,
                  });



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
                        children: getSelectedBrandMap()
                            .keys
                            .map<Widget>((brand) {
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


  Widget memberListDialog(
    BuildContext dialogContext, // ✅ 이름 변경
    List<Map<String, dynamic>> members,
  ) {
    return AlertDialog(
      title: const Text(
        '직원 선택',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width.clamp(0, 290),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 350,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: members.isEmpty
                  ? const Center(child: Text('멤버가 없습니다'))
                  : Scrollbar(
                      child: GridView.count(
                        crossAxisCount: 3,
                        // ⭐ 3열
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        padding: const EdgeInsets.all(8),
                        childAspectRatio: 1.5,
                        // 가로:세로 비율 (이 값으로 카드 높이 조절)
                        children: members.map((member) {
                          return Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(6),
                              onTap: () async {
                                Navigator.of(dialogContext).pop();
                                try {
                                  await FirebaseFirestore.instance
                                      .collection(CarListAdress)
                                      .doc(dataId)
                                      .update({
                                    'wigetName': member['workerName'],
                                  });
                                } catch (e) {
                                  print('업데이트 에러: $e');
                                }

                                print('선택된 멤버: ${member['workerName']}');
                              },
                              child: Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  child: Text(
                                    member['workerName'] ?? '이름없음',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 14,
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
  }
}
