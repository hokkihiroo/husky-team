import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'address.dart';
import 'event_ipgo_repository.dart';

class EventIpgo extends StatefulWidget {
  final String selectedBrandId;

  // 나중에 메인 화면에서 전달할 등록자 이름
  final String registName;

  const EventIpgo({
    super.key,
    required this.selectedBrandId,
    required this.registName,
  });

  @override
  State<EventIpgo> createState() => _EventIpgoState();
}

class _EventIpgoState extends State<EventIpgo> {
  // ============================================================
  // 기능 : 데이터 및 입력 상태
  // ============================================================

  final EventIpgoRepository _repository = EventIpgoRepository();

  String? selectedBrand;
  EventIpgoItem? selectedModel;
  EventIpgoItem? selectedDetail;

  List<EventIpgoItem> modelList = [];
  List<EventIpgoItem> detailList = [];

  bool isLoading = true;
  bool isLoadingDetails = false;
  bool showModelList = false;
  bool showDetailList = false;
  bool isSaving = false;

  bool brandError = false;
  bool modelError = false;
  bool detailError = false;
  bool carNumberFirstError = false;
  bool carNumberHangulError = false;
  bool carNumberLastError = false;
  bool mileageError = false;
  bool fuelAmountError = false;
  bool keyQuantityError = false;

  String? loadError;

  final TextEditingController carNumberFirstController =
  TextEditingController();

  final TextEditingController carNumberHangulController =
  TextEditingController();

  final TextEditingController carNumberLastController =
  TextEditingController();

  // ============================================================
// 기능 : 마일리지 / 주유량 / 차키 수량 입력
  final TextEditingController mileageController =
  TextEditingController();

  final TextEditingController fuelAmountController =
  TextEditingController();

  final TextEditingController keyQuantityController =
  TextEditingController();
// ============================================================



  // ============================================================
  // 기능 : 화면 초기화 및 해제
  // ============================================================

  @override
  void initState() {
    super.initState();
    _loadCarData();
  }

  @override
  void dispose() {
    carNumberFirstController.dispose();
    carNumberHangulController.dispose();
    carNumberLastController.dispose();
    mileageController.dispose();
    fuelAmountController.dispose();
    keyQuantityController.dispose();
    super.dispose();
  }

  // ============================================================
  // 기능 : 브랜드 및 모델 목록 조회
  // ============================================================

  Future<void> _loadCarData() async {
    setState(() {
      isLoading = true;
      loadError = null;
    });

    try {
      final brandName =
      await _repository.getBrandName(widget.selectedBrandId);

      final models =
      await _repository.getModels(widget.selectedBrandId);

      if (!mounted) return;

      setState(() {
        selectedBrand = brandName.isEmpty ? null : brandName;
        modelList = models;
        isLoading = false;
        loadError = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        loadError = '차량 정보를 불러오지 못했습니다.';
      });
    }
  }

  // ============================================================
  // 기능 : 선택된 모델에 해당하는 상세 목록 조회
  // ============================================================

