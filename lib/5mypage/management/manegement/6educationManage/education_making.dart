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
  File? pickedImage1;
  File? pickedImage2;
  File? pickedImage3;
  File? pickedImage4;
  File? pickedImage5;

  final _formKey = GlobalKey<FormState>();

  void _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }
  void _picImage() async {
    final imagePicker = ImagePicker();
    final pickedImageFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxHeight: 150,
    );
    setState(() {
      if (pickedImageFile != null) {
        pickedImage1 = File(pickedImageFile.path);
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
                    GestureDetector(
                      onTap: () {
                        _picImage(); // 이미지 선택 함수 호출
                      },
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.blue,
                            backgroundImage: pickedImage1 != null ? FileImage(pickedImage1!) : null,
                          ),
                          if (pickedImage1 == null) // 이미지가 없을 때 숫자 1을 표시
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  '1',
                                  style: TextStyle(
                                    color: Colors.white, // 숫자 색상 (흰색)
                                    fontSize: 24, // 숫자 크기
                                    fontWeight: FontWeight.bold, // 숫자 두껍게
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20,),

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
