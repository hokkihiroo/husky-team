import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:team_husky/1insa/Address.dart';
import 'package:team_husky/layout/default_layout.dart';
import 'package:team_husky/user/birthDay.dart';
import 'package:team_husky/user/custom_text_form.dart';
import 'package:team_husky/user/phoneInput.dart';
import 'package:team_husky/user/address_SearchPage.dart';
import 'package:team_husky/user/user_auth.dart';

class UserResume extends StatefulWidget {
  const UserResume({super.key});

  @override
  State<UserResume> createState() => _UserResumeState();
}

class _UserResumeState extends State<UserResume> {
  final _formKey = GlobalKey<FormState>();

  // ============================================================
  // [기존 기능 유지]
  // 기존에 사용하던 기본 이미지 변수
  // ============================================================
  String image = 'asset/img/face.png';

  final TextEditingController _phoneController =
  TextEditingController();

  final TextEditingController _birthDayController =
  TextEditingController();

  // ============================================================
  // [기존 기능 유지]
  // 주소는 SearchPage에서 검색한 값을 address 변수에 저장하기 때문에
  // 기존 _addressController는 실제로 사용하지 않음.
  // ============================================================

  // ============================================================
  // [기존 데이터 변수 유지]
  // Firestore에 저장되는 데이터 구조와 동일하게 유지
  // ============================================================
  String email = '';
  String password = '';
  String name = '';
  String birthDay = '';
  String phoneNumber = '';
  String detailAddress = '';
  String address = '';
  String career = '';
  String hobby = '';
  String footSize = '';
  String tShirtSize = '';
  String pantsSize = '';
  String cm = '';
  String kg = '';
  int levelNumber = 0;

  String bank = '';
  String bankNum = '';
  String personNum = '';
  String? school;
  String mom = '';
  String relation = '';

  File? pickedImage;

  // ============================================================
  // [기능 수정]
  // 제출 버튼을 여러 번 눌렀을 때 Firebase 회원가입이
  // 중복 실행되는 것을 방지
  // ============================================================
  bool _isSubmitting = false;

  // ============================================================
  // [기존 기능 유지]
  // 학력 선택 목록
  // ============================================================
  final List<String> schoolOptions = [
    '고등학교 졸업',
    '전문대 졸업',
    '전문대 휴학',
    '전문대 자퇴',
    '전문대 재학',
    '4년제 졸업',
    '4년제 휴학',
    '4년제 자퇴',
    '4년제 재학',
  ];

  // ============================================================
  // [디자인 수정]
  // UserResume 전용 색상
  // ============================================================
  static const Color navy = Color(0xFF17233C);
  static const Color navyLight = Color(0xFF253452);
  static const Color gold = Color(0xFFC6A667);
  static const Color goldLight = Color(0xFFE6D19A);
  static const Color background = Color(0xFFF3F1EC);
  static const Color textDark = Color(0xFF202632);
  static const Color textGrey = Color(0xFF6D7480);

  @override
  void dispose() {
    _phoneController.dispose();
    _birthDayController.dispose();
    super.dispose();
  }

  // ============================================================
  // [기존 기능 유지 + 디자인 보완]
  // 사진 선택
  // ============================================================
  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();

    final pickedImageFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (!mounted) return;

    if (pickedImageFile != null) {
      setState(() {
        pickedImage = File(pickedImageFile.path);
      });

      _showMessage('사진이 등록되었습니다.');
    } else {
      _showMessage('사진 등록을 취소했습니다.');
    }
  }

  // ============================================================
  // [디자인 수정]
  // 공통 메시지 표시
  // ============================================================
  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
  }

  // ============================================================
  // [기능 수정]
  // 기존 levelNumber 조회 방식은
  //
  // doc['levelNumber'] as int
  //
  // 로 되어 있어서 값이 없거나 타입이 다르면 오류가 발생할 수 있음.
  //
  // 기존 데이터 구조는 그대로 유지하면서
  // 숫자만 안전하게 읽도록 수정.
  // ============================================================
  Future<int> _getHighestLevel() async {
    final QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance
        .collection(INSA)
        .doc(BOSNA)
        .collection(LIST)
        .get();

    int highestLevel = 0;

    for (final doc in querySnapshot.docs) {
      final data = doc.data();

      if (data is Map<String, dynamic>) {
        final value = data['levelNumber'];

        if (value is int) {
          if (value > highestLevel) {
            highestLevel = value;
          }
        } else if (value is num) {
          if (value.toInt() > highestLevel) {
            highestLevel = value.toInt();
          }
        }
      }
    }

    return highestLevel;
  }

  // ============================================================
  // [디자인 수정]
