import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:team_husky/2car_management_system/team4/team4_adress.dart';
import 'package:team_husky/2car_management_system/team4/team4_car_list.dart';
import 'package:team_husky/2car_management_system/team4/team4_electric.dart';
import 'package:team_husky/2car_management_system/team4/team4_outcar.dart';
import 'package:team_husky/2car_management_system/team4/team4_worker_list.dart';
import 'package:team_husky/2car_management_system/team4/tema4_ipcha_view.dart';

class Team4View extends StatefulWidget {
  const Team4View({super.key, required this.name});

  final String name;

  @override
  State<Team4View> createState() => _Team4ViewState();
}

class _Team4ViewState extends State<Team4View> {
  String carNumber = '';
  String CarListAdress = TEAM4CARLIST + Team4formatTodayDate();
//ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ차량데이터 불러오기ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
  Map<String, List<String>> domesticBrands = {};
  Map<String, List<String>> importedFamousBrands = {};
  Map<String, List<String>> otherBrands = {};
//ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ차량데이터 불러오기ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ


  List<Map<String, dynamic>> memberList = [];  //멤버리스트 불러오기

  @override
  void initState() {
    super.initState();
    _loadBrandModels();
    _loadMember();
  }

  Future<void> _loadBrandModels() async {
    final result = await fetchBrandsWithModels();
    print('🔥메인뷰 국내: $domesticBrands');
    print('🔥메인뷰 수입유명: $importedFamousBrands');
    print('🔥메인뷰 잡브랜드: $otherBrands');
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

// ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ멤버불러오는함수ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
  Future<void> _loadMember() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(TEAM4MEMBER)
          .orderBy('order') // ⭐ 추가
          .get();

      print('🔥 member 문서 개수: ${snapshot.docs.length}');

      // 🔥 여기서 snapshot → List<Map> 변환
      final loadedMembers = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();

      // 상태에 저장
      setState(() {
        memberList = loadedMembers;
      });

      // 디버그 출력
      for (final m in memberList) {
        print('📄 member: $m');
      }
    } catch (e, s) {
      print('❌ Firestore 에러: $e');
      print(s);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.amber, // ← 뒤로가기 버튼 색상
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WorkerList(),
                        ),
                      );
                    },
                    child: const Text(
                      '제네시스 수지',
                      style: TextStyle(
                        color: Color(0xFFFFC107),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),


              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Team4Electric()),
                  );
                },
                child: Text(
                  '전기차',
                  style: TextStyle(
                    color: Color(0xFFFFC107), // 앰버톤 노랑 (머스타드 느낌)

                    decorationColor: Colors.white,
                    // 줄 색상
                    decorationThickness: 2, // 줄 두께
                  ),
                ),
              ),
            ],
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 40,
                  ),
                  Text(
                    '별관',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Team4IpchaView(
                name: widget.name,
                location: 0,
                domesticBrands: domesticBrands,
                importedFamousBrands:importedFamousBrands,
                otherBrands: otherBrands,
                memberList: memberList,

              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Colors.white, // 선 색상
                thickness: 2.0, // 선 두께
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 40,
                  ),
                  Text(
                    '본관',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Team4IpchaView(
                name: widget.name,
                location: 1,
                domesticBrands: domesticBrands,
                importedFamousBrands:importedFamousBrands,
                otherBrands: otherBrands,
                memberList: memberList,

              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 10,
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
              Team4OutCar(
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
                onPressed: () {
                  CarListAdress = TEAM4CARLIST + Team4formatTodayDate();
                  print(CarListAdress);
                  carNumber = '0000';
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          '입차번호',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
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
                              hintText: '입차번호를 입력해주세요',
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
                                        .collection(TEAM4FIELD)
                                        .doc()
                                        .id;
                                    try {
                                      await FirebaseFirestore.instance
                                          .collection(TEAM4FIELD)
                                          .doc(documentId)
                                          .set({
                                        'carNumber': carNumber,
                                        'name': '',
                                        'createdAt':
                                            FieldValue.serverTimestamp(),
                                        'location': 0,
                                        'color': 1,
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
                                          .collection(CarListAdress)
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
                },
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
                      builder: (context) => Team4Carlist(),
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
}
