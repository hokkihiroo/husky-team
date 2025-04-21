import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/2car_management_system/team2/team2_adress_const.dart';
import 'package:team_husky/2car_management_system/team2/team2_numbercard.dart';

class Team2IpchaView extends StatefulWidget {
  final String name;

  const Team2IpchaView({
    super.key,
    required this.name,
  });

  @override
  State<Team2IpchaView> createState() => _Team2IpchaViewState();
}

class _Team2IpchaViewState extends State<Team2IpchaView> {
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
  String movedLocation = ''; //과거 이동위치
  String wigetName = ''; //추가할 이름들 뽑음
  String movingTime = ''; //이동할 시각들 뽑음
  String carModelFrom = ''; // 눌럿을때 파베에서 차종뽑아서 전연변수에 넣은 값
  int selectedTabIndex = 0;

  Map<String, List<String>> domesticBrands = {};
  Map<String, List<String>> importedFamousBrands = {};
  Map<String, List<String>> otherBrands = {};

  @override
  void initState() {
    super.initState();
    _loadBrandModels();
  }

  Future<void> _loadBrandModels() async {
    final result = await fetchBrandsWithModels();
    print('🔥 국내: $domesticBrands');
    print('🔥 수입유명: $importedFamousBrands');
    print('🔥 잡브랜드: $otherBrands');
  }

