import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'team1_adress_const.dart';

class Team1LocationName extends StatefulWidget {
  const Team1LocationName({super.key});

  @override
  State<Team1LocationName> createState() => _Team1LocationnameState();
}

class _Team1LocationnameState extends State<Team1LocationName> {
  Future<void> _editLocationName(
    String fieldName,
    String currentValue,
  ) async {
    await showDialog(
      context: context,
      builder: (context) {
        return _LocationEditDialog(
          fieldName: fieldName,
          currentValue: currentValue,
        );
      },
    );
  }

  Widget _buildLocationName(
      String name, {
        VoidCallback? onTap,
      }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          height: 35,
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                name,
                maxLines: 1,
                softWrap: false,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.doc(parkLocation).snapshots(),
      builder: (context, snapshot) {
        // 로딩 중
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        }

        // 문서가 없거나 에러 발생
        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
          return const SizedBox();
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Row(
            children: [
              // 1열: 로터리
              _buildLocationName(
                data['a'] ?? '로터',
              ),

              // 2열: 외벽
              _buildLocationName(
                data['b'] ?? '외벽',
                onTap: () {
                  _editLocationName('b', data['b'] ?? '외벽');
                },
              ),

              // 3열: 광장
              _buildLocationName(
                data['c'] ?? '광장',
                onTap: () {
                  _editLocationName('c', data['c'] ?? '광장');
                },
              ),

              // 4열: 문앞
              _buildLocationName(
                data['d'] ?? '문앞',
                onTap: () {
                  _editLocationName('d', data['d'] ?? '문앞');
                },
              ),

              // 5열: 신사
              _buildLocationName(
                data['e'] ?? '신사',
              ),
            ],
          ),
        );
      },
    );
  }
}

// 위치명 수정 다이얼로그
class _LocationEditDialog extends StatefulWidget {
  final String fieldName;
  final String currentValue;

  const _LocationEditDialog({
    required this.fieldName,
    required this.currentValue,
  });

  @override
  State<_LocationEditDialog> createState() => _LocationEditDialogState();
}

class _LocationEditDialogState extends State<_LocationEditDialog> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(
      text: widget.currentValue,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<bool> _save() async {
    final newValue = controller.text.trim();

    // 정확히 2글자가 아니면 저장하지 않음
    if (newValue.characters.length != 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('위치명은 반드시 두 글자로 입력해주세요.'),
        ),
      );

      return false;
    }

    await FirebaseFirestore.instance.doc(parkLocation).update({
      widget.fieldName: newValue,
    });

    if (mounted) {
      Navigator.pop(context);
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      contentPadding: const EdgeInsets.fromLTRB(
        24,
        26,
        24,
        18,
      ),

      // =========================
      // 제목
      // =========================
      title: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFFFFC107).withOpacity(0.14),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.edit_rounded,
              color: Color(0xFFFFB900),
              size: 27,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            '위치명 수정',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF202020),
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            '위치명을 두 글자로 입력해주세요.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
        ],
      ),

      // =========================
      // 입력창
      // =========================
      content: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 2,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 4,
          ),
          inputFormatters: [
            LengthLimitingTextInputFormatter(2),
          ],
          decoration: InputDecoration(
            hintText: '두 글자',
            hintStyle: const TextStyle(
              color: Color(0xFFBDBDBD),
              fontSize: 16,
              letterSpacing: 1,
            ),
            counterText: '',
            filled: true,
            fillColor: const Color(0xFFF7F7F7),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
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
      ),

      // =========================
      // 버튼
      // =========================
      actionsPadding: const EdgeInsets.fromLTRB(
        24,
        0,
        24,
        6,
      ),

      actions: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 46,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF666666),
                    side: const BorderSide(
                      color: Color(0xFFE0E0E0),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  child: const Text(
                    '취소',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 46,
                child: ElevatedButton(
                  onPressed: () async {
                    final bool saved = await _save();

                    if (!saved) return;

                    if (!context.mounted) return;

                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          surfaceTintColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          contentPadding: const EdgeInsets.fromLTRB(
                            24,
                            28,
                            24,
                            18,
                          ),
                          title: Column(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFFFFC107).withOpacity(0.14),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check_rounded,
                                  color: Color(0xFFFFB900),
                                  size: 31,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                '저장 완료',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF202020),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                '뒤로가기 후 다시 들어오셔야\n'
                                '"이동" 부분도 수정됩니다.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.6,
                                  color: Color(0xFF666666),
                                ),
                              ),
                            ],
                          ),
                          actionsPadding: const EdgeInsets.fromLTRB(
                            24,
                            4,
                            24,
                            6,
                          ),
                          actions: [
                            SizedBox(
                              width: double.infinity,
                              height: 46,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFFC107),
                                  foregroundColor: Colors.black,
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
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC107),
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  child: const Text(
                    '저장',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
