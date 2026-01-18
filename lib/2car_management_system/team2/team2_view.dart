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

// 이건 브랜드 선택에 사용되는 맵
  Map<String, List<String>> domesticBrands = {};
  Map<String, List<String>> importedFamousBrands = {};
  Map<String, List<String>> otherBrands = {};

// 이건 시승차 선택에 사용되는 리스트
//   List<DocumentSnapshot> type60 = [];
//   List<DocumentSnapshot> type70 = [];
//   List<DocumentSnapshot> type80 = [];
//   List<DocumentSnapshot> type90 = [];

  // 이건 시승차 60,70,80,90, 카드 선택 인덱스 값
  int selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    dayOfWeek = getDayOfWeek(now);
    _loadBrandModels();
  }

// 브랜드 넣기에 사용하는 브랜드를 각각 담아서 맵에 담는과정

  Future<void> _loadBrandModels() async {
    await fetchBrandsWithModels();
    print('🔥메인뷰 국내: $domesticBrands');
    print('🔥메인뷰 수입유명: $importedFamousBrands');
    print('🔥메인뷰 잡브랜드: $otherBrands');

    // await fetchBrandsByTypeWithLists();    //시승차 불러오는 함수
    // printTypeLists();
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

  // 시승차 데이터 불러오는 코드

  // Future<void> fetchBrandsByTypeWithLists() async {
  //   final snapshots =
  //       await FirebaseFirestore.instance.collection(FORGENESIS).get();
  //
  //   // 혹시 이전 데이터 남아있을 수 있으니 초기화
  //   type60.clear();
  //   type70.clear();
  //   type80.clear();
  //   type90.clear();
  //
  //   for (var doc in snapshots.docs) {
  //     final int brandType = doc['brandType'] ?? 0;
  //
  //     switch (brandType) {
  //       case 1:
  //         type60.add(doc);
  //         break;
  //       case 2:
  //         type70.add(doc);
  //         break;
  //       case 3:
  //         type80.add(doc);
  //         break;
  //       case 4:
  //         type90.add(doc);
  //         break;
  //       default:
  //         print('⚠️ 알 수 없는 brandType: $brandType');
  //     }
  //   }
  // }

  // //시승차 프린트코드
  // void printTypeLists() {
  //   print('🔥 brandType 1');
  //   for (var doc in type60) {
  //     print(' - ${doc.data()}');
  //   }
  //
  //   print('🔥 brandType 2');
  //   for (var doc in type70) {
  //     print(' - ${doc.data()}');
  //   }
  //
  //   print('🔥 brandType 3');
  //   for (var doc in type80) {
  //     print(' - ${doc.data()}');
  //   }
  //
  //   print('🔥 brandType 4');
  //   for (var doc in type90) {
  //     print(' - ${doc.data()}');
  //   }
  // }

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
            ],
          ),
          iconTheme: IconThemeData(
            color: Color(0xFFC6A667), // 골드 컬러
          ),
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
                  // GestureDetector(
                  //   onTap: () {
                  //     showDialog(
                  //       context: context,
                  //       builder: (context) {
                  //         List<DocumentSnapshot> getCurrentList() {
                  //           switch (selectedTabIndex) {
                  //             case 0:
                  //               return type60;
                  //             case 1:
                  //               return type70;
                  //             case 2:
                  //               return type80;
                  //             case 3:
                  //               return type90;
                  //             default:
                  //               return [];
                  //           }
                  //         }
                  //
                  //         return StatefulBuilder(
                  //           builder: (context, setState) {
                  //             return AlertDialog(
                  //               title: const Text(
                  //                 '시승차 선택',
                  //                 style: TextStyle(fontWeight: FontWeight.bold),
                  //               ),
                  //               content: ConstrainedBox(
                  //                 constraints: const BoxConstraints(
                  //                   maxWidth: 300, // ⭐ Dialog 전체 폭 제한
                  //                 ),
                  //                 child: Column(
                  //                   mainAxisSize: MainAxisSize.min,
                  //                   children: [
                  //                     /// 🔹 상단 탭
                  //                     ToggleButtons(
                  //                       isSelected: List.generate(
                  //                         4,
                  //                         (index) => selectedTabIndex == index,
                  //                       ),
                  //                       onPressed: (index) {
                  //                         setState(() {
                  //                           selectedTabIndex = index;
                  //                         });
                  //                       },
                  //                       borderRadius: BorderRadius.circular(8),
                  //                       selectedColor: Colors.white,
                  //                       fillColor: Colors.purple,
                  //                       color: Colors.black,
                  //                       constraints: const BoxConstraints(
                  //                         minHeight: 48, // ⭐ 높이 키우기
                  //                         minWidth: 64, // ⭐ 폭 키우기
                  //                       ),
                  //                       children: const [
                  //                         Padding(
                  //                           padding: EdgeInsets.symmetric(
                  //                               horizontal: 16),
                  //                           child: Text('60'),
                  //                         ),
                  //                         Padding(
                  //                           padding: EdgeInsets.symmetric(
                  //                               horizontal: 14),
                  //                           child: Text('70'),
                  //                         ),
                  //                         Padding(
                  //                           padding: EdgeInsets.symmetric(
                  //                               horizontal: 14),
                  //                           child: Text('80'),
                  //                         ),
                  //                         Padding(
                  //                           padding: EdgeInsets.symmetric(
                  //                               horizontal: 14),
                  //                           child: Text('90'),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                     const SizedBox(height: 12),
                  //
                  //                     /// 🔹 Grid 영역
                  //                     Container(
                  //                       height: 350,
                  //                       width: 300,
                  //                       decoration: BoxDecoration(
                  //                         border: Border.all(
                  //                             color: Colors.grey.shade300),
                  //                         borderRadius:
                  //                             BorderRadius.circular(8),
                  //                       ),
                  //                       child: GridView.builder(
                  //                         itemCount: getCurrentList().length,
                  //                         padding: const EdgeInsets.all(10),
                  //                         gridDelegate:
                  //                             const SliverGridDelegateWithFixedCrossAxisCount(
                  //                           crossAxisCount: 3, // ✅ 한 줄에 3개
                  //                           crossAxisSpacing: 10,
                  //                           mainAxisSpacing: 10,
                  //                           childAspectRatio: 1.0,
                  //                         ),
                  //                         itemBuilder: (context, index) {
                  //                           final doc = getCurrentList()[index];
                  //
                  //                           return AnimatedContainer(
                  //                             duration: const Duration(
                  //                                 milliseconds: 150),
                  //                             decoration: BoxDecoration(
                  //                               color: Colors.white,
                  //                               borderRadius:
                  //                                   BorderRadius.circular(10),
                  //                               border: Border.all(
                  //                                 color: Colors.grey.shade300,
                  //                                 width: 1.2,
                  //                               ),
                  //                             ),
                  //                             child: InkWell(
                  //                               borderRadius:
                  //                                   BorderRadius.circular(10),
                  //                               onTap: () async {
                  //                                 Color5List = COLOR5 + formatTodayDate();
                  //                                 String documentId =
                  //                                     FirebaseFirestore.instance
                  //                                         .collection(FIELD)
                  //                                         .doc()
                  //                                         .id;
                  //                                 try {
                  //                                   await FirebaseFirestore
                  //                                       .instance
                  //                                       .collection(FIELD)
                  //                                       .doc(documentId)
                  //                                       .set({
                  //                                     'carNumber': doc['carNumber'],
                  //                                     'enterName': '',
                  //                                     'name': '',
                  //                                     'createdAt': FieldValue
                  //                                         .serverTimestamp(),
                  //                                     'location': 0,
                  //                                     'color': 5,
                  //                                     'etc': '',
                  //                                     'movedLocation': '',
                  //                                     'wigetName': '',
                  //                                     'movingTime': '',
                  //                                     'carBrand': '제네시스',
                  //                                     'carModel': doc['carBrand'],
                  //                                   });
                  //                                 } catch (e) {}
                  //
                  //                                 try {
                  //                                   await FirebaseFirestore
                  //                                       .instance
                  //                                       .collection(
                  //                                       Color5List)
                  //                                       .doc(documentId)
                  //                                       .set({
                  //                                     'carNumber': doc['carNumber'],
                  //                                     'enterName': widget.name, //자가주차하면 여기에 자가라고 들어가게함/시승차는 자기이름들어감
                  //                                     'enter': FieldValue.serverTimestamp(),
                  //                                     'out': '',
                  //                                     'outName': '',
                  //                                     'outLocation': 10,
                  //                                     'etc': '',
                  //                                     'movedLocation': '',
                  //                                     'wigetName': '',
                  //                                     'movingTime': FieldValue.serverTimestamp(),
                  //                                     'carBrand': '제네시스',
                  //                                     'carModel': doc['carBrand'],
                  //
                  //                                   });
                  //                                 } catch (e) {}
                  //
                  //                                 Navigator.pop(
                  //                                     context); // 필요하면
                  //                               },
                  //                               child: Padding(
                  //                                 padding:
                  //                                     const EdgeInsets.all(10),
                  //                                 child: Column(
                  //                                   mainAxisAlignment:
                  //                                       MainAxisAlignment
                  //                                           .center,
                  //                                   children: [
                  //                                     /// 차량번호
                  //                                     Text(
                  //                                       doc['carNumber'] ?? '',
                  //                                       maxLines: 1,
                  //                                       overflow: TextOverflow
                  //                                           .ellipsis,
                  //                                       textAlign:
                  //                                           TextAlign.center,
                  //                                       style: const TextStyle(
                  //                                         fontWeight:
                  //                                             FontWeight.bold,
                  //                                         fontSize: 14,
                  //                                       ),
                  //                                     ),
                  //                                     const SizedBox(height: 3),
                  //
                  //                                     /// 브랜드
                  //                                     Text(
                  //                                       formatCarNumber(
                  //                                           doc['carBrand'] ??
                  //                                               ''),
                  //                                       maxLines: 2,
                  //                                       softWrap: true,
                  //                                       textAlign:
                  //                                           TextAlign.center,
                  //                                       style: TextStyle(
                  //                                         fontSize: 10,
                  //                                         color: Colors
                  //                                             .grey.shade700,
                  //                                         fontWeight:
                  //                                             FontWeight.w500,
                  //                                       ),
                  //                                     ),
                  //                                   ],
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                           );
                  //                         },
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //               actions: [
                  //                 TextButton(
                  //                   onPressed: () => Navigator.pop(context),
                  //                   child: const Text('닫기'),
                  //                 ),
                  //               ],
                  //             );
                  //           },
                  //         );
                  //       },
                  //     );
                  //   },
                  //   child: const Text(
                  //     '시승차',
                  //     style: TextStyle(
                  //       fontSize: 18,
                  //       fontWeight: FontWeight.bold,
                  //       color: Colors.purple,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Team2IpchaView(
                name: widget.name,
                domesticBrands: domesticBrands,
                importedFamousBrands: importedFamousBrands,
                otherBrands: otherBrands,
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
                domesticBrands: domesticBrands,
                importedFamousBrands: importedFamousBrands,
                otherBrands: otherBrands,
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
                onPressed: () => doEnterAction('고객차입니다', '번호를 입력해주세요', 1),
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

  void doEnterAction(topic, hint, color) {
    CarListAdress = CARLIST + formatTodayDate();
    carNumber = '0000';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            topic,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color:
                Colors.black,
            ),
          ),
          actions: [
            TextField(
              keyboardType: TextInputType.number,
              autofocus: true,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9]')),
              ],
              maxLength: 4,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color:
                   Colors.grey, // 기본 힌트 색은 회색
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
                      padding:
                          EdgeInsets.symmetric(vertical: 20.0), // 버튼의 위아래 패딩 조정
                    ),
                    onPressed: () async {
                      String documentId =
                          FirebaseFirestore.instance.collection(FIELD).doc().id;
                      try {
                        await FirebaseFirestore.instance
                            .collection(FIELD)
                            .doc(documentId)
                            .set({
                          'carNumber': carNumber,
                          'enterName': '', //자가주차하면 여기에 자가라고 들어가게함
                          'name': '',
                          'createdAt': FieldValue.serverTimestamp(),
                          'location': 0,
                          'color': color,
                          'etc': '',
                          'movedLocation': '입차',
                          'wigetName': '',
                          'movingTime': '',
                          'carBrand': '',
                          'carModel': '',
                          'option1': '',
                          'option2': '',
                          'option3': '',
                          'option4': '',
                          'option5': '',
                          'option6': '',
                          'option7': '',
                          'option8': '',
                          'option9': '',
                          'option10': '',
                          'option11': '',
                          'option12': '',
                        });
                      } catch (e) {}

                      try {
                        await FirebaseFirestore.instance
                            .collection(CarListAdress)
                            .doc(documentId)
                            .set({
                          'carNumber': carNumber,
                          'enterName': '', //자가주차하면 여기에 자가라고 들어가게함
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
                      padding:
                          EdgeInsets.symmetric(vertical: 20.0), // 버튼의 위아래 패딩 조정
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

  final Map<String, List<String>> domesticBrands;
  final Map<String, List<String>> importedFamousBrands;
  final Map<String, List<String>> otherBrands;

  _Lists({
    super.key,
    required this.name,
    required this.domesticBrands,
    required this.importedFamousBrands,
    required this.otherBrands,
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
                domesticBrands: domesticBrands,
                importedFamousBrands: importedFamousBrands,
                otherBrands: otherBrands,
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
                domesticBrands: domesticBrands,
                importedFamousBrands: importedFamousBrands,
                otherBrands: otherBrands,
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
                domesticBrands: domesticBrands,
                importedFamousBrands: importedFamousBrands,
                otherBrands: otherBrands,
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
                domesticBrands: domesticBrands,
                importedFamousBrands: importedFamousBrands,
                otherBrands: otherBrands,
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
                domesticBrands: domesticBrands,
                importedFamousBrands: importedFamousBrands,
                otherBrands: otherBrands,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