  Future<void> fetchBrandsWithModels() async {
    final brandCollection = FirebaseFirestore.instance.collection(BRANDMANAGE);
    final brandSnapshots = await brandCollection.get();

    for (var brandDoc in brandSnapshots.docs) {
      final category = brandDoc['category'] ?? '미지정'; // 브랜드명
      final brandType = brandDoc['brandType'] ?? 0;
      final brandId = brandDoc.id;

      final modelSnapshots = await brandCollection
          .doc(brandId)
          .collection('LIST')
          .orderBy('createdAt')
          .get();

      final models = modelSnapshots.docs
          .map((modelDoc) => modelDoc['carModel'] as String)
          .toList();

      // brandType 기준으로 분류
      if (brandType == 1) {
        domesticBrands[category] = models;
      } else if (brandType == 2) {
        importedFamousBrands[category] = models;
      } else if (brandType == 3) {
        otherBrands[category] = models;
      }
    }
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

        // location이 0인 항목만 필터링
        final filteredDocs = docs.where((doc) => doc['location'] == 0).toList();

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
          itemCount: filteredDocs.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                //  활성화 시키면 bar 가 바뀜 데이터 클릭시마다
                CarListAdress = CARLIST + formatTodayDate();
                var document = filteredDocs[index];
                dataId = document.id;
                name = filteredDocs[index]['name'];
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

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return bottomTwo(
                      carNumber,
                      name,
                      color,
                      location,
                      dateTime,
                      //  dataAdress,
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
              child: Team2NumberCard(
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
    //   String dataAdress,
    String dataId,
    String etc,
    String remainTime,
    String movedLocation,
    String wigetName,
    String movingTime,
    String getMovingTime,
    String carModelFrom,
  ) {
    print(name);
    return AlertDialog(
      title: Row(
        children: [
          Column(
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
          SizedBox(
            width: 20,
          ),
          Container(
            height: 60,
            width: 110,
            child: ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection(FIELD)
                      .doc(dataId)
                      .update({
                    'color': 2,
                  });
                } catch (e) {
                  print(e);
                }
                Navigator.pop(context);
              },
              child: Text(
                '출차하기',
                style: TextStyle(
                  fontSize: 18, // 텍스트 크기 증가
                  fontWeight: FontWeight.bold, // 텍스트를 굵게
                  color: Colors.black87, // 텍스트 색상
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20),
                primary: Colors.red, // 버튼 색상
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // 버튼 둥글게
                ),
              ),
            ),
          ),
        ],
      ),
      content: Container(
        width: MediaQuery.of(context).size.width,
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
                      primary: Colors.grey, // 버튼 색상
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
                      primary: Colors.blue, // 버튼 색상
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
                  color: Colors.grey, // 테두리 색상
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
                            primary: Colors.white, // 버튼 색상
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
                            primary: Colors.white, // 버튼 색상
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
                            primary: Colors.white, // 버튼 색상
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
                            primary: Colors.white, // 버튼 색상
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
                            primary: Colors.white, // 버튼 색상
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
                      primary: Colors.blueGrey, // 버튼 색상
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // 버튼 둥글게
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(context); // 기존 팝

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              String? selectedBrand;

                              // 탭 인덱스에 따른 맵 선택 함수
                              Map<String, List<String>> getSelectedBrandMap() {
                                if (selectedTabIndex == 0)
                                  return domesticBrands;
                                if (selectedTabIndex == 1)
                                  return importedFamousBrands;
                                return otherBrands;
                              }

                              return AlertDialog(
                                title: Text('브랜드를 선택하세요',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                content: SizedBox(
                                  width: double.maxFinite,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
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
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12),
                                            child: Text('국산'),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12),
                                            child: Text('수입'),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12),
                                            child: Text('기타'),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Container(
                                        height: 300,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Scrollbar(
                                          child: GridView.count(
                                            crossAxisCount: 3,
                                            // 한 줄에 3개
                                            crossAxisSpacing: 8,
                                            mainAxisSpacing: 8,
                                            shrinkWrap: true,
                                            childAspectRatio: 1,
                                            // 카드 비율 (가로:세로)
                                            children: getSelectedBrandMap()
                                                .keys
                                                .map((brand) {
                                              return Card(
                                                color: selectedBrand == brand
                                                    ? Colors.grey.shade200
                                                    : Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return carModel(brand,
                                                            getSelectedBrandMap());
                                                      },
                                                    );
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8),
                                                    child: Text(
                                                      brand,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 14),
                                                      textAlign:
                                                          TextAlign.center,
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [


                                      // 직접입력 버튼 (크고 예쁜 스타일)
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                          backgroundColor: Colors.black, // 검정 배경
                                          foregroundColor: Colors.yellow, // 노란 글씨
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          textStyle: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // 이전 다이얼로그 닫기

                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              TextEditingController
                                                  brandController =
                                                  TextEditingController();
                                              TextEditingController
                                                  modelController =
                                                  TextEditingController();

                                              return AlertDialog(
                                                title: Text(
                                                  '직접입력',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    TextField(
                                                      controller:
                                                          brandController,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: '브랜드',
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                    ),
                                                    SizedBox(height: 12),
                                                    TextField(
                                                      controller:
                                                          modelController,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: '차종',
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                    child: Text('취소'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      String brand =
                                                          brandController.text
                                                              .trim();
                                                      String model =
                                                          modelController.text
                                                              .trim();

                                                      try {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(FIELD)
                                                            .doc(dataId)
                                                            .update({
                                                          'carBrand': brand,
                                                          'carModel': model,
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
                                                          'carBrand': brand,
                                                          'carModel': model,
                                                        });
                                                      } catch (e) {
                                                        print(e);
                                                      }

                                                      Navigator.of(context)
                                                          .pop(); // 다이얼로그 닫기
                                                    },
                                                    child: Text('확인'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Text('직접입력'),
                                      ),
                                      // 닫기 버튼 (작고 기본 스타일)
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text('닫기'),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
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
                    primary: Colors.brown, // 버튼 색상
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
            Row(
              children: [
                Expanded(
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
                      child: Text('특이사항 입력')),
                ),
                // Expanded(
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       primary: Colors.black,
                //       textStyle:
                //       TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                //     ),
                //     onPressed: () async {
                //       Navigator.pop(context);
                //
                //       // try {
                //       //   await FirebaseFirestore.instance
                //       //       .collection(dataAdress)
                //       //       .doc(dataId)
                //       //       .update({
                //       //     'etc': '',
                //       //   });
                //       // } catch (e) {
                //       //   print(e);
                //       // }
                //     },
                //     child: Text('삭제'),
                //   ),
                // ),
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
  ) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 공간을 나누기 위해 사용
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '차량번호: $carNumber',
                style: TextStyle(
                  fontSize: 20,
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
          Container(
            height: 60,
            width: 120,
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
                    'movingTime': movingTime,
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
              },
              child: Text(
                '출차완료',
                style: TextStyle(
                  fontSize: 17, // 텍스트 크기 증가
                  fontWeight: FontWeight.bold, // 텍스트를 굵게
                  color: Colors.black87, // 텍스트 색상
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20),
                primary: Colors.red, // 버튼 색상
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // 버튼 둥글게
                ),
              ),
            ),
          ),
        ],
      ),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      primary: Colors.grey, // 버튼 색상
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
                      primary: Colors.grey, // 버튼 색상
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
                      primary: Colors.grey, // 버튼 색상
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
                      primary: Colors.grey, // 버튼 색상
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
    );
  }

  Widget carModel(
    brand,
    brandModels,
  ) {
    return AlertDialog(
      title: Text(
        '$brand 차종 선택',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      content: Container(
        height: 250,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListView.builder(
          itemCount: brandModels[brand!]!.length,
          itemBuilder: (context, index) {
            final model = brandModels[brand!]![index];

            return ListTile(
              leading: Icon(Icons.directions_car, color: Colors.blueAccent),
              title: Text(model),
              onTap: () async {
                Navigator.pop(context); // 다이얼로그 닫기

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
                      .collection(CarListAdress)
                      .doc(dataId)
                      .update({
                    'carBrand': brand,
                    'carModel': model,
                  });
                } catch (e) {
                  print('업데이트 에러: $e');
                }
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('닫기'),
        ),
      ],
    );
  }
}
