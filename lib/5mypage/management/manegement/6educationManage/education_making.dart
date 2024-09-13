import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:team_husky/user/custom_text_form.dart';

class EducationMaking extends StatefulWidget {
  String subject;
  String docId;
  String name;

  EducationMaking(
      {super.key,
      required this.subject,
      required this.docId,
      required this.name});

  @override
  State<EducationMaking> createState() => _EducationMakingState();
}

class _EducationMakingState extends State<EducationMaking> {
  Map<int, File?> pickedImages = {};


  final _formKey = GlobalKey<FormState>();

  void _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  void _picImage(int num) async {
    final imagePicker = ImagePicker();
    final pickedImageFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxHeight: 150,
    );
    setState(() {
      if (pickedImageFile != null) {
        pickedImages[num] = File(pickedImageFile.path);
      }
    });
  }

  // void _pickImages() async {
  //   final imagePicker = ImagePicker();
  //
  //   // 이미 선택된 이미지가 5개보다 적을 때만 실행
  //   if (pickedImages.length < 5) {
  //     final pickedImageFile = await imagePicker.pickImage(
  //       source: ImageSource.gallery,
  //       imageQuality: 50,
  //     );
  //     setState(() {
  //       if (pickedImageFile != null) {
  //         pickedImages.add(File(pickedImageFile.path));
  //       }
  //     });
  //   }
  // }

  String subject = ''; // 제목
  String contents = ''; // 내용

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '카테고리 : ${widget.subject}',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Column(
                  children: [
                    CustomTextForm(
                      key: ValueKey(1),
                      onSaved: (val) {
                        setState(() {
                          subject = val!;
                        });
                      },
                      hintText: '제목',
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      initialValue: contents,
                      decoration: InputDecoration(
                        labelText: '내용',

                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold, // '내용' 텍스트를 bold로 설정
                            fontSize: 25,
                            color: Colors.purple),
                        contentPadding: EdgeInsets.only(
                            top: 24.0,
                            bottom: 12.0), // labelText와 입력 데이터 사이 간격 설정
                      ),
                      onChanged: (value) {
                        setState(() {
                          contents = value; // 입력된 내용으로 contents 변수 업데이트
                        });
                      },
                      maxLines: null,
                      // 사용자가 입력한 만큼 높이가 자동으로 늘어남
                      minLines: 1,
                      // 최소 1줄의 높이로 설정
                      maxLength: null, // 입력 문자 수에 제한을 두지 않음
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    //(이부분)
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _picImage(1); // 이미지 선택 함수 호출
                              },
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.grey,
                                    backgroundImage: pickedImages[1] != null
                                        ? FileImage(pickedImages[1]!)
                                        : null,
                                  ),
                                  if (pickedImages[1] ==
                                      null) // 이미지가 없을 때 카메라 아이콘과 숫자를 표시
                                    Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.camera_alt, // 카메라 모양 아이콘
                                          color: Colors.white, // 아이콘 색상 (흰색)
                                          size: 24, // 아이콘 크기
                                        ),
                                      ),
                                    ),
                                  if (pickedImages[1] == null) // 이미지가 없을 때 숫자를 표시
                                    Positioned(
                                      bottom: 5, // 숫자를 아이콘 아래쪽에 배치
                                      left: 0,
                                      right: 0,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          '1', // 숫자
                                          style: TextStyle(
                                            color: Colors.white, // 숫자 색상
                                            fontSize: 12, // 숫자 크기
                                            fontWeight:
                                                FontWeight.bold, // 숫자 두껍게
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _picImage(2); // 이미지 선택 함수 호출
                              },
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.grey,
                                    backgroundImage: pickedImages[2] != null
                                        ? FileImage(pickedImages[2]!)
                                        : null,
                                  ),
                                  if (pickedImages[2] ==
                                      null) // 이미지가 없을 때 카메라 아이콘과 숫자를 표시
                                    Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.camera_alt, // 카메라 모양 아이콘
                                          color: Colors.white, // 아이콘 색상 (흰색)
                                          size: 24, // 아이콘 크기
                                        ),
                                      ),
                                    ),
                                  if (pickedImages[2] == null) // 이미지가 없을 때 숫자를 표시
                                    Positioned(
                                      bottom: 5, // 숫자를 아이콘 아래쪽에 배치
                                      left: 0,
                                      right: 0,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          '2', // 숫자
                                          style: TextStyle(
                                            color: Colors.white, // 숫자 색상
                                            fontSize: 12, // 숫자 크기
                                            fontWeight:
                                                FontWeight.bold, // 숫자 두껍게
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _picImage(3); // 이미지 선택 함수 호출
                              },
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.grey,
                                    backgroundImage: pickedImages[3] != null
                                        ? FileImage(pickedImages[3]!)
                                        : null,
                                  ),
                                  if (pickedImages[3] ==
                                      null) // 이미지가 없을 때 카메라 아이콘과 숫자를 표시
                                    Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.camera_alt, // 카메라 모양 아이콘
                                          color: Colors.white, // 아이콘 색상 (흰색)
                                          size: 24, // 아이콘 크기
                                        ),
                                      ),
                                    ),
                                  if (pickedImages[3] == null) // 이미지가 없을 때 숫자를 표시
                                    Positioned(
                                      bottom: 5, // 숫자를 아이콘 아래쪽에 배치
                                      left: 0,
                                      right: 0,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          '3', // 숫자
                                          style: TextStyle(
                                            color: Colors.white, // 숫자 색상
                                            fontSize: 12, // 숫자 크기
                                            fontWeight:
                                                FontWeight.bold, // 숫자 두껍게
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _picImage(4); // 이미지 선택 함수 호출
                              },
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.grey,
                                    backgroundImage: pickedImages[4] != null
                                        ? FileImage(pickedImages[4]!)
                                        : null,
                                  ),
                                  if (pickedImages[4] ==
                                      null) // 이미지가 없을 때 카메라 아이콘과 숫자를 표시
                                    Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.camera_alt, // 카메라 모양 아이콘
                                          color: Colors.white, // 아이콘 색상 (흰색)
                                          size: 24, // 아이콘 크기
                                        ),
                                      ),
                                    ),
                                  if (pickedImages[4] == null) // 이미지가 없을 때 숫자를 표시
                                    Positioned(
                                      bottom: 5, // 숫자를 아이콘 아래쪽에 배치
                                      left: 0,
                                      right: 0,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          '4', // 숫자
                                          style: TextStyle(
                                            color: Colors.white, // 숫자 색상
                                            fontSize: 12, // 숫자 크기
                                            fontWeight:
                                                FontWeight.bold, // 숫자 두껍게
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _picImage(5); // 이미지 선택 함수 호출
                              },
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.grey,
                                    backgroundImage: pickedImages[5] != null
                                        ? FileImage(pickedImages[5]!)
                                        : null,
                                  ),
                                  if (pickedImages[5] ==
                                      null) // 이미지가 없을 때 카메라 아이콘과 숫자를 표시
                                    Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.camera_alt, // 카메라 모양 아이콘
                                          color: Colors.white, // 아이콘 색상 (흰색)
                                          size: 24, // 아이콘 크기
                                        ),
                                      ),
                                    ),
                                  if (pickedImages[5] == null) // 이미지가 없을 때 숫자를 표시
                                    Positioned(
                                      bottom: 5, // 숫자를 아이콘 아래쪽에 배치
                                      left: 0,
                                      right: 0,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          '5', // 숫자
                                          style: TextStyle(
                                            color: Colors.white, // 숫자 색상
                                            fontSize: 12, // 숫자 크기
                                            fontWeight:
                                                FontWeight.bold, // 숫자 두껍게
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _picImage(6); // 이미지 선택 함수 호출
                              },
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.grey,
                                    backgroundImage: pickedImages[6] != null
                                        ? FileImage(pickedImages[6]!)
                                        : null,
                                  ),
                                  if (pickedImages[6] ==
                                      null) // 이미지가 없을 때 카메라 아이콘과 숫자를 표시
                                    Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.camera_alt, // 카메라 모양 아이콘
                                          color: Colors.white, // 아이콘 색상 (흰색)
                                          size: 24, // 아이콘 크기
                                        ),
                                      ),
                                    ),
                                  if (pickedImages[6] == null) // 이미지가 없을 때 숫자를 표시
                                    Positioned(
                                      bottom: 5, // 숫자를 아이콘 아래쪽에 배치
                                      left: 0,
                                      right: 0,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          '6', // 숫자
                                          style: TextStyle(
                                            color: Colors.white, // 숫자 색상
                                            fontSize: 12, // 숫자 크기
                                            fontWeight:
                                                FontWeight.bold, // 숫자 두껍게
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.brown),
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
                        ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.black),
                          onPressed: () async {
                            _tryValidation();
                            String documentId = FirebaseFirestore.instance
                                .collection('education')
                                .doc(widget.docId)
                                .collection('list')
                                .doc()
                                .id;
                            try {
                              await FirebaseFirestore.instance
                                  .collection('education')
                                  .doc(widget.docId)
                                  .collection('list')
                                  .doc(documentId)
                                  .set({
                                'writer': widget.name,
                                'subject': subject,
                                'createdAt': FieldValue.serverTimestamp(),
                                'contents': contents,
                              });
                              //알람울려달라고 서버로 던짐
                            } catch (e) {
                              print(e);
                            }
                            Navigator.pop(context);
                          },
                          child: Text(
                            '작성하기',
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
      ),
    );
  }
}