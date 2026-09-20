import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/1insa/Address.dart';

import '../../../../user/custom_text_form.dart';

class MakeTeam extends StatefulWidget {
  const MakeTeam({super.key});

  @override
  State<MakeTeam> createState() => _MakeTeamState();
}

class _MakeTeamState extends State<MakeTeam> {
  final _formKey = GlobalKey<FormState>();

  static const Color navy = Color(0xFF17233C);
  static const Color navyLight = Color(0xFF253452);
  static const Color gold = Color(0xFFC6A667);
  static const Color goldLight = Color(0xFFE6D19A);
  static const Color background = Color(0xFFF4F5F7);
  static const Color textDark = Color(0xFF202632);
  static const Color textGrey = Color(0xFF737B89);

  String image = 'asset/img/husky_Logo.png';
  String name = '';
  String position = '';

  bool _isCreating = false;

  void _tryValidation() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (isValid) {
      _formKey.currentState?.save();
    }
  }

  Future<void> _createTeam() async {
    if (_isCreating) return;

    // 입력값 검증
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    // 입력값 저장
    _formKey.currentState?.save();

    // 앞뒤 공백 제거
    name = name.trim();
    position = position.trim();

    // 빈 값 방지
    if (name.isEmpty || position.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('팀이름과 팀위치를 모두 입력해주세요.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // 생성 전 확인
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            '팀 생성',
            style: TextStyle(
              color: textDark,
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '다음 내용으로 팀을 생성하시겠습니까?',
                style: TextStyle(
                  color: textGrey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildConfirmRow(
                      icon: Icons.groups_rounded,
                      title: '팀이름',
                      value: name,
                    ),
                    const SizedBox(height: 12),
                    _buildConfirmRow(
                      icon: Icons.location_on_rounded,
                      title: '팀위치',
                      value: position,
                    ),
                  ],
                ),
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text(
                '취소',
                style: TextStyle(
                  color: textGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: navy,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 11,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text(
                '생성하기',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    setState(() {
      _isCreating = true;
    });

    try {
      final String documentId =
          FirebaseFirestore.instance.collection(INSA).doc().id;

      await FirebaseFirestore.instance
          .collection(INSA)
          .doc(documentId)
          .set({
        'image': image,
        'name': name,
        'position': position,
        'createdAt': FieldValue.serverTimestamp(),
        'docId': documentId,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('팀이 생성되었습니다.'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isCreating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('팀 생성에 실패했습니다. 잠시 후 다시 시도해주세요.'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      debugPrint('팀 생성 오류: $e');
    }
  }

  Widget _buildConfirmRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: navy.withOpacity(0.08),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(
            icon,
            color: navy,
            size: 19,
          ),
        ),
        const SizedBox(width: 11),
        Text(
          '$title  ',
          style: const TextStyle(
            color: textGrey,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        ),
        Expanded(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: textDark,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputTitle({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: navy,
          size: 19,
        ),
        const SizedBox(width: 7),
        Text(
          title,
          style: const TextStyle(
            color: textDark,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: navy,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
          onPressed: _isCreating
              ? null
              : () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          '팀 만들기',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상단 안내 카드
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        navy,
                        navyLight,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: gold.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: gold.withOpacity(0.45),
                          ),
                        ),
                        child: const Icon(
                          Icons.groups_rounded,
                          color: goldLight,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '새로운 팀 만들기',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '팀 이름과 위치를 입력해주세요.',
                              style: TextStyle(
                                color: Color(0xFFD4D9E2),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                const Text(
                  '팀 정보',
                  style: TextStyle(
                    color: textDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 12),

                // 팀이름
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color(0xFFE2E5EA),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInputTitle(
                        icon: Icons.groups_rounded,
                        title: '팀이름',
                      ),
                      const SizedBox(height: 3),
                      CustomTextForm(
                        key: const ValueKey(1),
                        onSaved: (val) {
                          name = val ?? '';
                        },
                        hintText: '팀이름을 입력해주세요',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // 팀위치
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color(0xFFE2E5EA),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInputTitle(
                        icon: Icons.location_on_rounded,
                        title: '팀위치',
                      ),
                      const SizedBox(height: 3),
                      CustomTextForm(
                        key: const ValueKey(2),
                        onSaved: (val) {
                          position = val ?? '';
                        },
                        hintText: '팀위치를 입력해주세요',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // 버튼
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: textGrey,
                            side: const BorderSide(
                              color: Color(0xFFD9DDE4),
                            ),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: _isCreating
                              ? null
                              : () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            '돌아가기',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: navy,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor:
                            navy.withOpacity(0.5),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: _isCreating ? null : _createTeam,
                          child: _isCreating
                              ? const SizedBox(
                            width: 21,
                            height: 21,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.3,
                              valueColor:
                              AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                              : const Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_rounded,
                                size: 20,
                              ),
                              SizedBox(width: 5),
                              Text(
                                '팀 생성',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}