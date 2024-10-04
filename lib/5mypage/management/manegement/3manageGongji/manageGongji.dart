import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:team_husky/3notice/Address.dart';
import 'package:team_husky/notification.dart';
import 'package:team_husky/user/custom_text_form.dart';

class ManageGongji extends StatefulWidget {
  String subject;
  String docId;
  String name;

  ManageGongji(
      {super.key,
      required this.subject,
      required this.docId,
      required this.name});

  @override
  State<ManageGongji> createState() => _ManageGongjiState();
}

class _ManageGongjiState extends State<ManageGongji> {
  Map<int, File?> pickedImages = {};
  String subject = ''; // 제목
  String contents = ''; // 내용

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
    );
    setState(() {
      if (pickedImageFile != null) {
        pickedImages[num] = File(pickedImageFile.path);
      }
    });
  }

  Future<void> _uploadImagesAndSaveUrls(String documentId) async {
    final storageRef = FirebaseStorage.instance.ref();
    final uploadTasks = <Future<void>>[];

    for (final entry in pickedImages.entries) {
      final num = entry.key;
      final file = entry.value;

      if (file != null) {
        final ref = storageRef
            .child('education_images/${widget.docId}/$documentId/$num.png');
        final uploadTask = ref.putFile(file);

        uploadTasks.add(uploadTask.then((taskSnapshot) async {
          final downloadUrl = await taskSnapshot.ref.getDownloadURL();
          await FirebaseFirestore.instance
              .collection('education')
              .doc(widget.docId)
              .collection('list')
              .doc(documentId)
              .update({
            'images.$num': downloadUrl,
          });
        }));
      }
    }

    await Future.wait(uploadTasks);
  }

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
                      maxLength: 10, // 입력 문자 수 10글자

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
                                  if (pickedImages[1] ==
                                      null) // 이미지가 없을 때 숫자를 표시
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
                                  if (pickedImages[2] ==
                                      null) // 이미지가 없을 때 숫자를 표시
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
                                  if (pickedImages[3] ==
                                      null) // 이미지가 없을 때 숫자를 표시
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
                                  if (pickedImages[4] ==
                                      null) // 이미지가 없을 때 숫자를 표시
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
                                  if (pickedImages[5] ==
                                      null) // 이미지가 없을 때 숫자를 표시
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
                                  if (pickedImages[6] ==
                                      null) // 이미지가 없을 때 숫자를 표시
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('사진업로드시 시간이걸릴수 있습니다.')),
                            );

                            _tryValidation();
                            String documentId = FirebaseFirestore.instance
                                .collection(GONGJI)
                                .doc(widget.docId)
                                .collection('List')
                                .doc()
                                .id;
                            try {
                              await FirebaseFirestore.instance
                                  .collection(GONGJI)
                                  .doc(widget.docId)
                                  .collection('List')
                                  .doc(documentId)
                                  .set({
                                'writer': widget.name,
                                'subject': subject,
                                'createdAt': FieldValue.serverTimestamp(),
                                'contents': contents,
                                'images': {},
                              });
                              //알람울려달라고 서버로 던짐
                              // PushNotication.sendPushMessage(
                              //     title: '팀허스키 ', message: '공지가 등록되었습니다.');
                              //사진작업
                              await _uploadImagesAndSaveUrls(documentId);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('작성 완료')),
                              );
                            } catch (e) {
                              print(e);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('오류 발생: $e')),
                              );
                            }
                            Navigator.pop(context);
                          },
                          child: Text(
                            '공지작성',
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
