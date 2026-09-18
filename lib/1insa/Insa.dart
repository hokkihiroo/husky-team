import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:team_husky/1insa/Address.dart';
import 'package:team_husky/1insa/InsaCard.dart';
import 'package:team_husky/1insa/teamcard.dart';
import 'package:url_launcher/url_launcher.dart';

class Organization extends StatefulWidget {
  const Organization({
    super.key,
    required this.grade,
  });

  final int grade;

  @override
  State<Organization> createState() => _OrganizationState();
}

class _OrganizationState extends State<Organization> {
  // ------------------------------------------------------------
  // 기존 변수
  // ------------------------------------------------------------

  String teamId = ''; // 팀 클릭시 그 팀 고유문서 아이디값
  String name = ''; // 팀 이름
  String mansID = ''; // 팀원문서아이디
  String formattedDate = '';
  String? picUrl = '';

  // ------------------------------------------------------------
  // Firestore 실시간 스트림
  // ------------------------------------------------------------

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
  _insaSubscription;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
  _employeeSubscription;

  // 건물 목록
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _buildingDocs = [];

  // 건물ID별 직원 목록
  Map<String, List<QueryDocumentSnapshot<Map<String, dynamic>>>>
  _employeesByBuilding = {};

  // 각각의 첫 데이터가 들어왔는지 확인
  bool _insaLoaded = false;
  bool _employeeLoaded = false;

  // 에러
  Object? _error;

  // ------------------------------------------------------------
  // 초기화
  // ------------------------------------------------------------

  @override
  void initState() {
    super.initState();

    _listenToInsa();
    _listenToEmployees();
  }

  // ------------------------------------------------------------
  // 인사(건물) 실시간 감시
  // ------------------------------------------------------------

  void _listenToInsa() {
    _insaSubscription = FirebaseFirestore.instance
        .collection(INSA)
        .orderBy('createdAt')
        .snapshots()
        .listen(
          (snapshot) {
        if (!mounted) return;

        setState(() {
          _buildingDocs = snapshot.docs;
          _insaLoaded = true;
          _error = null;
        });
      },
      onError: (error) {
        if (!mounted) return;

        setState(() {
          _insaLoaded = true;
          _error = error;
        });
      },
    );
  }

  // ------------------------------------------------------------
  // 모든 list 하위 컬렉션 실시간 감시
  //
  // 구조:
  //
  // insa
  //   ├─ 본사ID
  //   │    └─ list
  //   │         ├─ 직원1
  //   │         └─ 직원2
  //   │
  //   ├─ 강남ID
  //   │    └─ list
  //   │         ├─ 직원3
  //   │         └─ 직원4
  //   │
  //   └─ 강북ID
  //        └─ list
  //
  // collectionGroup('list')를 사용하면
  // 모든 list를 한 번에 실시간으로 받을 수 있음.
  // ------------------------------------------------------------

  void _listenToEmployees() {
    _employeeSubscription = FirebaseFirestore.instance
        .collectionGroup(LIST)
        .snapshots()
        .listen(
          (snapshot) {
        if (!mounted) return;

        final Map<String,
            List<QueryDocumentSnapshot<Map<String, dynamic>>>>
        groupedEmployees = {};

        for (final employeeDoc in snapshot.docs) {
          final data = employeeDoc.data();

          // levelNumber가 없으면 0으로 처리
          final dynamic levelValue = data['levelNumber'];
          final int levelNumber = levelValue is num
              ? levelValue.toInt()
              : int.tryParse(levelValue?.toString() ?? '') ?? 0;

          // 기존 코드와 동일하게 levelNumber == 0은 제외
          if (levelNumber == 0) {
            continue;
          }

          // 직원이 들어있는 list의 부모 건물 ID
          //
          // insa / 건물ID / list / 직원ID
          //                  ↑ employeeDoc
          //
          // parent      = list
          // parent.parent = 건물ID
          final buildingId = employeeDoc.reference.parent.parent?.id;

          if (buildingId == null) {
            continue;
          }

          groupedEmployees
              .putIfAbsent(buildingId, () => [])
              .add(employeeDoc);
        }

        // levelNumber 순서대로 정렬
        for (final employees in groupedEmployees.values) {
          employees.sort((a, b) {
            final aData = a.data();
            final bData = b.data();

            final aLevelValue = aData['levelNumber'];
            final bLevelValue = bData['levelNumber'];

            final int aLevel = aLevelValue is num
                ? aLevelValue.toInt()
                : int.tryParse(aLevelValue?.toString() ?? '') ?? 0;

            final int bLevel = bLevelValue is num
                ? bLevelValue.toInt()
                : int.tryParse(bLevelValue?.toString() ?? '') ?? 0;

            return aLevel.compareTo(bLevel);
          });
        }

        setState(() {
          _employeesByBuilding = groupedEmployees;
          _employeeLoaded = true;
          _error = null;
        });
      },
      onError: (error) {
        if (!mounted) return;

        setState(() {
          _employeeLoaded = true;
          _error = error;
        });
      },
    );
  }

