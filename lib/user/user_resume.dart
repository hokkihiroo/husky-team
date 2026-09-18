import 'dart:io';

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
  // 기본 데이터
  // ============================================================

  String image = 'asset/img/face.png';

  final TextEditingController _phoneController =
  TextEditingController();

  final TextEditingController _birthDayController =
  TextEditingController();

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

  bool _isSubmitting = false;

  // ============================================================
  // 학력 선택
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
  // 디자인 색상
  // ============================================================

  static const Color navy = Color(0xFF17233C);
  static const Color navyLight = Color(0xFF253452);

  static const Color gold = Color(0xFFC6A667);
  static const Color goldLight = Color(0xFFE6D19A);

  static const Color background = Color(0xFFF3F1EC);

  static const Color textDark = Color(0xFF202632);
  static const Color textGrey = Color(0xFF6D7480);

  // ============================================================
  // 모든 입력창 공통 필수 입력 검사
  // ============================================================

  String? _requiredValidator(
      String? value,
      String fieldName,
      ) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName을(를) 입력해주세요.';
    }

    return null;
  }

  // ============================================================
  // 사진 선택
  // ============================================================

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (pickedFile == null) {
      return;
    }

    setState(() {
      pickedImage = File(pickedFile.path);
    });
  }

  // ============================================================
  // 안내 메시지
  // ============================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // 가장 높은 levelNumber 가져오기
  // ============================================================

  Future<int> _getHighestLevel() async {
    try {
      final QuerySnapshot snapshot = await FIRESTORE
          .collection(INSA)
          .doc(BOSNA)
          .collection(LIST)
          .get();

      int highest = 0;

      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        final dynamic value = data['levelNumber'];

        if (value is int) {
          if (value > highest) {
            highest = value;
          }
        } else if (value is num) {
          if (value.toInt() > highest) {
            highest = value.toInt();
          }
        }
      }

      return highest;
    } catch (e) {
      return 0;
    }
  }

  // ============================================================
  // 섹션 제목
  // ============================================================

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 4,
        bottom: 10,
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: gold,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w900,
              color: textDark,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 섹션 카드
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
          color: const Color(0xFFE3E0D8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  // ============================================================
  // 입력창 사이 간격
  // ============================================================

  Widget _fieldSpace() {
    return const SizedBox(height: 14);
  }

  // ============================================================
  // 상단 헤더
  // ============================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
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
            color: navy.withOpacity(0.20),
            blurRadius: 15,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: gold.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: gold,
                width: 1.5,
              ),
            ),
            child: const Icon(
              Icons.badge_outlined,
              color: goldLight,
              size: 28,
            ),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '직원 이력 등록',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '모든 항목을 정확하게 입력해주세요.',
                  style: TextStyle(
                    color: Color(0xFFD9DEE8),
                    fontSize: 13,
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
  // 안내문
  // ============================================================

  Widget _buildNotice() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: goldLight,
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: gold,
            size: 22,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              '사진을 포함한 모든 항목은 필수 입력사항입니다.\n'
                  '입력하지 않은 항목이 있으면 등록할 수 없습니다.',
              style: TextStyle(
                color: textDark,
                fontSize: 13,
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 프로필 사진
  // ============================================================

  Widget _buildProfileImageSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
              border: Border.all(
                color: pickedImage == null
                    ? gold
                    : Colors.white,
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 15,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: ClipOval(
              child: pickedImage != null
                  ? Image.file(
                pickedImage!,
                fit: BoxFit.cover,
              )
                  : Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          pickedImage == null
              ? '사진을 등록해주세요.'
              : '사진이 등록되었습니다.',
          style: TextStyle(
            color: pickedImage == null
                ? Colors.redAccent
                : textGrey,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _pickImage,
          icon: const Icon(
            Icons.photo_camera_outlined,
          ),
          label: Text(
            pickedImage == null
                ? '사진 선택'
                : '사진 변경',
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: navy,
            side: const BorderSide(
              color: gold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // 주소
  // ============================================================

  Widget _buildAddressSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            final String? result =
            await Navigator.push<String>(
              context,
              MaterialPageRoute(
                builder: (context) =>  SearchPage(),
              ),
            );

            if (result != null &&
                result.trim().isNotEmpty) {
              setState(() {
                address = result;
              });
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 17,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F7F3),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: address.isEmpty
                    ? Colors.redAccent
                    : const Color(0xFFD9D5CB),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: gold,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    address.isEmpty
                        ? '주소를 검색해주세요.'
                        : address,
                    style: TextStyle(
                      color: address.isEmpty
                          ? Colors.redAccent
                          : textDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Icon(
                  Icons.search,
                  color: navy,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 14),

        CustomTextForm(
          hintText: '상세주소를 입력해주세요.',
          icon: const Icon(
            Icons.home_outlined,
          ),
          validator: (value) {
            return _requiredValidator(
              value,
              '상세주소',
            );
          },
          onSaved: (value) {
            detailAddress = value ?? '';
          },
        ),
      ],
    );
  }

  // ============================================================
  // 등록 버튼
  // ============================================================

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: _isSubmitting
            ? null
            : _submitResume,
        style: ElevatedButton.styleFrom(
          backgroundColor: navy,
          foregroundColor: Colors.white,
          disabledBackgroundColor:
          navy.withOpacity(0.5),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: _isSubmitting
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: Colors.white,
          ),
        )
            : const Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
            ),
            SizedBox(width: 8),
            Text(
              '직원 등록하기',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // 뒤로가기 버튼
  // ============================================================

  Widget _buildBackButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: _isSubmitting
            ? null
            : () {
          Navigator.pop(context);
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: navy,
          side: const BorderSide(
            color: Color(0xFFD0CCC2),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: const Text(
          '취소',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // 직원 등록
  // ============================================================

  Future<void> _submitResume() async {
    if (_isSubmitting) {
      return;
    }

    // ============================================================
    // 사진 필수 확인
    // ============================================================

    if (pickedImage == null) {
      _showMessage('프로필 사진을 등록해주세요.');
      return;
    }

    // ============================================================
    // 주소 필수 확인
    // ============================================================

    if (address.trim().isEmpty) {
      _showMessage('주소를 검색해주세요.');
      return;
    }

    // ============================================================
    // 모든 입력 항목 필수 검사
    // ============================================================

    final bool? valid =
    _formKey.currentState?.validate();

    if (valid != true) {
      _showMessage(
        '입력하지 않은 항목이 있습니다.\n'
            '빠진 항목을 확인해주세요.',
      );
      return;
    }

    // ============================================================
    // 학력 필수 검사
    // ============================================================

    if (school == null ||
        school!.trim().isEmpty) {
      _showMessage('학력을 선택해주세요.');
      return;
    }

    _formKey.currentState?.save();

    setState(() {
      _isSubmitting = true;
    });

    try {
      // ============================================================
      // 현재 가장 높은 levelNumber 확인
      // ============================================================

      final int highestLevel =
      await _getHighestLevel();

      levelNumber = highestLevel;

      // ============================================================
      // Firebase Auth 계정 생성
      // ============================================================

      final UserCredential userCredential =
      await AUTH.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final String uid =
          userCredential.user!.uid;

      // ============================================================
      // 프로필 이미지 Storage 업로드
      // ============================================================

      final Reference storageRef =
      FirebaseStorage.instance
          .ref()
          .child('mypicture')
          .child('$uid.png');

      await storageRef.putFile(
        pickedImage!,
      );

      final String picUrl =
      await storageRef.getDownloadURL();

      // ============================================================
      // user 컬렉션 저장
      // ============================================================

      await FIRESTORE
          .collection(USER)
          .doc(uid)
          .set({
        'image': image,
        'picUrl': picUrl,

        'email': email.trim(),
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

        'grade': 0,
        'teamId': BOSNA,

        'enterDay':
        FieldValue.serverTimestamp(),
      });

      // ============================================================
      // 인사 조직도 LIST 저장
      // ============================================================

      await FIRESTORE
          .collection(INSA)
          .doc(BOSNA)
          .collection(LIST)
          .doc(uid)
          .set({
        'image': image,
        'name': name,
        'grade': '사원',
        'position': '드라이버',
        'enterDay':
        FieldValue.serverTimestamp(),
        'picUrl': picUrl,

        'levelNumber':
        levelNumber + 1,
      });

      // ============================================================
      // 등록 완료
      // ============================================================

      if (!mounted) {
        return;
      }

      setState(() {
        _isSubmitting = false;
      });

      _showMessage('직원 등록이 완료되었습니다.');

      await Future.delayed(
        const Duration(milliseconds: 500),
      );

      if (mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSubmitting = false;
      });

      String message =
          '직원 등록 중 오류가 발생했습니다.';

      if (e.code == 'email-already-in-use') {
        message = '이미 사용 중인 이메일입니다.';
      } else if (e.code == 'invalid-email') {
        message = '이메일 형식이 올바르지 않습니다.';
      } else if (e.code == 'weak-password') {
        message = '비밀번호가 너무 약합니다.';
      }

      _showMessage(message);
    } on FirebaseException catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSubmitting = false;
      });

      _showMessage(
        'Firebase 오류가 발생했습니다.\n${e.message ?? ''}',
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSubmitting = false;
      });

      _showMessage(
        '직원 등록 중 오류가 발생했습니다.',
      );
    }
  }

  // ============================================================
  // 화면
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: background,
      title: '직원이력',
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            16,
            16,
            16,
            30,
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              // ==================================================
              // 헤더
              // ==================================================

              _buildHeader(),

              const SizedBox(height: 14),

              // ==================================================
              // 안내
              // ==================================================

              _buildNotice(),

              const SizedBox(height: 25),

              // ==================================================
              // 프로필 사진
              // ==================================================

              _sectionTitle('프로필 사진'),

              _sectionCard(
                child: Center(
                  child: _buildProfileImageSection(),
                ),
              ),

              const SizedBox(height: 25),

              // ==================================================
              // 기본 정보
              // ==================================================

              _sectionTitle('기본 정보'),

              _sectionCard(
                child: Column(
                  children: [
                    // 이메일
                    CustomTextForm(
                      hintText: '이메일을 입력해주세요.',
                      icon: const Icon(
                        Icons.email_outlined,
                      ),
                      validator: (value) {
                        final String? required =
                        _requiredValidator(
                          value,
                          '이메일',
                        );

                        if (required != null) {
                          return required;
                        }

                        if (!value!.contains('@')) {
                          return '올바른 이메일을 입력해주세요.';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        email = value ?? '';
                      },
                    ),

                    _fieldSpace(),

                    // 비밀번호
                    CustomTextForm(
                      hintText: '비밀번호를 입력해주세요.',
                      obscureText: true,
                      icon: const Icon(
                        Icons.lock_outline,
                      ),
                      validator: (value) {
                        final String? required =
                        _requiredValidator(
                          value,
                          '비밀번호',
                        );

                        if (required != null) {
                          return required;
                        }

                        if (value!.length < 6) {
                          return '비밀번호는 6자 이상 입력해주세요.';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        password = value ?? '';
                      },
                    ),

                    _fieldSpace(),

                    // 이름
                    CustomTextForm(
                      hintText: '이름을 입력해주세요.',
                      icon: const Icon(
                        Icons.person_outline,
                      ),
                      validator: (value) {
                        return _requiredValidator(
                          value,
                          '이름',
                        );
                      },
                      onSaved: (value) {
                        name = value ?? '';
                      },
                    ),

                    _fieldSpace(),

                    // 생년월일
                    CustomDatePicker(
                      dateController:
                      _birthDayController,
                      validator: (value) {
                        return _requiredValidator(
                          value,
                          '생년월일',
                        );
                      },
                      onSaved: (value) {
                        birthDay = value ?? '';
                      },
                    ),

                    _fieldSpace(),

                    // 전화번호
                    PhoneNumberInput(
                      phoneController:
                      _phoneController,
                      validator: (value) {
                        final String? required =
                        _requiredValidator(
                          value,
                          '전화번호',
                        );

                        if (required != null) {
                          return required;
                        }

                        final String number =
                        value!.replaceAll(
                          '-',
                          '',
                        );

                        if (number.length < 10) {
                          return '올바른 전화번호를 입력해주세요.';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        phoneNumber = value ?? '';
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ==================================================
              // 주소
              // ==================================================

              _sectionTitle('주소'),

              _sectionCard(
                child: _buildAddressSection(),
              ),

              const SizedBox(height: 25),

              // ==================================================
              // 개인 정보
              // ==================================================

              _sectionTitle('개인 정보'),

              _sectionCard(
                child: Column(
                  children: [
                    // 경력
                    CustomTextForm(
                      hintText: '경력을 입력해주세요.',
                      icon: const Icon(
                        Icons.work_outline,
                      ),
                      validator: (value) {
                        return _requiredValidator(
                          value,
                          '경력',
                        );
                      },
                      onSaved: (value) {
                        career = value ?? '';
                      },
                    ),

                    _fieldSpace(),

                    // 취미
                    CustomTextForm(
                      hintText: '취미를 입력해주세요.',
                      icon: const Icon(
                        Icons.sports_esports_outlined,
                      ),
                      validator: (value) {
                        return _requiredValidator(
                          value,
                          '취미',
                        );
                      },
                      onSaved: (value) {
                        hobby = value ?? '';
                      },
                    ),

                    _fieldSpace(),

                    // 신발 사이즈
                    CustomTextForm(
                      hintText: '신발 사이즈를 입력해주세요.',
                      icon: const Icon(
                        Icons.shopping_bag_outlined,
                      ),
                      validator: (value) {
                        return _requiredValidator(
                          value,
                          '신발 사이즈',
                        );
                      },
                      onSaved: (value) {
                        footSize = value ?? '';
                      },
                    ),

                    _fieldSpace(),

                    // 티셔츠 사이즈
                    CustomTextForm(
                      hintText: '티셔츠 사이즈를 입력해주세요.',
                      icon: const Icon(
                        Icons.checkroom_outlined,
                      ),
                      validator: (value) {
                        return _requiredValidator(
                          value,
                          '티셔츠 사이즈',
                        );
                      },
                      onSaved: (value) {
                        tShirtSize = value ?? '';
                      },
                    ),

                    _fieldSpace(),

                    // 바지 사이즈
                    CustomTextForm(
                      hintText: '바지 사이즈를 입력해주세요.',
                      icon: const Icon(
                        Icons.checkroom,
                      ),
                      validator: (value) {
                        return _requiredValidator(
                          value,
                          '바지 사이즈',
                        );
                      },
                      onSaved: (value) {
                        pantsSize = value ?? '';
                      },
                    ),

                    _fieldSpace(),

                    // 키
                    CustomTextForm(
                      hintText: '키를 입력해주세요. 예) 175',
                      icon: const Icon(
                        Icons.height,
                      ),
                      validator: (value) {
                        return _requiredValidator(
                          value,
                          '키',
                        );
                      },
                      onSaved: (value) {
                        cm = value ?? '';
                      },
                    ),

                    _fieldSpace(),

                    // 몸무게
                    CustomTextForm(
                      hintText: '몸무게를 입력해주세요. 예) 70',
                      icon: const Icon(
                        Icons.monitor_weight_outlined,
                      ),
                      validator: (value) {
                        return _requiredValidator(
                          value,
                          '몸무게',
                        );
                      },
                      onSaved: (value) {
                        kg = value ?? '';
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ==================================================
              // 중요 정보
              // ==================================================

              _sectionTitle('중요 정보'),

              _sectionCard(
                child: Column(
                  children: [
                    // 은행
                    CustomTextForm(
                      hintText: '은행명을 입력해주세요.',
                      icon: const Icon(
                        Icons.account_balance_outlined,
                      ),
                      validator: (value) {
                        return _requiredValidator(
                          value,
                          '은행명',
                        );
                      },
                      onSaved: (value) {
                        bank = value ?? '';
                      },
                    ),

                    _fieldSpace(),

                    // 계좌번호
                    CustomTextForm(
                      hintText: '계좌번호를 입력해주세요.',
                      icon: const Icon(
                        Icons.account_balance_wallet_outlined,
                      ),
                      validator: (value) {
                        return _requiredValidator(
                          value,
                          '계좌번호',
                        );
                      },
                      onSaved: (value) {
                        bankNum = value ?? '';
                      },
                    ),

                    _fieldSpace(),

                    // 주민번호
                    CustomTextForm(
                      hintText: '주민등록번호를 입력해주세요.',
                      obscureText: true,
                      icon: const Icon(
                        Icons.badge_outlined,
                      ),
                      validator: (value) {
                        return _requiredValidator(
                          value,
                          '주민등록번호',
                        );
                      },
                      onSaved: (value) {
                        personNum = value ?? '';
                      },
                    ),

                    _fieldSpace(),

                    // 학력
                    DropdownButtonFormField<String>(
                      value: school,
                      decoration: InputDecoration(
                        labelText: '학력',
                        hintText: '학력을 선택해주세요.',
                        prefixIcon: const Icon(
                          Icons.school_outlined,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF8F7F3),
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFFD9D5CB),
                          ),
                        ),
                        enabledBorder:
                        OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFFD9D5CB),
                          ),
                        ),
                      ),
                      items: schoolOptions
                          .map(
                            (String value) =>
                            DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ),
                      )
                          .toList(),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty) {
                          return '학력을 선택해주세요.';
                        }

                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          school = value;
                        });
                      },
                      onSaved: (value) {
                        school = value;
                      },
                    ),

                    _fieldSpace(),

                    // 보호자/어머니
                    CustomTextForm(
                      hintText: '가족 정보를 입력해주세요.',
                      icon: const Icon(
                        Icons.family_restroom_outlined,
                      ),
                      validator: (value) {
                        return _requiredValidator(
                          value,
                          '가족 정보',
                        );
                      },
                      onSaved: (value) {
                        mom = value ?? '';
                      },
                    ),

                    _fieldSpace(),

                    // 관계
                    CustomTextForm(
                      hintText: '관계를 입력해주세요.',
                      icon: const Icon(
                        Icons.people_outline,
                      ),
                      validator: (value) {
                        return _requiredValidator(
                          value,
                          '관계',
                        );
                      },
                      onSaved: (value) {
                        relation = value ?? '';
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ==================================================
              // 등록 / 취소
              // ==================================================

              _buildSubmitButton(),

              const SizedBox(height: 12),

              _buildBackButton(),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _birthDayController.dispose();
    super.dispose();
  }
}