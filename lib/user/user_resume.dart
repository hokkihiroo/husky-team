import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:team_husky/1insa/Address.dart';
import 'package:team_husky/layout/default_layout.dart';
import 'package:team_husky/user/birthDay.dart';
import 'package:team_husky/user/custom_text_form.dart';
import 'package:team_husky/user/phoneInput.dart';
import 'package:team_husky/user/address_SearchPage.dart';
import 'package:team_husky/user/user_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class UserResume extends StatefulWidget {
  const UserResume({super.key});

  @override
  State<UserResume> createState() => _UserResumeState();
}

class _UserResumeState extends State<UserResume> {
  final _formKey = GlobalKey<FormState>();
  String image = 'asset/img/face.png'; //팀명
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthDayController =
      TextEditingController(); // 생년월일을 위한 컨트롤러 추가
  final TextEditingController _addressController = TextEditingController();

  void _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  String email = '';
  String password = '';
  String name = '';
  String birthDay = '';
  String phoneNumber = '';
  String detailAdress = ''; //자차번호
  String address = ''; //주소
  String career = ''; //운전경력
  String hobby = ''; //취미
  String footSize = ''; //발사이즈
  String tShirtSize = ''; //상의
  String pantsSize = ''; //하의
  String cm = ''; //키
  String kg = ''; //몸무게
  int levelNumber = 0; //


  String bank =''; //은행명
  String bankNum ='';  //은행계좌번호
  String personNum ='';  //주민번호
  String school ='';  //학력
  String mom ='';  //비상연락망
  String relation ='';  // 연락망관계

  File? pickedImage;

  @override
  void dispose() {
    _phoneController.dispose(); // 메모리 누수를 방지하기 위해 dispose 호출
    _birthDayController.dispose(); // 생년월일 컨트롤러 해제
    super.dispose();
  }

