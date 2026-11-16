import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:team_husky/2car_management_system/team5-Gwangju/team5-1/team5_carList.dart';
import 'package:team_husky/2car_management_system/team5-Gwangju/team5-1/team5_electric.dart';
import 'package:team_husky/2car_management_system/team5-Gwangju/team5-1/team5_ipcha_view.dart';
import 'package:team_husky/2car_management_system/team5-Gwangju/team5-1/team5_model.dart';
import 'package:team_husky/2car_management_system/team5-Gwangju/team5-1/team5_outCar.dart';
import 'package:team_husky/2car_management_system/team5-Gwangju/team5-1/team5_search.dart';
import 'package:team_husky/2car_management_system/team5-Gwangju/team5-1/team5_smoking.dart';
import 'package:team_husky/2car_management_system/team5-Gwangju/team5_adress.dart';

class Team5Mainview extends StatefulWidget {
  const Team5Mainview({super.key,
    required this.name,
    required this.email
  });

  final String name;
  final String email;

  @override
  State<Team5Mainview> createState() => _Team5MainviewState();
}

class _Team5MainviewState extends State<Team5Mainview> {
  String carNumber = '';
  String CarListAdress = TEAM5CARLIST + formatTodayDate();
  String Color5List = COLOR5 + formatTodayDate();
  String CarScheduleAdress = formatTodayDate();
  String dayOfWeek = '';
  int bottomAction = 0;
  // 흡연 상태
  bool isSmoking = false;


// 사진 업로드 중복 실행 방지
  bool isUploading = false;

  // 이건 브랜드 선택에 사용되는 맵
  Map<String, List<String>> domesticBrands = {};
  Map<String, List<String>> importedFamousBrands = {};
  Map<String, List<String>> otherBrands = {};

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
////////////////////////////////////////////////////////////////////////////////

// 사진 선택 및 업로드
  Future<void> _pickAndUploadImage() async {
    if (isUploading) return;

    try {
      // 1. 갤러리에서 사진 선택
      final XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      final File imageFile = File(pickedFile.path);

      if (!mounted) return;

      // 2. 선택한 사진 미리보기 및 업로드 확인
      final bool? confirm = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('사진 업로드'),
            content: Image.file(
              imageFile,
              fit: BoxFit.contain,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext, false);
                },
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext, true);
                },
                child: const Text('업로드'),
              ),
            ],
          );
        },
      );

      if (confirm != true || !mounted) return;

      setState(() {
        isUploading = true;
      });

      // 3. Firebase Storage에 업로드
      // 항상 같은 경로와 파일명을 사용하므로 기존 사진이 교체됨
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('team5_timeline/current_photo.jpg');

      await storageRef.putFile(imageFile);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('사진이 업로드되었습니다.'),
        ),
      );
    } catch (e) {
      debugPrint('사진 업로드 오류: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('사진 업로드에 실패했습니다.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isUploading = false;
        });
      }
    }
  }

  // =========================