//  섹션 제목
  // ============================================================
  Widget _sectionTitle({
    required IconData icon,
    required String title,
    String? subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 4,
        bottom: 14,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: navy,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: goldLight,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: textDark,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: textGrey,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // [디자인 수정]
  // 입력 영역을 카드 형태로 묶기 위한 공통 위젯
  // ============================================================
  Widget _sectionCard({
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2E0DA),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.055),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: child,
    );
  }

  // ============================================================
  // [디자인 수정]
//  입력창 사이 간격
  // ============================================================
  Widget _fieldSpace() {
    return const SizedBox(height: 18);
  }

  // ============================================================
  // [디자인 수정]
  // 상단 헤더
  // ============================================================
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            navy,
            navyLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: navy.withOpacity(0.22),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: gold.withOpacity(0.16),
              borderRadius: BorderRadius.circular(17),
              border: Border.all(
                color: gold.withOpacity(0.7),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.badge_outlined,
              color: goldLight,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '직원 이력서 작성',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '입사에 필요한 정보를 정확하게 입력해주세요.',
                  style: TextStyle(
                    color: Color(0xFFD7DCE5),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // [디자인 수정]
  // 안내문
  // ============================================================
  Widget _buildNotice() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: gold.withOpacity(0.55),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            color: Color(0xFF9B7935),
            size: 21,
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '작성 전 확인해주세요',
                  style: TextStyle(
                    color: Color(0xFF6F5520),
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '중복 가입은 예고없이 삭제될 수 있습니다.\n'
                      '사진과 개인정보는 정확하게 입력해주세요.',
                  style: TextStyle(
                    color: Color(0xFF806B42),
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // [디자인 수정]
  // 프로필 사진 등록 영역
  // ============================================================
  Widget _buildProfileImageSection() {
    return _sectionCard(
      child: Column(
        children: [
          Row(
            children: [
              // 프로필 이미지
              Container(
                width: 94,
                height: 94,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      gold,
                      goldLight,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: gold.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(3),
                  child: ClipOval(
                    child: pickedImage != null
                        ? Image.file(
                      pickedImage!,
                      fit: BoxFit.cover,
                    )
                        : Container(
                      color: const Color(0xFFF0F1F3),
                      child: const Icon(
                        Icons.person_outline,
                        color: Color(0xFF9DA3AD),
                        size: 44,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 18),

              // 사진 설명 + 버튼
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '프로필 사진',
                      style: TextStyle(
                        color: textDark,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      pickedImage == null
                          ? '아직 사진이 등록되지 않았습니다.'
                          : '사진이 정상적으로 등록되었습니다.',
                      style: TextStyle(
                        color: pickedImage == null
                            ? textGrey
                            : const Color(0xFF667F58),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 42,
                      child: ElevatedButton.icon(
                        onPressed: _pickImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: navy,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(
                          Icons.photo_camera_outlined,
                          size: 18,
                        ),
                        label: const Text(
                          '사진 선택',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 11,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFB1842F),
                  size: 18,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '얼굴이 60% 이상 보이는 사진을 등록해주세요. 사진은 필수입니다.',
                    style: TextStyle(
                      color: Color(0xFF67645E),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // [기능 수정]
 // 실제 이력서 제출 처리
  //
  // 기존 Firebase 저장 구조는 그대로 유지.
  // ============================================================
  Future<void> _submitResume() async {
    // ------------------------------------------------------------
    // [기능 수정]
    // 제출 버튼 중복 클릭 방지
    // ------------------------------------------------------------
    if (_isSubmitting) {
      return;
    }

    // ------------------------------------------------------------
    // [기능 수정]
    // 사진 필수 확인
    // ------------------------------------------------------------
    if (pickedImage == null) {
      _showMessage('프로필 사진을 등록해주세요.');
      return;
    }

    // ------------------------------------------------------------
    // [기능 수정]
    // 주소 필수 확인
    // ------------------------------------------------------------
    if (address.trim().isEmpty) {
      _showMessage('주소를 검색해서 등록해주세요.');
      return;
    }

    // ------------------------------------------------------------
    // [기능 수정]
    // Form validation 실패 시 Firebase 작업을 진행하지 않음.
    //
    // 원본은 _tryValidation() 이후에도 Firebase 작업을 계속했기 때문에
    // 필수 입력이 잘못되어도 회원가입을 시도할 수 있었음.
    // ------------------------------------------------------------
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      _showMessage('입력 내용을 다시 확인해주세요.');
      return;
    }

    // ------------------------------------------------------------
    // [기존 기능 유지]
    // 각 FormField의 onSaved 실행
    // ------------------------------------------------------------
    _formKey.currentState?.save();

    if (!mounted) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      // ==========================================================
      // [기능 수정]
      // 조직도 최고 levelNumber 안전하게 조회
      // ==========================================================
      final highestLevel = await _getHighestLevel();

      levelNumber = highestLevel;

      // ==========================================================
      // [기존 기능 유지]
      // Firebase Auth 회원가입
      // ==========================================================
      final newUser =
      await AUTH.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final newUid = newUser.user!.uid;

      // ==========================================================
      // [기존 기능 유지]
      // 기존 Storage 경로 그대로 유지
      //
      // mypicture/{uid}.png
      // ==========================================================
      final refImage = FirebaseStorage.instance
          .ref()
          .child('mypicture')
          .child('$newUid.png');

      await refImage.putFile(pickedImage!);

      final picUrl = await refImage.getDownloadURL();

      // ==========================================================
      // [기존 기능 유지]
      // user/{uid} 저장
      //
      // 기존 Firestore 필드명과 구조를 그대로 유지
      // ==========================================================
      await FirebaseFirestore.instance
          .collection(USER)
          .doc(newUid)
          .set({
        'image': image,
        'picUrl': picUrl,
        'email': email,
        'name': name,
        'birthDay': birthDay,
        'phoneNumber': phoneNumber,
        'detailAddress': detailAddress,
        'address': address,
        'career': career,
        'hobby': hobby,
        'footSize': footSize,
        'tShirtSize': tShirtSize,
        'pantsSize': pantsSize,
        'cm': cm,
        'kg': kg,
        'bank': bank,
        'bankNum': bankNum,
        'personNum': personNum,
        'school': school,
        'mom': mom,
        'relation': relation,

        // --------------------------------------------------------
        // [기존 기능 유지]
        // 기존 등급 / 팀 구조 그대로 유지
        // --------------------------------------------------------
        'grade': 0,
        'teamId': BOSNA,

        // --------------------------------------------------------
        // [기존 기능 유지]
        // 입사일
        // --------------------------------------------------------
        'enterDay': FieldValue.serverTimestamp(),
      });

      // ==========================================================
      // [기존 기능 유지]
      // 조직도 데이터 저장
      //
      // INSA / BOSNA / LIST / uid
      // 기존 구조 그대로 유지
      // ==========================================================
      await FirebaseFirestore.instance
          .collection(INSA)
          .doc(BOSNA)
          .collection(LIST)
          .doc(newUid)
          .set({
        'image': image,
        'name': name,
        'grade': '사원',
        'position': '드라이버',
        'enterDay': FieldValue.serverTimestamp(),
        'picUrl': picUrl,

        // --------------------------------------------------------
        // [기존 기능 유지]
        // 기존처럼 가장 높은 번호 + 1
        // --------------------------------------------------------
        'levelNumber': levelNumber + 1,
      });

      // ==========================================================
      // [기능 수정]
      // 성공했을 때만 현재 화면을 닫음.
      // ==========================================================
      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });

      _showMessage('직원 이력서가 정상적으로 등록되었습니다.');

      // 메시지가 잠깐 보인 후 이전 화면으로 이동
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // ==========================================================
      // [기능 수정]
      // Firebase Auth 오류를 사용자가 이해할 수 있는 메시지로 표시
      // 오류 발생 시 현재 화면은 닫지 않음.
      // ==========================================================

      String message;

      switch (e.code) {
        case 'email-already-in-use':
          message = '이미 가입되어 있는 이메일입니다.';
          break;

        case 'invalid-email':
          message = '이메일 형식이 올바르지 않습니다.';
          break;

        case 'weak-password':
          message = '비밀번호가 너무 약합니다. 6자 이상 입력해주세요.';
          break;

        case 'operation-not-allowed':
          message = '현재 이메일 회원가입을 사용할 수 없습니다.';
          break;

        default:
          message = '회원가입 중 오류가 발생했습니다.\n${e.message ?? e.code}';
          break;
      }

      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });

      _showMessage(message);
    } on FirebaseException catch (e) {
      // ==========================================================
      // [기능 수정]
      // Storage / Firestore 오류
      // 현재 화면 유지
      // ==========================================================

      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });

      _showMessage(
        '데이터 저장 중 오류가 발생했습니다.\n${e.message ?? e.code}',
      );
    } catch (e) {
      // ==========================================================
      // [기능 수정]
      // 기타 오류
      // ==========================================================

      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });

      _showMessage(
        '등록 중 오류가 발생했습니다.\n$e',
      );
    }
  }

  // ============================================================
  // [디자인 수정]
  // 주소 검색 카드
  // ============================================================
  Widget _buildAddressSection() {
    return _sectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  '실거주 주소',
                  style: TextStyle(
                    color: textDark,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SizedBox(
                height: 40,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SearchPage(),
                      ),
                    );

                    if (!mounted) return;

                    if (result != null && result is String) {
                      setState(() {
                        address = result;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: navy,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  icon: const Icon(
                    Icons.search,
                    size: 17,
                  ),
                  label: const Text(
                    '주소 검색',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 13),

          // --------------------------------------------------------
          // [디자인 수정]
          // 검색된 주소 표시
          // --------------------------------------------------------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F7F8),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: const Color(0xFFE2E4E7),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: address.isEmpty ? textGrey : gold,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    address.isEmpty
                        ? '주소 검색 버튼을 눌러 주소를 선택해주세요.'
                        : address,
                    style: TextStyle(
                      color: address.isEmpty
                          ? textGrey
                          : textDark,
                      fontSize: 13,
                      fontWeight: address.isEmpty
                          ? FontWeight.w500
                          : FontWeight.w700,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          CustomTextForm(
            key: const ValueKey(6),
            onSaved: (val) {
              detailAddress = val ?? '';
            },
            hintText: '상세주소',
          ),

          const SizedBox(height: 10),

          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline,
                size: 15,
                color: textGrey,
              ),
              SizedBox(width: 5),
              Expanded(
                child: Text(
                  '주소는 실제 거주하고 있는 주소로 입력해주세요.',
                  style: TextStyle(
                    color: textGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // [디자인 수정]
//  제출 버튼
  // ============================================================
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitResume,
        style: ElevatedButton.styleFrom(
          backgroundColor: navy,
          disabledBackgroundColor: navy.withOpacity(0.55),
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: navy.withOpacity(0.25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isSubmitting
            ? const SizedBox(
          width: 23,
          height: 23,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(
              goldLight,
            ),
          ),
        )
            : const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 21,
            ),
            SizedBox(width: 8),
            Text(
              '이력서 제출',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // [디자인 수정]
//  돌아가기 버튼
  // ============================================================
  Widget _buildBackButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: _isSubmitting
            ? null
            : () {
          Navigator.pop(context);
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: navy,
          side: BorderSide(
            color: navy.withOpacity(0.35),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        icon: const Icon(
          Icons.arrow_back,
          size: 18,
        ),
        label: const Text(
          '돌아가기',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      // ==========================================================
      // [디자인 수정]
      // DefaultLayout의 AppBar 글씨가 현재 검정색으로 설정되어 있기 때문에
      // AppBar는 밝은 색으로 설정.
      // 실제 페이지 디자인은 아래 헤더의 네이비를 사용.
      // ==========================================================
      backgroundColor: background,
      title: '직원이력',

      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },

        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              12,
              12,
              12,
              30,
            ),

            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==================================================
                  // [디자인 수정]
                  // 상단 헤더
                  // ==================================================
                  _buildHeader(),

                  const SizedBox(height: 14),

                  // ==================================================
                  // [디자인 수정]
                  // 안내문
                  // ==================================================
                  _buildNotice(),

                  const SizedBox(height: 24),

                  // ==================================================
                  // [디자인 수정]
                  // 사진 영역
                  // ==================================================
                  _sectionTitle(
                    icon: Icons.account_circle_outlined,
                    title: '프로필 사진',
                    subtitle: '직원 확인을 위한 사진을 등록해주세요.',
                  ),

                  _buildProfileImageSection(),

                  const SizedBox(height: 28),

                  // ==================================================
                  // [디자인 수정]
                  // 기본 정보
                  // ==================================================
                  _sectionTitle(
                    icon: Icons.person_outline,
                    title: '기본 정보',
                    subtitle: '로그인 및 직원 기본 정보를 입력해주세요.',
                  ),

                  _sectionCard(
                    child: Column(
                      children: [
                        // ------------------------------------------------
                        // [기존 기능 유지]
                        // 이메일
                        // ------------------------------------------------
                        CustomTextForm(
                          key: const ValueKey(1),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return '이메일은 필수사항입니다.';
                            }

                            if (!RegExp(
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
                            ).hasMatch(val)) {
                              return '잘못된 이메일 형식입니다.';
                            }

                            return null;
                          },
                          onSaved: (val) {
                            email = val?.trim() ?? '';
                          },
                          hintText: '이메일',
                        ),

                        _fieldSpace(),

                        // ------------------------------------------------
                        // [기존 기능 유지]
                        // 비밀번호
                        // ------------------------------------------------
                        CustomTextForm(
                          key: const ValueKey(2),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return '비밀번호는 필수사항입니다.';
                            }

                            if (val.length < 6) {
                              return '6자 이상 입력해주세요!';
                            }

                            return null;
                          },
                          obscureText: true,
                          onSaved: (val) {
                            password = val ?? '';
                          },
                          hintText: '비밀번호',
                        ),

                        _fieldSpace(),

                        // ------------------------------------------------
                        // [기존 기능 유지]
                        // 이름
                        // ------------------------------------------------
                        CustomTextForm(
                          key: const ValueKey(3),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return '이름은 필수사항입니다.';
                            }

                            if (val.length < 2) {
                              return '이름은 두글자 이상 입력 해주셔야합니다.';
                            }

                            return null;
                          },
                          onSaved: (val) {
                            name = val ?? '';
                          },
                          hintText: '이름',
                          maxLength: 3,
                        ),

                        _fieldSpace(),

                        // ------------------------------------------------
                        // [기존 기능 유지]
                        // 전화번호
                        // ------------------------------------------------
                        PhoneNumberInput(
                          phoneController: _phoneController,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return '전화번호는 필수사항입니다.';
                            }

                            if (val.length != 13) {
                              return '전화번호는 010-1234-5678 형식으로 입력해주세요.';
                            }

                            if (!RegExp(
                              r'^010-\d{4}-\d{4}$',
                            ).hasMatch(val)) {
                              return '유효한 전화번호 형식이 아닙니다.';
                            }

                            return null;
                          },
                          onSaved: (val) {
                            phoneNumber = val ?? '';
                          },
                        ),

                        _fieldSpace(),

                        // ------------------------------------------------
                        // [기존 기능 유지]
                        // 생년월일
                        // ------------------------------------------------
                        CustomDatePicker(
                          dateController: _birthDayController,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return '생년월일을 입력바랍니다.';
                            }

                            return null;
                          },
                          onSaved: (val) {
                            birthDay = val ?? '';
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ==================================================
                  // [디자인 수정]
                  // 주소
                  // ==================================================
                  _sectionTitle(
                    icon: Icons.location_on_outlined,
                    title: '주소',
                    subtitle: '실제 거주 주소를 입력해주세요.',
                  ),

                  _buildAddressSection(),

                  const SizedBox(height: 28),

                  // ==================================================
                  // [디자인 수정]
                  // 개인 정보
                  // ==================================================
                  _sectionTitle(
                    icon: Icons.directions_car_outlined,
                    title: '개인 정보',
                    subtitle: '운전 및 신체 정보를 입력해주세요.',
                  ),

                  _sectionCard(
                    child: Column(
                      children: [
                        // ------------------------------------------------
                        // [기존 기능 유지]
                        // 운전경력
                        // ------------------------------------------------
                        CustomTextForm(
                          key: const ValueKey(8),
                          onSaved: (val) {
                            career = val ?? '';
                          },
                          hintText: '운전경력 예) 5년',
                        ),

                        _fieldSpace(),

                        // ------------------------------------------------
                        // [기존 기능 유지]
                        // 취미
                        // ------------------------------------------------
                        CustomTextForm(
                          key: const ValueKey(9),
                          onSaved: (val) {
                            hobby = val ?? '';
                          },
                          hintText: '취미',
                        ),

                        const SizedBox(height: 16),

                        // ------------------------------------------------
                        // [디자인 수정]
                        // 숫자 입력 안내
                        // ------------------------------------------------
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 11,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F7F8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.straighten,
                                color: gold,
                                size: 18,
                              ),
                              SizedBox(width: 7),
                              Text(
                                '신체정보는 숫자만 입력해주세요. 단위는 입력하지 않습니다.',
                                style: TextStyle(
                                  color: textGrey,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ------------------------------------------------
                        // [기존 기능 유지]
                        // 발사이즈
                        // ------------------------------------------------
                        CustomTextForm(
                          key: const ValueKey(10),
                          onSaved: (val) {
                            footSize = val ?? '';
                          },
                          hintText: '발사이즈 예) 260',
                        ),

                        _fieldSpace(),

                        // ------------------------------------------------
                        // [기존 기능 유지]
                        // 상의
                        // ------------------------------------------------
                        CustomTextForm(
                          key: const ValueKey(11),
                          onSaved: (val) {
                            tShirtSize = val ?? '';
                          },
                          hintText: '상의사이즈 예) 100',
                        ),

                        _fieldSpace(),

                        // ------------------------------------------------
                        // [기존 기능 유지]
                        // 하의
                        // ------------------------------------------------
                        CustomTextForm(
                          key: const ValueKey(12),
                          onSaved: (val) {
                            pantsSize = val ?? '';
                          },
                          hintText: '하의사이즈 예) 32',
                        ),

                        _fieldSpace(),

                        // ------------------------------------------------
                        // [기존 기능 유지]
                        // 키
                        // ------------------------------------------------
                        CustomTextForm(
                          key: const ValueKey(13),
                          onSaved: (val) {
                            cm = val ?? '';
                          },
                          hintText: '키 예) 175',
                        ),

                        _fieldSpace(),

                        // ------------------------------------------------
                        // [기존 기능 유지]
                        // 몸무게
                        // ------------------------------------------------
                        CustomTextForm(
                          key: const ValueKey(14),
                          onSaved: (val) {
                            kg = val ?? '';
                          },
                          hintText: '몸무게 예) 70',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ==================================================
                  // [디자인 수정]
                  // 중요 정보
                  // ==================================================
                  _sectionTitle(
                    icon: Icons.lock_outline,
                    title: '중요 정보',
                    subtitle: '정확한 양식을 지켜 입력해주세요.',
                  ),

                  _sectionCard(
                    child: Column(
                      children: [
                        // ------------------------------------------------
                        // [디자인 수정]
                        // 중요정보 안내
                        // ------------------------------------------------
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF8E8),
                            borderRadius: BorderRadius.circular(13),
                            border: Border.all(
                              color: gold.withOpacity(0.45),
                            ),
                          ),
                          child: const Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.lock_outline,
                                color: Color(0xFF9B7935),
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '중요정보는 정확한 양식으로 입력해주세요.',
                                  style: TextStyle(
                                    color: Color(0xFF715C2D),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        // ------------------------------------------------
                        // [기존 기능 유지]
                        // 은행명
                        // ------------------------------------------------
                        CustomTextForm(
                          key: const ValueKey(15),
                          onSaved: (val) {
                            bank = val ?? '';
                          },
                          hintText: '은행명 예) 신한은행 or 하나증권 등등',
                        ),

                        _fieldSpace(),

                        // ------------------------------------------------
                        // [기존 기능 유지]
                        // 계좌번호
                        // ------------------------------------------------
                        CustomTextForm(
                          key: const ValueKey(16),
                          onSaved: (val) {
                            bankNum = val ?? '';
                          },
                          hintText: '계좌번호 예) 61512214217',
                        ),

                        _fieldSpace(),

                        // ------------------------------------------------
                        // [기존 기능 유지]
                        // 주민번호
                        // ------------------------------------------------
                        CustomTextForm(
                          key: const ValueKey(17),
                          onSaved: (val) {
                            personNum = val ?? '';
                          },
                          hintText: '주민번호 예) 881214-1234567',
                        ),

                        _fieldSpace(),

                        // ------------------------------------------------
                        // [기존 기능 유지]
                        // 학력
                        // ------------------------------------------------
                        DropdownButtonFormField<String>(
                          key: const ValueKey(18),
                          value: school,
                          isExpanded: true,
                          decoration: InputDecoration(
                            hintText: '학력 선택',
                            filled: true,
                            fillColor: const Color(0xFFF8F8F7),
                            contentPadding:
                            const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 17,
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(35),
                              borderSide: const BorderSide(
                                color: Color(0xFFD8D9DB),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(35),
                              borderSide: const BorderSide(
                                color: Color(0xFFD8D9DB),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(35),
                              borderSide: const BorderSide(
                                color: navy,
                                width: 1.4,
                              ),
                            ),
                          ),
                          items: schoolOptions.map((option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(
                                option,
                                style: const TextStyle(
                                  color: textDark,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              school = val;
                            });
                          },
                          onSaved: (val) {
                            school = val;
                          },
                        ),

                        _fieldSpace(),

                        // ------------------------------------------------
                        // [기존 기능 유지]
                        // 비상연락망
                        // ------------------------------------------------
                        CustomTextForm(
                          key: const ValueKey(19),
                          onSaved: (val) {
                            mom = val ?? '';
                          },
                          hintText: '비상연락망 예) 010-1234-1234',
                        ),

                        _fieldSpace(),

                        // ------------------------------------------------
                        // [기존 기능 유지]
                        // 관계
                        // ------------------------------------------------
                        CustomTextForm(
                          key: const ValueKey(20),
                          onSaved: (val) {
                            relation = val ?? '';
                          },
                          hintText: '관계 예) 아버지 or 어머니 기타등등',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ==================================================
                  // [디자인 수정]
                  // 하단 버튼
                  // ==================================================
                  _buildBackButton(),

                  const SizedBox(height: 12),

                  _buildSubmitButton(),

                  const SizedBox(height: 18),

                  // ==================================================
                  // [디자인 수정]
                  // 하단 안내
                  // ==================================================
                  const Center(
                    child: Text(
                      '입력하신 정보는 직원 등록 및 관리 목적으로 사용됩니다.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textGrey,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}