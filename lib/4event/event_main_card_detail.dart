import 'package:flutter/material.dart';
import 'address.dart';
import 'event_main_card_detail_model.dart';
import 'event_tire_management.dart';

class EventCardDetail extends StatefulWidget {
  final EventCarModel car;
  final String selectedBrandName;

  const EventCardDetail({
    super.key,
    required this.car,
    required this.selectedBrandName,
  });

  @override
  State<EventCardDetail> createState() => _EventCardDetailState();
}

class _EventCardDetailState extends State<EventCardDetail> {
  // 상단 차량 카드 버튼
  Widget _headerActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white.withOpacity(0.08),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          height: 64,
          padding: const EdgeInsets.symmetric(
            horizontal: 3,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.goldLight.withOpacity(0.65),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: AppColors.goldLight,
                size: 21,
              ),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 특이사항 입력 팝업
// 특이사항 입력 팝업
  Future<void> _showSpecialNoteDialog() async {
    final String? note = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return _SpecialNoteDialog(
          backgroundColor: AppColors.background,
          borderColor: AppColors.border,
          primaryColor: AppColors.navy,
        );
      },
    );

    if (!mounted) return;

    if (note != null && note.isNotEmpty) {
      // TODO: 입력한 특이사항 저장 기능 연결
      debugPrint('입력한 특이사항: $note');
    }
  }


  @override
  Widget build(BuildContext context) {
    final car = widget.car;
    // 모델을 통해 차량 데이터 가져오기

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '차량 상세정보',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 차량 기본 정보
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.navy,
                    AppColors.navyLight,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.navy.withOpacity(0.15),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1행: 차량 아이콘 / 브랜드명 / 타이어 관리
                  Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.directions_car_rounded,
                          color: AppColors.goldLight,
                          size: 27,
                        ),
                      ),
                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'VEHICLE DETAIL',
                              style: TextStyle(
                                color: AppColors.goldLight,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.selectedBrandName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      SizedBox(
                        width: 84,
                        child: _headerActionButton(
                          icon: Icons.tire_repair_rounded,
                          label: '타이어 관리',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EventTireManagement(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // 2행: 차량번호 제목 / 데미지 추가 버튼
                  // 차량번호 정보 + 데미지 추가 버튼
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 왼쪽: 차량번호 제목과 차량번호 값
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              '차량번호',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 3),

                            Text(
                              _display(car.carNumber),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 27,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      // 오른쪽 끝: 데미지 추가 버튼
                      SizedBox(
                        width: 84,
                        child: _headerActionButton(
                          icon: Icons.car_crash_rounded,
                          label: '데미지 추가',
                          onTap: () {
                            // TODO: 데미지 입력 페이지 이동
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Container(
                    height: 1,
                    color: Colors.white.withOpacity(0.18),
                  ),

                  const SizedBox(height: 14),

                  // 4행: 브랜드 / 모델 / 특이사항
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: _headerInfo('브랜드', car.brand),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _headerInfo('모델', car.carModel),
                      ),

                      const SizedBox(width: 10),

                      SizedBox(
                        width: 84,
                        child: _headerActionButton(
                          icon: Icons.edit_note_rounded,
                          label: '특이사항',
                          onTap: () {
                            _showSpecialNoteDialog();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            // 운행 정보
            _sectionTitle(
              '운행 정보',
              '주행거리와 차량 관리 정보',
              Icons.speed_rounded,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              decoration: _cardDecoration(),
              child: Column(
                children: [
                  _infoRow(
                    Icons.speed_rounded,
                    '총 마일리지',
                    _display(car.mileage, 'km'),
                  ),
                  _divider(),
                  _infoRow(
                    Icons.local_gas_station_outlined,
                    '주행 가능 거리',
                    _display(car.fuelAmount, 'km'),
                  ),
                  _divider(),
                  _infoRow(
                    Icons.key_rounded,
                    '차량 키 수량',
                    _display(car.keyQuantity, '개'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            // 타이어 정보
            _sectionTitle(
              '타이어 정보',
              '장착된 타이어 브랜드 및 모델',
              Icons.tire_repair_rounded,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.gold.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.tire_repair_rounded,
                          color: AppColors.navy,
                          size: 23,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          '타이어 브랜드',
                          style: TextStyle(
                            color: AppColors.textDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          _display(car.tireBrand),
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            color: AppColors.navy,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _tireInfo(
                    title: '앞 타이어',
                    model: car.frontTireModel,
                    icon: Icons.arrow_back_rounded,
                  ),
                  const SizedBox(height: 10),
                  _tireInfo(
                    title: '뒤 타이어',
                    model: car.rearTireModel,
                    icon: Icons.arrow_forward_rounded,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            // 차량 데미지 영역 - 디자인만 구성
            _sectionTitle(
              '차량 데미지',
              '차량 손상 및 특이사항',
              Icons.car_crash_outlined,
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: _cardDecoration(),
              child: Column(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: AppColors.gold.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: const Icon(
                      Icons.car_crash_outlined,
                      color: AppColors.navy,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '데미지 기록',
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '차량의 손상 위치, 종류 및 사진을\n'
                    '기록할 수 있도록 구성할 예정입니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 12,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.navy.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.border,
                      ),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_circle_outline_rounded,
                            color: AppColors.navy,
                            size: 19,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '데미지 추가 기능 예정',
                            style: TextStyle(
                              color: AppColors.navy,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            // 등록 정보
            _sectionTitle(
              '등록 정보',
              '차량 등록자',
              Icons.person_outline_rounded,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              decoration: _cardDecoration(),
              child: _infoRow(
                Icons.person_outline_rounded,
                '등록자',
                _display(car.registName),
              ),
            ),

            const SizedBox(height: 28),

            // 닫기 버튼
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.navy,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  '닫기',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 값 표시
  String _display(String value, [String unit = '']) {
    if (value.isEmpty) return '미등록';
    return unit.isEmpty ? value : '$value $unit';
  }

  // 상단 브랜드 및 모델
  Widget _headerInfo(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _display(value),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  // 섹션 제목
  Widget _sectionTitle(
    String title,
    String subtitle,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.navy.withOpacity(0.07),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(
            icon,
            color: AppColors.navy,
            size: 22,
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 공통 카드 디자인
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: AppColors.border,
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.navy.withOpacity(0.025),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  // 상세 정보 행
  Widget _infoRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.navy.withOpacity(0.06),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              icon,
              color: AppColors.navy,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textGrey,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 타이어 정보 행
  Widget _tireInfo({
    required String title,
    required String model,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.navy,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              _display(model),
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: AppColors.navy,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 구분선
  Widget _divider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.border.withOpacity(0.7),
    );
  }
}




// 특이사항 팝업 전용 위젯
class _SpecialNoteDialog extends StatefulWidget {
  final Color backgroundColor;
  final Color borderColor;
  final Color primaryColor;

  const _SpecialNoteDialog({
    required this.backgroundColor,
    required this.borderColor,
    required this.primaryColor,
  });

  @override
  State<_SpecialNoteDialog> createState() =>
      _SpecialNoteDialogState();
}

class _SpecialNoteDialogState extends State<_SpecialNoteDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        '특이사항 입력',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLines: 4,
        minLines: 3,
        decoration: InputDecoration(
          hintText: '차량 특이사항을 입력해주세요.',
          filled: true,
          fillColor: widget.backgroundColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: widget.borderColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: widget.primaryColor,
              width: 1.5,
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(
              _controller.text.trim(),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.primaryColor,
            foregroundColor: Colors.white,
          ),
          child: const Text('확인'),
        ),
      ],
    );
  }
}