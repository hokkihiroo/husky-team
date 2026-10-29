import 'package:flutter/material.dart';
import 'package:team_husky/4event/event_main_card_detail.dart';
import 'address.dart';
import 'event_brand_card.dart';
import 'event_chajong_card.dart';
import 'event_ipgo.dart';
import 'event_main_card_detail_model.dart';
import 'event_main_repository.dart';

class EventMain extends StatefulWidget {
  final String name;

  const EventMain({super.key, required this.name});

  @override
  State<EventMain> createState() => _EventMainState();
}

class _EventMainState extends State<EventMain> {
  // ============================================================
  // Firebase 브랜드 컬렉션 주소
  final EventMainRepository repository = EventMainRepository();

  // ============================================================

  // ============================================================
  // 현재 선택된 브랜드
  // ============================================================

  String? selectedBrandId;
  String? selectedBrandName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // ==========================================================
      // 본문
      // ==========================================================

      body: Column(
        children: [
          // ========================================================
          // 브랜드 영역
          // ========================================================

          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(
              12,
              12,
              12,
              10,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 제목
                Padding(
                  padding: const EdgeInsets.only(
                    left: 4,
                    bottom: 10,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 18,
                        decoration: BoxDecoration(
                          color: AppColors.gold,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '브랜드',
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      // 오른쪽으로 밀기
                      const Spacer(),

                      // 브랜드 추가 버튼
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: InkWell(
                          onTap: () {
                            final TextEditingController brandController =
                                TextEditingController();

                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  title: const Text(
                                    '브랜드 추가',
                                    style: TextStyle(
                                      color: AppColors.textDark,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  content: TextField(
                                    controller: brandController,
                                    autofocus: true,
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                      hintText: '브랜드명을 입력하세요',
                                      hintStyle: const TextStyle(
                                        color: AppColors.textGrey,
                                        fontSize: 13,
                                      ),
                                      filled: true,
                                      fillColor: AppColors.background,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: AppColors.navy,
                                        ),
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        '취소',
                                        style: TextStyle(
                                          color: AppColors.textGrey,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        final String brand =
                                            brandController.text.trim();

                                        if (brand.isEmpty) {
                                          return;
                                        }
                                        await repository.addBrand(brand);

                                        if (!context.mounted) return;
                                        Navigator.pop(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.navy,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(9),
                                        ),
                                      ),
                                      child: const Text(
                                        '추가',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 5,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.add,
                                  color: Colors.blue,
                                  size: 17,
                                ),
                                const SizedBox(width: 3),
                                const Text(
                                  '추가',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 브랜드 리스트
                SizedBox(
                  height: 48,
                  child: StreamBuilder(
                    // Firebase 직접 접근 제거
// Repository에서 브랜드 목록을 가져옴
                    stream: repository.brandStream(),
                    builder: (
                      context,
                      snapshot,
                    ) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.navy,
                            ),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            '브랜드를 불러오지 못했습니다.',
                            style: TextStyle(
                              color: AppColors.textGrey,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }

                      final docs = snapshot.data?.docs ?? [];

                      if (docs.isEmpty) {
                        return const Center(
                          child: Text(
                            '등록된 브랜드가 없습니다.',
                            style: TextStyle(
                              color: AppColors.textGrey,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }

                      // 처음 들어왔을 때 첫 번째 브랜드 선택
                      if (selectedBrandId == null && docs.isNotEmpty) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (!mounted) return;

                          setState(() {
                            selectedBrandId = docs.first.id;

                            selectedBrandName =
                                docs.first.data()['name'] ?? docs.first.id;
                          });
                        });
                      }

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: docs.length,
                        itemBuilder: (
                          context,
                          index,
                        ) {
                          final doc = docs[index];
                          final data = doc.data();

                          final String brand = data['name'] ?? doc.id;

                          final bool selected = selectedBrandId == doc.id;

                          return Padding(
                            padding: EdgeInsets.only(
                              right: index == docs.length - 1 ? 0 : 8,
                            ),
                            child: EventBrandCard(
                              brand: brand,
                              selected: selected,
                              onTap: () {
                                setState(() {
                                  selectedBrandId = doc.id;
                                  selectedBrandName = brand;
                                });
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // ========================================================
          // 선택된 브랜드
          // ========================================================

          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(
              14,
              14,
              14,
              9,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        selectedBrandName ?? '',
                        style: const TextStyle(
                          color: AppColors.textDark,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    print('아마이거 순서 정리한느거같은');
                  },
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(
                    Icons.tune_rounded,
                    color: AppColors.textGrey,
                    size: 21,
                  ),
                ),
              ],
            ),
          ),

          // ========================================================
          // 차종 리스트
          // ========================================================

          Expanded(
            child: selectedBrandId == null
                ? const SizedBox()
                : StreamBuilder(
                    // Firebase 직접 접근 제거
// Repository에서 선택된 브랜드의 차종 목록을 가져옴
                    stream: repository.chajongStream(selectedBrandId!),
                    builder: (
                      context,
                      snapshot,
                    ) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppColors.navy,
                            ),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            '차량 목록을 불러오지 못했습니다.',
                            style: TextStyle(
                              color: AppColors.textGrey,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }

                      final docs = snapshot.data?.docs ?? [];

                      if (docs.isEmpty) {
                        return const Center(
                          child: Text(
                            '등록된 차량이 없습니다.',
                            style: TextStyle(
                              color: AppColors.textGrey,
                              fontSize: 13,
                            ),
                          ),
                        );
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.fromLTRB(
                          12,
                          3,
                          12,
                          20,
                        ),
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          mainAxisExtent: 90, // 카드 높이 고정
                        ),
                        itemCount: docs.length,
                        itemBuilder: (
                          context,
                          index,
                        ) {
                          final data = docs[index].data();

                          // Map 데이터를 모델 객체로 변환
                          final EventCarModel car = EventCarModel.fromMap(data);

                          return EventChajongCard(
                            data: data,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EventCardDetail(
                                    selectedBrandName :selectedBrandName!,
                                    car: car,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      // ==========================================================
      // 하단 입고 등록
      // ==========================================================

      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            14,
            10,
            14,
            14,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: const Border(
              top: BorderSide(
                color: AppColors.border,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventIpgo(
                      selectedBrandId: selectedBrandId!,
                      registName: widget.name,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navy,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.gold.withOpacity(0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: AppColors.goldLight,
                      size: 19,
                    ),
                  ),
                  const SizedBox(width: 9),
                  const Text(
                    '입고 등록',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