// 타임라인 사진 조회
// =========================
  Future<void> _showTimelineImage() async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('team5_timeline/current_photo.jpg');

      // Firebase Storage에서 사진 데이터 가져오기
      final Uint8List? imageData = await storageRef.getData(
        15 * 1024 * 1024,
      );

      if (!mounted) return;

      if (imageData == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('등록된 타임라인 사진이 없습니다.'),
          ),
        );
        return;
      }

      // 사진 표시
      showDialog(
        context: context,
        builder: (dialogContext) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 24,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  Container(
                    color: Colors.black,
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.8,
                    ),
                    child: InteractiveViewer(
                      minScale: 1,
                      maxScale: 4,
                      child: Image.memory(
                        imageData,
                        fit: BoxFit.contain,
                        width: double.infinity,
                      ),
                    ),
                  ),

                  // 닫기 버튼
                  Positioned(
                    top: 10,
                    right: 10,
                    child: InkWell(
                      onTap: () => Navigator.pop(dialogContext),
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.55),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } on FirebaseException catch (e) {
      if (!mounted) return;

      if (e.code == 'object-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('등록된 타임라인 사진이 없습니다.'),
          ),
        );
      } else {
        debugPrint('타임라인 사진 조회 오류: ${e.message}');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('사진을 불러오지 못했습니다.'),
          ),
        );
      }
    } catch (e) {
      debugPrint('타임라인 사진 조회 오류: $e');
    }
  }
  ////////////////////////////////////////////////////////////////////////

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
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const Team5Search();
                        },
                      );
                    },
                    child: Text(
                      '제네시스 광주',
                      style: TextStyle(
                        color: Colors.yellow, // 골드 컬러로 고급스러움 강조
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Team5Electric()),
                  );
                },
                child: Text(
                  '전기차',
                  style: TextStyle(
                    color: Colors.yellow, // 골드 컬러로 고급스러움 강조
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
                children: [
                  // 왼쪽 흡연 버튼 + 이름
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(width: 10),

                          InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () async {
                              final doc = FirebaseFirestore.instance.doc(SMOKING);

                              try {
                                final snapshot = await doc.get();
                                final currentName =
                                    snapshot.data()?['name']?.toString() ?? '';

                                await doc.update({
                                  'name': currentName.isEmpty ? widget.name : '',
                                });

                                if (!mounted) return;

                                setState(() {
                                  isSmoking = currentName.isEmpty;
                                });
                              } catch (e) {
                                debugPrint('흡연 상태 변경 오류: $e');
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: isSmoking
                                    ? const Color(0xFFC6A667)
                                    : Colors.white.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                '🚬',
                                style: TextStyle(fontSize: 19),
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          // 흡연 중인 직원 이름 실시간 표시
                          Team5Smoking(
                            stream: FirebaseFirestore.instance
                                .doc(SMOKING)
                                .snapshots(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 중앙 입차 대기
                  const Expanded(
                    child: Center(
                      child: Text(
                        '입차 대기',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  // 오른쪽 타임라인 + 사진 추가
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // 타임라인
                          InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: _showTimelineImage,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 6,
                              ),
                              child: Text(
                                '타임라인',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 5),

                          // 사진 추가
                          InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: isUploading ? null : _pickAndUploadImage,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: isUploading
                                  ? const SizedBox(
                                width: 19,
                                height: 19,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                                  : const Icon(
                                Icons.add,
                                size: 19,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Team5IpchaView(
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


              SizedBox(
                height: 10,
              ),

              Team5Outcar(
                name: widget.name,
                email: widget.email,
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
                      builder: (context) => Team5CarList(),
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
    CarListAdress = TEAM5CARLIST + formatTodayDate();
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
              color: Colors.black,
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
                  color: Colors.grey, // 기본 힌트 색은 회색
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
                      String documentId = FirebaseFirestore.instance
                          .collection(TEAM5FIELD)
                          .doc()
                          .id;
                      try {
                        await FirebaseFirestore.instance
                            .collection(TEAM5FIELD)
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
                          'option1': '', //필드에 있는 옵션1은 컬러5에 넣을 문서데이터저장
                          'option2': '', //하이패스
                          'option3': '', //기름잔량
                          'option4': '', //총거리
                          'option5': '', //시승차 기타
                          'option6': '', //최근 3종 변경자 이름
                          'option7': 0, //시승차 타입 (고객= 0 시승차 60= 1 70=2 80=3 90=4
                          'option8': '',
                          'option9': '',
                          'option10':  FieldValue.serverTimestamp(),
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
              'CX',
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
              'AE',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'B벽',
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
              '기타',
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
                location: TEAM5FIELD,
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
                location: TEAM5FIELD,
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
                location: TEAM5FIELD,
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
                location: TEAM5FIELD,
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
                location: TEAM5FIELD,
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