  void _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImageFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImageFile != null) {
      setState(() {
        pickedImage = File(pickedImageFile.path);
      });
    } else {
      // 이미지 선택 실패 시 SnackBar 표시
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(' "사진 등록 실패" 다시 시도하세요')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        backgroundColor: Colors.brown,
        title: '직원이력',
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
              height: 2500.0,
              width: MediaQuery.of(context).size.width - 20,
              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 5),
                  ]),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Text('양식을 꼭 지켜주세요'),
                      Text('중복 가입은 예고없이 삭제됩니다.'),
                      Text(''),
                      Text('-우덕균-'),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // 프로필 이미지 (왼쪽)
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.grey[200],
                                  backgroundImage: pickedImage != null
                                      ? FileImage(pickedImage!)
                                      : null,
                                  child: pickedImage == null
                                      ? const Icon(Icons.person,
                                          size: 40, color: Colors.grey)
                                      : null,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('사진'),
                              ],
                            ),
                            const SizedBox(width: 20),

                            // 버튼 (오른쪽)
                            Expanded(
                              child: Column(
                                children: [
                                  OutlinedButton.icon(
                                    onPressed: _pickImage,
                                    icon: const Icon(Icons.image,
                                        color: Colors.blueAccent),
                                    label: const Text(
                                      '이미지 선택',
                                      style:
                                          TextStyle(color: Colors.blueAccent),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      // 여백 설정
                                      side: const BorderSide(
                                          color: Colors.blueAccent),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      textStyle: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  const Text(
                                    '얼굴이 60% 이상 \n 보이는 사진으로 올릴것',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text('사진필수!!!'),
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextForm(
                        key: ValueKey(1),
                        validator: (val) {
                          if (val!.isEmpty || val.length < 1) {
                            return '이메일은 필수사항입니다.';
                          }

                          if (!RegExp(
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                              .hasMatch(val)) {
                            return '잘못된 이메일 형식입니다.';
                          }

                          return null;
                        },
                        onSaved: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                        hintText: '이메일',
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      CustomTextForm(
                        key: ValueKey(2),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return '비밀번호는 필수사항입니다.';
                          }

                          if (val.length < 6) {
                            return '6자 이상 입력해주세요!';
                          }
                          return null;
                        },
                        obscureText: true,
                        onSaved: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                        hintText: '비밀번호',
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      CustomTextForm(
                        key: ValueKey(3),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return '이름은 필수사항입니다.';
                          }

                          if (val.length < 2) {
                            return '이름은 두글자 이상 입력 해주셔야합니다.';
                          }

                          return null;
                        },
                        onSaved: (val) {
                          setState(() {
                            name = val;
                          });
                        },
                        hintText: '이름',
                        maxLength: 3,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      PhoneNumberInput(
                        phoneController: _phoneController,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return '전화번호는 필수사항입니다.';
                          }
                          if (val.length != 13) {
                            return '전화번호는 010-1234-5678 형식으로 입력해주세요.';
                          }

                          if (!RegExp(r'^010-\d{4}-\d{4}$').hasMatch(val)) {
                            return '유효한 전화번호 형식이 아닙니다.';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          setState(() {
                            phoneNumber = val!; // 하이픈 포함된 전화번호를 저장
                          });
                        },
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      CustomDatePicker(
                        dateController: _birthDayController,
                        // 생년월일을 받을 Controller
                        validator: (val) {
                          if (val!.isEmpty) {
                            return '생년월일을 입력바랍니다.';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          setState(() {
                            birthDay = val!;
                          });
                        },
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  '주소 검색',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => SearchPage()),
                                    );
                                    if (result != null && result is String) {
                                      setState(() {
                                        address = result;
                                      });
                                    }
                                  },
                                  child: Text('검색'),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              address,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 20),
                            CustomTextForm(
                              key: ValueKey(6),
                              onSaved: (val) {
                                setState(() {
                                  detailAdress = val!;
                                });
                              },
                              hintText: '상세주소',
                            ),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '(주소는 실거주로 입력바랍니다.)',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                // 벨류키 7번 날렸음 행여나 나중에 밸류키 쓸때 7번쓰면됨
                                // 벨류키 7번 날렸음 행여나 나중에 밸류키 쓸때 7번쓰면됨
                                // 벨류키 7번 날렸음 행여나 나중에 밸류키 쓸때 7번쓰면됨
                                // 벨류키 7번 날렸음 행여나 나중에 밸류키 쓸때 7번쓰면됨
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 25,
                      ),
                      CustomTextForm(
                        key: ValueKey(8),
                        onSaved: (val) {
                          setState(() {
                            career = val!;
                          });
                        },
                        hintText: '운전경력 예) 5년',
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      CustomTextForm(
                        key: ValueKey(9),
                        onSaved: (val) {
                          setState(() {
                            hobby = val!;
                          });
                        },
                        hintText: '취미',
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text('숫자만 입력하세요 단위X'),
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextForm(
                        key: ValueKey(10),
                        onSaved: (val) {
                          setState(() {
                            footSize = val!;
                          });
                        },
                        hintText: '발사이즈 예) 260',
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      CustomTextForm(
                        key: ValueKey(11),
                        onSaved: (val) {
                          setState(() {
                            tShirtSize = val!;
                          });
                        },
                        hintText: '상의사이즈 예) 100',
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      CustomTextForm(
                        key: ValueKey(12),
                        onSaved: (val) {
                          setState(() {
                            pantsSize = val!;
                          });
                        },
                        hintText: '하의사이즈 예) 32',
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      CustomTextForm(
                        key: ValueKey(13),
                        onSaved: (val) {
                          setState(() {
                            cm = val!;
                          });
                        },
                        hintText: '키 예) 175',
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      CustomTextForm(
                        key: ValueKey(14),
                        onSaved: (val) {
                          setState(() {
                            kg = val!;
                          });
                        },
                        hintText: '몸무게 예) 70',
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text('* 중요정보 * '),
                      SizedBox(
                        height: 10,
                      ),
                      Text('절대 양식을 지켜주세요'),
                      SizedBox(
                        height: 25,
                      ),
                      CustomTextForm(
                        key: ValueKey(15),
                        onSaved: (val) {
                          setState(() {
                             bank = val!;
                          });
                        },
                        hintText: '은행명 예) 신한은행 or 하나증권 등등',
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      CustomTextForm(
                        key: ValueKey(16),
                        onSaved: (val) {
                          setState(() {
                             bankNum = val!;
                          });
                        },
                        hintText: '계좌번호 예) 61512214217',
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      CustomTextForm(
                        key: ValueKey(17),
                        onSaved: (val) {
                          setState(() {
                             personNum = val!;
                          });
                        },
                        hintText: '주민번호 예) 881214-1234567',
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      CustomTextForm(
                        key: ValueKey(18),
                        onSaved: (val) {
                          setState(() {
                             school = val!;
                          });
                        },
                        hintText: '학력 예) 대학중퇴,대학휴학,재학중,등등',
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      CustomTextForm(
                        key: ValueKey(19),
                        onSaved: (val) {
                          setState(() {
                             mom = val!;
                          });
                        },
                        hintText: '비상연락망 예) 010-1234-1234',
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      CustomTextForm(
                        key: ValueKey(20),
                        onSaved: (val) {
                          setState(() {
                             relation = val!;
                          });
                        },
                        hintText: '관계 예) 아버지 or 어머니 기타등등',
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //돌아가기
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              '돌아가기',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          //이력서 제출
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown),
                            onPressed: () async {
                              _tryValidation();

                              // 로딩 인디케이터 표시
                              showDialog(
                                context: context,
                                barrierDismissible: false, // 로딩 중에는 닫을 수 없도록 설정
                                builder: (BuildContext context) {
                                  return Center(
                                    child:
                                        CircularProgressIndicator(), // 로딩 인디케이터
                                  );
                                },
                              );
                              try {
                                // 컬렉션의 문서를 가져옵니다.
                                QuerySnapshot querySnapshot =
                                    await FirebaseFirestore.instance
                                        .collection(INSA)
                                        .doc(BOSNA)
                                        .collection(LIST)
                                        .get();

                                // 문서의 개수를 반환합니다.
                                int highestLevel = querySnapshot.docs
                                    .map((doc) => doc['levelNumber']
                                        as int) // levelNumber 필드 값을 가져옴
                                    .reduce((curr, next) => curr > next
                                        ? curr
                                        : next); // 가장 높은 값 찾기

                                print(highestLevel);
                                print(highestLevel);
                                print(highestLevel);
                                levelNumber = highestLevel;
                                print(levelNumber);
                                print(levelNumber);
                                print(highestLevel);
                              } catch (e) {
                                print(e);
                              }

                              try {
                                final newUser =
                                    await AUTH.createUserWithEmailAndPassword(
                                        email: email, password: password);

                                final newUid = newUser.user!.uid;

                                final refImage = FirebaseStorage.instance
                                    .ref()
                                    .child('mypicture')
                                    .child('$newUid.png');

                                await refImage.putFile(pickedImage!);
                                final picUrl = await refImage.getDownloadURL();

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
                                  'carNumber': detailAdress,
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
                                  //등급
                                  'enterDay': FieldValue.serverTimestamp(),
                                  //입사일
                                });

                                await FirebaseFirestore.instance
                                    .collection(INSA)
                                    .doc(BOSNA)
                                    .collection(LIST)
                                    .doc(newUid)
                                    .set({
                                  'image': image,
                                  'name': name, //이름
                                  'grade': '사원',
                                  'position': '드라이버',
                                  'enterDay': FieldValue.serverTimestamp(),
                                  'picUrl': picUrl,
                                  'levelNumber': levelNumber + 1,
                                });

                                // 로딩 인디케이터 닫기
                                Navigator.of(context).pop();

                                Navigator.pop(context);
                              } catch (e) {
                                print(e);

                                // 에러가 발생하면 로딩 인디케이터 닫기
                                Navigator.of(context).pop();
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              '이력서 제출',
                              style: TextStyle(
                                color: Colors.white,
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
          ),
        ));
  }
}