  // ------------------------------------------------------------
  // 종료
  // ------------------------------------------------------------

  @override
  void dispose() {
    _insaSubscription?.cancel();
    _employeeSubscription?.cancel();

    super.dispose();
  }

  // ------------------------------------------------------------
  // 홈페이지 열기
  // ------------------------------------------------------------

  void _launchWebsite(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  // ------------------------------------------------------------
  // 전화 걸기
  // ------------------------------------------------------------

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // ------------------------------------------------------------
  // 화면
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // 두 스트림에서 최초 데이터가 모두 들어올 때까지 로딩
    if (!_insaLoaded || !_employeeLoaded) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // 에러 처리
    if (_error != null) {
      return Center(
        child: Text(
          '데이터를 불러오는 중 오류가 발생했습니다.\n$_error',
          textAlign: TextAlign.center,
        ),
      );
    }

    // 기존 코드의 grade == 0 조건 유지
    final visibleBuildings = _buildingDocs.where((buildingDoc) {
      if (widget.grade == 0 &&
          buildingDoc.id == '3LDEwvJicNKtzDemmHY6') {
        return false;
      }

      return true;
    }).toList();

    return ListView.builder(
      itemCount: visibleBuildings.length,
      itemBuilder: (context, index) {
        final buildingDoc = visibleBuildings[index];
        final buildingData = buildingDoc.data();

        final String buildingId = buildingDoc.id;

        // 이 건물에 속한 직원들
        final employees =
            _employeesByBuilding[buildingId] ?? const [];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Column(
              children: [
                // ------------------------------------------------
                // 건물 카드
                // ------------------------------------------------

                GestureDetector(
                  onTap: () {
                    final schedule = buildingData['schedule'];

                    if (schedule != null &&
                        schedule.toString().trim().isNotEmpty) {
                      final siteUrl = schedule.toString();

                      _launchWebsite(siteUrl);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('권한이 없습니다'),
                        ),
                      );
                    }
                  },
                  child: BuildingCard(
                    image: Image.asset(
                      buildingData['image'],
                    ),
                    name: buildingData['name'] ?? '',
                    position: buildingData['position'] ?? '',
                    adress: buildingData['adress'] ?? '',
                  ),
                ),

                // ------------------------------------------------
                // 직원 목록
                //
                // 여기에는 StreamBuilder가 없음.
                // 이미 위에서 collectionGroup으로 전체 직원 데이터를
                // 받아놓았기 때문에 화면에서는 바로 그려줌.
                // ------------------------------------------------

                Column(
                  children: employees.map((employeeDoc) {
                    final data = employeeDoc.data();

                    return GestureDetector(
                      onTap: () async {
                        final document = employeeDoc;

                        mansID = document.id;

                        // 선택한 직원의 user 정보 가져오기
                        final Map<String, dynamic> userData =
                        await getData(mansID);

                        // 입사일 처리
                        String selectedFormattedDate = '';

                        final enterDay = userData['enterDay'];

                        if (enterDay is Timestamp) {
                          final DateTime dateTime =
                          enterDay.toDate();

                          selectedFormattedDate =
                              DateFormat('yy/MM/dd')
                                  .format(dateTime);
                        }

                        // 프로필 이미지
                        final String selectedPicUrl =
                            userData['picUrl']?.toString() ?? '';

                        if (!mounted) return;

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return viewInsa(
                              userData,
                              selectedFormattedDate,
                              selectedPicUrl,
                            );
                          },
                        );
                      },
                      child: OrganizationCard(
                        image: data['image'] != null
                            ? Image.asset(
                          data['image'],
                        )
                            : const Icon(
                          Icons.image_outlined,
                        ),
                        name: data['name'] ?? '',
                        grade: data['grade'] ?? '',
                        position: data['position'] ?? '',
                        picUrl: data['picUrl'] ?? '',
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ------------------------------------------------------------
  // 직원 상세정보
  // ------------------------------------------------------------

  Widget viewInsa(
      Map<String, dynamic> data,
      String formattedDate,
      String picUrl,
      ) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ------------------------------------------------------
          // 브라운 색 배경 영역
          // ------------------------------------------------------

          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.brown.shade800,
                  Colors.brown.shade200,
                ],
              ),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
            ),
            child: Column(
              children: [
                const Text(
                  '(주)팀허스키',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16.0),

                GestureDetector(
                  onTap: picUrl.isNotEmpty
                      ? () {
                    _showFullImage(
                      context,
                      picUrl,
                    );
                  }
                      : null,
                  child: CircleAvatar(
                    backgroundImage: picUrl.isNotEmpty
                        ? NetworkImage(picUrl)
                        : const AssetImage(
                      'asset/img/husky_Logo.png',
                    ) as ImageProvider,
                    radius: 50,
                  ),
                ),

                const SizedBox(height: 16.0),

                Text(
                  data['name'] ?? '이름 없음',
                  style: const TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 8.0),

                Text(
                  data['birthDay'] ?? '생일 정보 없음',
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          // ------------------------------------------------------
          // 흰색 배경 영역
          // ------------------------------------------------------

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 연락처
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _infoRow(
                          '연락처',
                          data['phoneNumber'],
                        ),
                      ),

                      IconButton(
                        icon: const Icon(
                          Icons.phone,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          final phone =
                              data['phoneNumber']?.toString() ??
                                  '';

                          if (phone.isNotEmpty) {
                            _makePhoneCall(phone);
                          }
                        },
                      ),
                    ],
                  ),

                  Divider(
                    thickness: 1,
                    color: Colors.grey[300],
                  ),

                  // 등록일
                  _infoRow(
                    '등록일',
                    formattedDate,
                  ),

                  Divider(
                    thickness: 1,
                    color: Colors.grey[300],
                  ),

                  // 상의 / 하의
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _infoRow(
                          '상의',
                          data['tShirtSize'],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _infoRow(
                          '하의',
                          data['pantsSize'],
                        ),
                      ),
                    ],
                  ),

                  Divider(
                    thickness: 1,
                    color: Colors.grey[300],
                  ),

                  // 신발 / 키
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _infoRow(
                          '신발',
                          data['footSize'],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _infoRow(
                          '키',
                          '${data['cm'] ?? '정보 없음'} cm',
                        ),
                      ),
                    ],
                  ),

                  Divider(
                    thickness: 1,
                    color: Colors.grey[300],
                  ),

                  // 몸무게
                  _infoRow(
                    '몸무게',
                    '${data['kg'] ?? '정보 없음'} kg',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // 상세정보 한 줄
  // ------------------------------------------------------------

  Widget _infoRow(
      String label,
      dynamic value,
      ) {
    final String displayValue =
        value?.toString() ?? '정보 없음';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
            color: Colors.black87,
          ),
        ),

        const SizedBox(width: 8.0),

        Expanded(
          child: Text(
            displayValue,
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black54,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // 전체 이미지 보기
  // ------------------------------------------------------------

  void _showFullImage(
      BuildContext context,
      String imageUrl,
      ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullImageView(
          imageUrl: imageUrl,
        ),
      ),
    );
  }
}

// ================================================================
// 선택한 직원 신상 불러오기
// ================================================================

Future<Map<String, dynamic>> getData(
    String documentId,
    ) async {
  try {
    final DocumentSnapshot<Map<String, dynamic>>
    documentSnapshot =
    await FirebaseFirestore.instance
        .collection('user')
        .doc(documentId)
        .get();

    if (documentSnapshot.exists) {
      final Map<String, dynamic>? data =
      documentSnapshot.data();

      if (data != null) {
        return data;
      } else {
        print('문서 데이터가 null입니다.');
      }
    } else {
      print('문서가 존재하지 않습니다.');
    }
  } catch (e) {
    print('데이터를 가져오는 중에 오류가 발생했습니다: $e');
  }

  return {};
}

// ================================================================
// 전체 이미지 화면
// ================================================================

class FullImageView extends StatelessWidget {
  final String imageUrl;

  const FullImageView({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Center(
          child: Hero(
            tag: 'fullImage',
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}