  Future<void> _loadDetails(EventIpgoItem model) async {
    setState(() {
      isLoadingDetails = true;
      detailList = [];
      selectedDetail = null;
      showDetailList = false;
    });

    try {
      final details = await _repository.getDetails(
        brandId: widget.selectedBrandId,
        modelId: model.id,
      );

      if (!mounted) return;

      // 조회 도중 다른 모델을 선택했다면 이전 결과를 반영하지 않음
      if (selectedModel?.id != model.id) return;

      setState(() {
        detailList = details;
        isLoadingDetails = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        detailList = [];
        isLoadingDetails = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('상세 정보를 불러오지 못했습니다.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ============================================================
  // 기능 : 모델 / 상세 추가 팝업
  // ============================================================

  Future<String?> _showAddDialog({
    required String title,
    required String description,
    required String hint,
    required String buttonText,
  }) async {
    final controller = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        void submit() {
          final value = controller.text.trim();

          if (value.isEmpty) return;

          FocusScope.of(dialogContext).unfocus();
          Navigator.of(dialogContext).pop(value);
        }

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 32),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.navy.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Icon(
                        Icons.directions_car_outlined,
                        color: AppColors.navy,
                        size: 21,
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
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            description,
                            style: const TextStyle(
                              color: AppColors.textGrey,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(dialogContext).unfocus();
                        Navigator.of(dialogContext).pop();
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: AppColors.background,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: AppColors.textGrey,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                const Text(
                  '이름',
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TextField(
                    controller: controller,
                    autofocus: true,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => submit(),
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: const TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 13,
                      ),
                      prefixIcon: const Icon(
                        Icons.directions_car_outlined,
                        color: AppColors.textGrey,
                        size: 19,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _dialogButton(
                        text: '취소',
                        backgroundColor: AppColors.background,
                        foregroundColor: AppColors.textGrey,
                        onTap: () {
                          FocusScope.of(dialogContext).unfocus();
                          Navigator.of(dialogContext).pop();
                        },
                      ),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: _dialogButton(
                        text: buttonText,
                        backgroundColor: AppColors.navy,
                        foregroundColor: Colors.white,
                        icon: Icons.add,
                        onTap: submit,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    // 팝업이 닫힌 뒤 컨트롤러 정리
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.dispose();
    });

    return result;
  }

  Widget _dialogButton({
    required String text,
    required Color backgroundColor,
    required Color foregroundColor,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        borderRadius: BorderRadius.circular(11),
        onTap: onTap,
        child: SizedBox(
          height: 46,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: AppColors.goldLight,
                  size: 18,
                ),
                const SizedBox(width: 4),
              ],
              Text(
                text,
                style: TextStyle(
                  color: foregroundColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // 기능 : 모델 추가
  // ============================================================

  Future<void> _addModel() async {
    final result = await _showAddDialog(
      title: '차량 모델 추가',
      description: '새로운 차량 모델을 등록해주세요.',
      hint: '예) AMG, E-Class',
      buttonText: '모델 추가',
    );

    if (result == null || result.trim().isEmpty) return;

    final name = result.trim();

    try {
      await _repository.addModel(
        brandId: widget.selectedBrandId,
        model: name,
      );

      if (!mounted) return;

      final models =
      await _repository.getModels(widget.selectedBrandId);

      if (!mounted) return;

      final addedModel = models.where((item) => item.name == name);

      setState(() {
        modelList = models;

        if (addedModel.isNotEmpty) {
          selectedModel = addedModel.last;
          selectedDetail = null;
          detailList = [];
          modelError = false;
          detailError = false;
          showModelList = false;
        }
      });

      if (addedModel.isNotEmpty) {
        await _loadDetails(addedModel.last);
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('모델 추가에 실패했습니다. 다시 시도해주세요.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ============================================================
  // 기능 : 상세 추가
  // 선택된 모델이 있을 때만 실행
  // ============================================================

  Future<void> _addDetail() async {
    final model = selectedModel;

    if (model == null) return;

    final result = await _showAddDialog(
      title: '차량 상세 추가',
      description: '${model.name} 모델의 상세 정보를 등록합니다.',
      hint: '예) GT55',
      buttonText: '상세 추가',
    );

    if (result == null || result.trim().isEmpty) return;

    final name = result.trim();

    try {
      await _repository.addDetail(
        brandId: widget.selectedBrandId,
        modelId: model.id,
        detail: name,
      );

      if (!mounted) return;

      final details = await _repository.getDetails(
        brandId: widget.selectedBrandId,
        modelId: model.id,
      );

      if (!mounted) return;

      final addedDetail = details.where((item) => item.name == name);

      setState(() {
        detailList = details;

        if (addedDetail.isNotEmpty) {
          selectedDetail = addedDetail.last;
          detailError = false;
          showDetailList = false;
        }
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('상세 추가에 실패했습니다. 다시 시도해주세요.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ============================================================
  // UI : 모델 / 상세 추가 버튼
  // ============================================================

  Widget _buildAddButton({
    required String label,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    final color = enabled ? Colors.blue : Colors.grey;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: enabled ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 3,
            vertical: 5,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, color: color, size: 17),
              const SizedBox(width: 1),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // UI : 모델 / 상세 선택 상자
  // ============================================================

  Widget _buildSelectBox({
    required String hint,
    required String? selectedName,
    required bool hasItems,
    required bool isOpen,
    required bool hasError,
    required bool isLoadingItems,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: isLoadingItems || !hasItems ? null : onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: hasError ? Colors.red : AppColors.border,
            width: hasError ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                isLoadingItems
                    ? '불러오는 중'
                    : !hasItems
                    ? '목록 없음'
                    : selectedName ?? hint,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: !hasItems || isLoadingItems
                      ? AppColors.textGrey
                      : selectedName == null
                      ? AppColors.textGrey
                      : AppColors.textDark,
                  fontSize: 13,
                  fontWeight: selectedName == null
                      ? FontWeight.w500
                      : FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 2),
            Icon(
              isOpen
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              color: AppColors.textGrey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // UI : 모델 / 상세 목록
  // ============================================================

  Widget _buildOptionList({
    required List<EventIpgoItem> items,
    required EventIpgoItem? selectedItem,
    required ValueChanged<EventIpgoItem> onSelect,
  }) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 5),
      constraints: const BoxConstraints(maxHeight: 180),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final selected = selectedItem?.id == item.id;

          return InkWell(
            onTap: () => onSelect(item),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 12,
              ),
              color: selected
                  ? AppColors.navy.withOpacity(0.05)
                  : Colors.transparent,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: selected
                            ? AppColors.navy
                            : AppColors.textDark,
                        fontSize: 13,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                  if (selected)
                    const Icon(
                      Icons.check_rounded,
                      color: AppColors.navy,
                      size: 17,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // UI : 차량번호 입력칸
  // ============================================================

  Widget _buildPlateField({
    required TextEditingController controller,
    required String hint,
    required int maxLength,
    required bool hasError,
    required TextInputType keyboardType,
    required ValueChanged<String> onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textAlign: TextAlign.center,
      maxLength: maxLength,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        counterText: '',
        hintStyle: const TextStyle(
          color: AppColors.textGrey,
          fontSize: 13,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide(
            color: hasError ? Colors.red : AppColors.border,
            width: hasError ? 1.4 : 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide(
            color: hasError ? Colors.red : AppColors.navy,
            width: 1.4,
          ),
        ),
      ),
    );
  }

  // ============================================================
// UI : 숫자 입력칸 + 단위 표시
// ============================================================

  Widget _buildNumberField({
    required TextEditingController controller,
    required String hint,
    required String unit,
    int? maxLength,
    bool isKeyQuantity = false,
    bool isError = false,
  }) {
    final Color borderColor = isError ? Colors.red : AppColors.border;

    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        if (isKeyQuantity)
          FilteringTextInputFormatter.allow(RegExp(r'^[12]?$'))
        else
          FilteringTextInputFormatter.digitsOnly,
        if (maxLength != null)
          LengthLimitingTextInputFormatter(maxLength),
      ],
      maxLength: maxLength,
      decoration: InputDecoration(
        hintText: hint,
        counterText: '',
        filled: true,
        fillColor: Colors.white,
        hintStyle: const TextStyle(
          color: AppColors.textGrey,
          fontSize: 13,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 13,
        ),
        suffixText: unit,
        suffixStyle: const TextStyle(
          color: AppColors.textGrey,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide(
            color: borderColor,
            width: isError ? 1.5 : 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide(
            color: isError ? Colors.red : AppColors.navy,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // 기능 : 차량 등록 검증 및 저장
  // ============================================================

  Future<void> _register() async {
    if (isSaving) return;

    final first = carNumberFirstController.text.trim();
    final hangul = carNumberHangulController.text.trim();
    final last = carNumberLastController.text.trim();

    final mileageText = mileageController.text.trim();
    final fuelAmountText = fuelAmountController.text.trim();
    final keyQuantityText = keyQuantityController.text.trim();

    final validFirst = RegExp(r'^\d{2,3}$').hasMatch(first);
    final validHangul = RegExp(r'^[가-힣a-zA-Z]$').hasMatch(hangul);
    final validLast = RegExp(r'^\d{4}$').hasMatch(last);

    setState(() {
      brandError = selectedBrand == null || selectedBrand!.isEmpty;
      modelError = selectedModel == null;
      detailError = selectedDetail == null;

      carNumberFirstError = !validFirst;
      carNumberHangulError = !validHangul;
      carNumberLastError = !validLast;

      mileageError = mileageText.isEmpty;
      fuelAmountError = fuelAmountText.isEmpty;
      keyQuantityError =
          keyQuantityText != '1' && keyQuantityText != '2';
    });

    // 브랜드 / 모델 / 상세 / 차량번호 검증
    if (brandError ||
        modelError ||
        detailError ||
        carNumberFirstError ||
        carNumberHangulError ||
        carNumberLastError ||
        mileageError ||
        fuelAmountError ||
        keyQuantityError) {
      return;
    }

    // 마일리지 / 주유량 / 차키 수량 빈칸 검증
    if (mileageText.isEmpty ||
        fuelAmountText.isEmpty ||
        keyQuantityText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('마일리지, 주유량, 차키 수량을 모두 입력해주세요.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // 마일리지와 주유량 숫자 검증
    if (!RegExp(r'^\d+$').hasMatch(mileageText) ||
        !RegExp(r'^\d+$').hasMatch(fuelAmountText)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('마일리지와 주유량은 숫자만 입력해주세요.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // 차키 수량은 1 또는 2만 허용
    if (keyQuantityText != '1' && keyQuantityText != '2') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('차키 수량은 1개 또는 2개만 입력할 수 있습니다.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await _repository.registerCar(
        brandId: widget.selectedBrandId,
        brandName: selectedBrand!,
        modelId: selectedModel!.id,
        model: selectedModel!.name,
        detailId: selectedDetail!.id,
        detail: selectedDetail!.name,
        carNumberFirst: first,
        carNumberHangul: hangul,
        carNumberLast: last,
        mileage: mileageText,
        fuelAmount: fuelAmountText,
        keyQuantity: keyQuantityText,
        registName: widget.registName,
      );

      if (!mounted) return;

      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.55),
        builder: (dialogContext) {
          return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            insetPadding: const EdgeInsets.symmetric(horizontal: 32),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 30,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 22),
                    decoration: const BoxDecoration(
                      color: AppColors.navy,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: AppColors.gold.withOpacity(0.18),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: AppColors.goldLight,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          '차량 등록 완료',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
                    child: Column(
                      children: [
                        const Text(
                          '차량이 정상적으로 등록되었습니다.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textDark,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '$selectedBrand · ${selectedModel!.name}\n'
                              '${selectedDetail!.name}\n'
                              '$first$hangul$last',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textGrey,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 22),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                              Navigator.of(context).pop(true);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.navy,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                            ),
                            child: const Text(
                              '확인',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('차량 등록에 실패했습니다. 다시 시도해주세요.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  // ============================================================
  // UI : 화면
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final detailEnabled = selectedModel != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          '입고 등록',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(14, 16, 14, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 3, bottom: 14),
                      child: Row(
                        children: [
                          Container(
                            width: 4,
                            height: 20,
                            decoration: BoxDecoration(
                              color: AppColors.gold,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 9),
                          const Text(
                            '차량 정보',
                            style: TextStyle(
                              color: AppColors.textDark,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ==================================================
                    // 로딩 / 오류
                    // ==================================================

                    if (isLoading)
                      _statusCard(
                        child: const Column(
                          children: [
                            SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: AppColors.navy,
                              ),
                            ),
                            SizedBox(height: 14),
                            Text(
                              '차량 정보를 불러오는 중입니다.',
                              style: TextStyle(
                                color: AppColors.textGrey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),

                    if (!isLoading && loadError != null)
                      _statusCard(
                        child: Column(
                          children: [
                            const Icon(
                              Icons.error_outline_rounded,
                              color: Colors.red,
                              size: 30,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              loadError!,
                              style: const TextStyle(
                                color: AppColors.textDark,
                                fontSize: 14,
                              ),
                            ),
                            TextButton(
                              onPressed: _loadCarData,
                              child: const Text('다시 불러오기'),
                            ),
                          ],
                        ),
                      ),

                    // ==================================================
                    // 입력 영역
                    // ==================================================

                    if (!isLoading && loadError == null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.border),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.025),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ==========================================
                            // 브랜드
                            // ==========================================

                            const Text(
                              '브랜드',
                              style: TextStyle(
                                color: AppColors.textDark,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              height: 48,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F2F4),
                                borderRadius: BorderRadius.circular(11),
                                border: Border.all(
                                  color: brandError
                                      ? Colors.red
                                      : const Color(0xFFD9DCE1),
                                  width: brandError ? 1.4 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.directions_car_outlined,
                                    color: AppColors.textGrey,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 9),
                                  Expanded(
                                    child: Text(
                                      selectedBrand ?? '브랜드 정보 없음',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: AppColors.navy,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 18),

                            // ==========================================
                            // 모델 / 상세 : 한 줄에 반반 배치
                            // ==========================================

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ========================================
                                // 모델
                                // ========================================

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Expanded(
                                            child: Text(
                                              '모델',
                                              style: TextStyle(
                                                color: AppColors.textDark,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          _buildAddButton(
                                            label: '추가',
                                            enabled: true,
                                            onTap: _addModel,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      _buildSelectBox(
                                        hint: '모델 선택',
                                        selectedName: selectedModel?.name,
                                        hasItems: modelList.isNotEmpty,
                                        isOpen: showModelList,
                                        hasError: modelError,
                                        isLoadingItems: false,
                                        onTap: () {
                                          setState(() {
                                            showModelList = !showModelList;
                                            showDetailList = false;
                                          });
                                        },
                                      ),
                                      if (showModelList)
                                        _buildOptionList(
                                          items: modelList,
                                          selectedItem: selectedModel,
                                          onSelect: (model) {
                                            setState(() {
                                              selectedModel = model;
                                              selectedDetail = null;
                                              detailList = [];
                                              modelError = false;
                                              detailError = false;
                                              showModelList = false;
                                              showDetailList = false;
                                            });

                                            _loadDetails(model);
                                          },
                                        ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 10),

                                // ========================================
                                // 상세
                                // ========================================

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Expanded(
                                            child: Text(
                                              '상세',
                                              style: TextStyle(
                                                color: AppColors.textDark,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          _buildAddButton(
                                            label: '추가',
                                            enabled: detailEnabled,
                                            onTap: _addDetail,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      _buildSelectBox(
                                        hint: '상세 선택',
                                        selectedName: selectedDetail?.name,
                                        hasItems: detailList.isNotEmpty,
                                        isOpen: showDetailList,
                                        hasError: detailError,
                                        isLoadingItems: isLoadingDetails,
                                        onTap: () {
                                          setState(() {
                                            showDetailList = !showDetailList;
                                            showModelList = false;
                                          });
                                        },
                                      ),
                                      if (showDetailList)
                                        _buildOptionList(
                                          items: detailList,
                                          selectedItem: selectedDetail,
                                          onSelect: (detail) {
                                            setState(() {
                                              selectedDetail = detail;
                                              detailError = false;
                                              showDetailList = false;
                                            });
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // ==========================================
                            // 차량번호 : 숫자 3자리 + 한글 1자리 + 숫자 4자리
                            // ==========================================

                            const Text(
                              '차량번호',
                              style: TextStyle(
                                color: AppColors.textDark,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: _buildPlateField(
                                    controller: carNumberFirstController,
                                    hint: '123',
                                    maxLength: 3,
                                    hasError: carNumberFirstError,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      if (carNumberFirstError &&
                                          RegExp(r'^\d{2,3}$').hasMatch(value)) {
                                        setState(() {
                                          carNumberFirstError = false;
                                        });
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 7),
                                Expanded(
                                  flex: 2,
                                  child: _buildPlateField(
                                    controller: carNumberHangulController,
                                    hint: '가',
                                    maxLength: 1,
                                    hasError: carNumberHangulError,
                                    keyboardType: TextInputType.text,
                                    onChanged: (value) {
                                      if (carNumberHangulError &&
                                          RegExp(r'^[가-힣a-zA-Z]$').hasMatch(value)) {
                                        setState(() {
                                          carNumberHangulError = false;
                                        });
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 7),
                                Expanded(
                                  flex: 4,
                                  child: _buildPlateField(
                                    controller: carNumberLastController,
                                    hint: '4567',
                                    maxLength: 4,
                                    hasError: carNumberLastError,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      if (carNumberLastError &&
                                          RegExp(r'^\d{4}$').hasMatch(value)) {
                                        setState(() {
                                          carNumberLastError = false;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

// ==========================================================
// UI : 마일리지 / 주유량
// ==========================================================

                            const SizedBox(height: 20),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 마일리지: 40%
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        '마일리지 (총주행거리)',
                                        style: TextStyle(
                                          color: AppColors.textDark,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      _buildNumberField(
                                        controller: mileageController,
                                        hint: '주행거리',
                                        unit: 'KM',
                                        isError: mileageError,
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 10),

                                // 주유량: 40%
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        '주유량',
                                        style: TextStyle(
                                          color: AppColors.textDark,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      _buildNumberField(
                                        controller: fuelAmountController,
                                        hint: '주유량',
                                        unit: 'KM',
                                        isError: fuelAmountError,
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 10),

                                // 차키 수량: 20%
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        '차키 수량',
                                        style: TextStyle(
                                          color: AppColors.textDark,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      _buildNumberField(
                                        controller: keyQuantityController,
                                        hint: '1/2',
                                        unit: '개',
                                        maxLength: 1,
                                        isKeyQuantity: true,
                                        isError: keyQuantityError,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // ============================================================
            // 하단 : 차량 등록 버튼
            // ============================================================

            Container(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: AppColors.border),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading ||
                      loadError != null ||
                      isSaving
                      ? null
                      : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.border,
                    disabledForegroundColor: AppColors.textGrey,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isSaving)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      else
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.gold.withOpacity(0.18),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: AppColors.goldLight,
                            size: 19,
                          ),
                        ),
                      const SizedBox(width: 9),
                      Text(
                        isSaving ? '등록 중...' : '차량 등록하기',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
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
    );
  }

  // ============================================================
  // UI : 로딩 / 오류 공통 카드
  // ============================================================

  Widget _statusCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Center(child: child),
    );
  }
}