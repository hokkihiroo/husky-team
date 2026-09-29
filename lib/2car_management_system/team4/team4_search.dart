import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/2car_management_system/team4/team4_adress.dart';
import 'package:team_husky/2car_management_system/team4/team4_search_card.dart';

class Team4Search extends StatefulWidget {
  const Team4Search({super.key});

  @override
  State<Team4Search> createState() => _Team4SearchState();
}

class _Team4SearchState extends State<Team4Search> {
  // ⭐ 검색어
  final TextEditingController searchController =
  TextEditingController();

  // ⭐ 입력창 자동 포커스
  final FocusNode searchFocusNode = FocusNode();

  // ⭐ 검색 결과
  List<QueryDocumentSnapshot> searchResults = [];

  // ⭐ 검색 중인지 여부
  bool isSearching = false;

  @override
  void initState() {
    super.initState();

    // ⭐ 다이얼로그가 열린 직후
    // ⭐ 차량번호 입력창에 자동 포커스
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        searchFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  // ⭐ 차량번호 검색
  Future<void> searchCar(String value) async {
    if (value.isEmpty) {
      setState(() {
        searchResults = [];
        isSearching = false;
      });
      return;
    }

    setState(() {
      isSearching = true;
    });

    // ⭐ Firestore에서는 차량번호만 검색
    final snapshot = await FirebaseFirestore.instance
        .collection(TEAM4FIELD)
        .where(
      'carNumber',
      isGreaterThanOrEqualTo: value,
    )
        .where(
      'carNumber',
      isLessThan: '$value\uf8ff',
    )
        .get();

    if (!mounted) return;

    // ⭐ Flutter에서 color가 1인 차량만 골라냄
    final List<QueryDocumentSnapshot> filteredResults =
    snapshot.docs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;

      return data['color']?.toString() == '1';
    }).toList();

    setState(() {
      searchResults = filteredResults;
      isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // ⭐ 키보드가 올라와도 다이얼로그가 화면 안에 있도록
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 12,
      ),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      child: Container(
        width: 420,

        // ⭐ 다이얼로그 전체 여백
        padding: const EdgeInsets.fromLTRB(
          20,
          12,
          20,
          12,
        ),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ⭐ 조회 차량 대수 + 닫기
            Row(
              children: [
                Expanded(
                  child: Text(
                    searchController.text.isEmpty
                        ? '차량 검색'
                        : '총 ${searchResults.length}대의 차량이 조회되었습니다.',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: searchController.text.isEmpty
                          ? Colors.black87
                          : const Color(0xFFFFC107),
                    ),
                  ),
                ),

                // ⭐ 닫기
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize:
                    MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    '닫기',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            // ⭐ 차량번호 입력
            TextField(
              controller: searchController,
              focusNode: searchFocusNode,

              // ⭐ 숫자 키보드
              keyboardType: TextInputType.number,

              // ⭐ 차량번호 최대 4자리
              maxLength: 4,

              onChanged: (value) {
                // ⭐ 입력 즉시 검색
                searchCar(value);

                // ⭐ 0/4 → 1/4 → 2/4 → 3/4 → 4/4
                setState(() {});
              },

              decoration: InputDecoration(
                hintText: '차량번호를 입력하세요',

                // ⭐ 차량 아이콘
                prefixIcon: const Icon(
                  Icons.directions_car_outlined,
                ),

                // ⭐ 입력창 오른쪽 4/4
                suffixText:
                '${searchController.text.length}/4',

                suffixStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),

                // ⭐ 아래쪽 counter 공간 제거
                counterText: '',

                filled: true,
                fillColor: const Color(0xFFF7F7F7),

                // ⭐ 입력창 높이
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xFFFFC107),
                    width: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 6),

            // ⭐ 검색 결과 리스트
            Container(
              height: 190,
              width: double.infinity,

              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFEAEAEA),
                ),
              ),

              child: isSearching
                  ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFFC107),
                ),
              )
                  : searchResults.isEmpty
                  ? const Center(
                child: Text(
                  '차량번호를 입력해주세요.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                ),
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final data =
                  searchResults[index].data()
                  as Map<String, dynamic>;

                  // ⭐ 현재 차량 Firestore 문서 ID
                  final String dataId =
                      searchResults[index].id;

                  // ⭐ 검색 결과 카드
                  return Team4SearchCard(
                    carNumber:
                    data['carNumber']
                        ?.toString() ??
                        '',
                    carModel:
                    data['carModel']
                        ?.toString() ??
                        '',

                    // ⭐ 출차 기능
                    onOut: () async {
                      try {
                        // ⭐ Firestore 출차 처리
                        await FirebaseFirestore
                            .instance
                            .collection(TEAM4FIELD)
                            .doc(dataId)
                            .update({
                          // ⭐ color 1 → 2
                          'color': 2,

                          // ⭐ 확인용 시간
                          'option10':
                          FieldValue
                              .serverTimestamp(),
                        });

                        if (!mounted) return;

                        // ⭐ 현재 리스트에서 출차한 차량 제거
                        setState(() {
                          searchResults.removeWhere(
                                (doc) => doc.id == dataId,
                          );

                          // ⭐ 입력창 번호 삭제
                          searchController.clear();
                        });

                        // ⭐ 다시 차량번호를 바로 입력할 수 있도록
                        // ⭐ 커서 입력창에 포커스
                        searchFocusNode.requestFocus();
                      } catch (e) {
                        print(e);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}