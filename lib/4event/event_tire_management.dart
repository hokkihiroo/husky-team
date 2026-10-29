import 'package:flutter/material.dart';
import 'address.dart';

class EventTireManagement extends StatefulWidget {
  const EventTireManagement({super.key});

  @override
  State<EventTireManagement> createState() =>
      _EventTireManagementState();
}

class _EventTireManagementState
    extends State<EventTireManagement> {
  // 디자인 확인용 임시 데이터
  // 추후 event_tire 컬렉션과 연결
  final List<Map<String, dynamic>> _brands = [
    {
      'brandName': '한국타이어',
      'models': [
        {
          'modelName': 'Ventus S1 evo3',
          'details': [
            '225/45R18',
            '245/40R19',
            '255/35R20',
          ],
        },
        {
          'modelName': 'Dynapro HPX',
          'details': [
            '235/55R19',
            '255/45R20',
          ],
        },
      ],
    },
    {
      'brandName': '미쉐린',
      'models': [
        {
          'modelName': 'Pilot Sport 4S',
          'details': [
            '245/40ZR19',
            '275/35ZR20',
          ],
        },
      ],
    },
    {
      'brandName': '금호타이어',
      'models': [
        {
          'modelName': 'ECSTA PS71',
          'details': [
            '225/45R18',
            '245/40R19',
          ],
        },
      ],
    },
  ];

  int _selectedBrandIndex = 0;
  int? _selectedModelIndex;

  static const Color _navy = Color(0xFF17233C);
  static const Color _navyLight = Color(0xFF253452);
  static const Color _gold = Color(0xFFC6A667);
  static const Color _background = Color(0xFFF3F1EC);
  static const Color _textDark = Color(0xFF202632);
  static const Color _textGrey = Color(0xFF737B89);
  static const Color _border = Color(0xFFE5E2DB);

  List<Map<String, dynamic>> get _selectedModels =>
      List<Map<String, dynamic>>.from(
        _brands[_selectedBrandIndex]['models'] as List,
      );

  Map<String, dynamic>? get _selectedModel {
    if (_selectedModelIndex == null ||
        _selectedModelIndex! >= _selectedModels.length) {
      return null;
    }

    return _selectedModels[_selectedModelIndex!];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _navy,
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 20,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '타이어 관리',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 3),
            Text(
              'TIRE MANAGEMENT',
              style: TextStyle(
                fontSize: 10,
                color: Color(0xFFE6D19A),
                letterSpacing: 1.4,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  20,
                  16,
                  28,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeading(
                      title: '브랜드 관리',
                      subtitle: '등록된 타이어 브랜드를 선택하세요.',
                      count: _brands.length,
                      actionLabel: '브랜드 추가',
                      onAction: _showAddBrandDialog,
                    ),
                    const SizedBox(height: 14),
                    _buildBrandList(),
                    const SizedBox(height: 28),
                    _buildSectionHeading(
                      title: '모델 / 제품명',
                      subtitle:
                      '${_brands[_selectedBrandIndex]['brandName']}의 타이어 모델',
                      count: _selectedModels.length,
                      actionLabel: '모델 추가',
                      onAction: _showAddModelDialog,
                    ),
                    const SizedBox(height: 14),
                    _buildModelList(),
                    const SizedBox(height: 28),
                    _buildSectionHeading(
                      title: '타이어 규격',
                      subtitle: _selectedModel == null
                          ? '모델을 선택하면 규격이 표시됩니다.'
                          : '${_selectedModel!['modelName']}의 상세 규격',
                      count: _selectedModel == null
                          ? 0
                          : (_selectedModel!['details'] as List).length,
                      actionLabel: '규격 추가',
                      onAction: _selectedModel == null
                          ? null
                          : _showAddDetailDialog,
                    ),
                    const SizedBox(height: 14),
                    _buildDetailList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  // 각 관리 영역 제목
  Widget _buildSectionHeading({
    required String title,
    required String subtitle,
    required int count,
    required String actionLabel,
    required VoidCallback? onAction,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: _textDark,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: _navy.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$count',
                      style: const TextStyle(
                        color: _navy,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(
                  color: _textGrey,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        if (onAction != null)
          _addButton(
            label: actionLabel,
            onTap: onAction,
          ),
      ],
    );
  }

  Widget _addButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: _navy,
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 10,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.add_rounded,
                size: 17,
                color: Color(0xFFE6D19A),
              ),
              const SizedBox(width: 3),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 브랜드 카드
  Widget _buildBrandList() {
    return Column(
      children: List.generate(_brands.length, (index) {
        final brand = _brands[index];
        final bool selected = index == _selectedBrandIndex;
        final int modelCount =
            (brand['models'] as List).length;

        return Padding(
          padding: const EdgeInsets.only(bottom: 9),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedBrandIndex = index;
                  _selectedModelIndex = null;
                });
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected ? _navy : _border,
                    width: selected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: selected
                            ? _navy
                            : _background,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(
                        Icons.tire_repair_rounded,
                        color: selected
                            ? const Color(0xFFE6D19A)
                            : _navyLight,
                        size: 25,
                      ),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            brand['brandName'] as String,
                            style: const TextStyle(
                              color: _textDark,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '등록된 모델 $modelCount개',
                            style: const TextStyle(
                              color: _textGrey,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (selected)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: _navy,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '선택됨',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    else
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: _textGrey,
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  // 선택된 브랜드의 모델 목록
  Widget _buildModelList() {
    final models = _selectedModels;

    if (models.isEmpty) {
      return _emptyState(
        icon: Icons.tire_repair_outlined,
        title: '등록된 모델이 없습니다.',
        subtitle: '모델 추가 버튼으로 제품을 등록하세요.',
      );
    }

    return Column(
      children: List.generate(models.length, (index) {
        final model = models[index];
        final bool selected = index == _selectedModelIndex;
        final int detailCount =
            (model['details'] as List).length;

        return Padding(
          padding: const EdgeInsets.only(bottom: 9),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedModelIndex = index;
                });
              },
              borderRadius: BorderRadius.circular(15),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: selected ? _gold : _border,
                    width: selected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F1EC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.album_rounded,
                        color: _navy,
                        size: 23,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            model['modelName'] as String,
                            style: const TextStyle(
                              color: _textDark,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '등록된 규격 $detailCount개',
                            style: const TextStyle(
                              color: _textGrey,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      selected
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      color: selected ? _gold : _border,
                      size: 21,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  // 선택된 모델의 상세 규격
  Widget _buildDetailList() {
    final model = _selectedModel;

    if (model == null) {
      return _emptyState(
        icon: Icons.straighten_rounded,
        title: '모델을 선택해주세요.',
        subtitle: '선택한 모델의 타이어 규격을 이곳에서 관리합니다.',
      );
    }

    final details = List<String>.from(model['details'] as List);

    if (details.isEmpty) {
      return _emptyState(
        icon: Icons.straighten_rounded,
        title: '등록된 규격이 없습니다.',
        subtitle: '규격 추가 버튼으로 상세 치수를 등록하세요.',
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: List.generate(details.length, (index) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == details.length - 1 ? 0 : 9,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 13,
              ),
              decoration: BoxDecoration(
                color: _background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.straighten_rounded,
                    color: _navy,
                    size: 19,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      details[index],
                      style: const TextStyle(
                        color: _textDark,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: '규격 수정',
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      _showEditDetailDialog(index, details[index]);
                    },
                    icon: const Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: _navy,
                    ),
                  ),
                  IconButton(
                    tooltip: '규격 삭제',
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      _deleteDetail(index);
                    },
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      size: 19,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _emptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 28,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 32,
            color: _gold,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: _textDark,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _textGrey,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // 브랜드 추가: 디자인 확인용 임시 동작
  Future<void> _showAddBrandDialog() async {
    final name = await _showNameDialog(
      title: '브랜드 추가',
      hint: '예: 한국타이어',
      confirmText: '브랜드 등록',
    );

    if (name == null || name.isEmpty) return;

    setState(() {
      _brands.add({
        'brandName': name,
        'models': <Map<String, dynamic>>[],
      });
      _selectedBrandIndex = _brands.length - 1;
      _selectedModelIndex = null;
    });
  }

  // 모델 추가: 디자인 확인용 임시 동작
  Future<void> _showAddModelDialog() async {
    final name = await _showNameDialog(
      title: '모델 추가',
      hint: '예: Ventus S1 evo3',
      confirmText: '모델 등록',
    );

    if (name == null || name.isEmpty) return;

    setState(() {
      (_brands[_selectedBrandIndex]['models'] as List).add({
        'modelName': name,
        'details': <String>[],
      });
      _selectedModelIndex =
          (_brands[_selectedBrandIndex]['models'] as List).length - 1;
    });
  }

  // 규격 추가: 디자인 확인용 임시 동작
  Future<void> _showAddDetailDialog() async {
    final name = await _showNameDialog(
      title: '타이어 규격 추가',
      hint: '예: 225/45R18',
      confirmText: '규격 등록',
    );

    if (name == null || name.isEmpty) return;

    setState(() {
      (_selectedModel!['details'] as List).add(name);
    });
  }

  // 규격 수정: 디자인 확인용 임시 동작
  Future<void> _showEditDetailDialog(
      int index,
      String currentValue,
      ) async {
    final name = await _showNameDialog(
      title: '타이어 규격 수정',
      hint: '예: 225/45R18',
      initialValue: currentValue,
      confirmText: '수정 완료',
    );

    if (name == null || name.isEmpty) return;

    setState(() {
      (_selectedModel!['details'] as List)[index] = name;
    });
  }

  // 규격 삭제: 디자인 확인용 임시 동작
  Future<void> _deleteDetail(int index) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('규격 삭제'),
          content: const Text('선택한 타이어 규격을 삭제할까요?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('삭제'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    setState(() {
      (_selectedModel!['details'] as List).removeAt(index);
    });
  }

  // 공통 입력 팝업
  Future<String?> _showNameDialog({
    required String title,
    required String hint,
    required String confirmText,
    String initialValue = '',
  }) async {
    final controller = TextEditingController(text: initialValue);

    final String? result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: _navy,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: _background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: _navy,
                  width: 1.5,
                ),
              ),
            ),
            onSubmitted: (value) {
              Navigator.of(dialogContext).pop(value.trim());
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop<String?>(null);
              },
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(
                  controller.text.trim(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _navy,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );

    // 다이얼로그가 닫힌 뒤 컨트롤러 해제
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.dispose();
    });

    return result;
  }
}