import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class LicensePicture extends StatefulWidget {
  final String uid;
  final String team;
  final String date;

  const LicensePicture({
    super.key,
    required this.uid,
    required this.team,
    required this.date,
  });

  @override
  State<LicensePicture> createState() => _LicensePictureState();
}

class _LicensePictureState extends State<LicensePicture> {
  File? pickedImage;

  void _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImageFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      if (pickedImageFile != null) {
        pickedImage = File(pickedImageFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100, // 가로 크기
            height: 100, // 세로 크기
            decoration: BoxDecoration(
              color: Colors.grey[200], // 배경색
              borderRadius: BorderRadius.circular(8), // 네모난 형태 (둥글기 조정 가능)
              border: Border.all(color: Colors.grey, width: 1), // 테두리 설정
            ),
            child: pickedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8), // 사진도 둥글게 클립
                    child: Image.file(
                      pickedImage!,
                      fit: BoxFit.cover, // 이미지를 꽉 채우기
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo, // 사진첩 모양의 아이콘
                        size: 40,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '사진 없음', // 기본 텍스트
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: _pickImage,
            icon: const Icon(
              Icons.image,
              color: Colors.white, // 아이콘 색상
            ),
            label: const Text(
              '이미지 선택',
              style: TextStyle(
                color: Colors.white, // 텍스트 색상
                fontWeight: FontWeight.bold, // 텍스트 굵기
                fontSize: 16, // 텍스트 크기
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), // 버튼 내부 여백
              backgroundColor: Colors.blueAccent, // 버튼 배경색
              side: BorderSide(
                color: Colors.blueAccent.shade700, // 테두리 색상
                width: 2, // 테두리 두께
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16), // 더 둥근 모서리
              ),
              shadowColor: Colors.blueAccent.shade200, // 그림자 색상
              elevation: 4, // 그림자 깊이
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            '* 악세사리 금지 *\n* 근무복장 착용 필수 *',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  if (pickedImage != null) {
                    // 로딩 인디케이터 표시
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );

                    final refImage = FirebaseStorage.instance
                        .ref()
                        .child('myLicensePicture')
                        .child(widget.date)
                        .child('${widget.uid}.png');

                    try {
                      await refImage.putFile(pickedImage!);
                      final url = await refImage.getDownloadURL();

                      await FirebaseFirestore.instance
                          .collection('user')
                          .doc(widget.uid)
                          .collection(widget.date)
                          .doc(widget.uid)
                          .set({
                        'picUrl': url,
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('사진등록 완료')),
                      );
                    } catch (e) {
                      print(e);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('사진 등록 실패')),
                      );
                    }
                    Navigator.of(context).pop(); // 로딩 닫기
                  }
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                },
                icon: const Icon(Icons.check_circle, color: Colors.white),
                label: const Text(
                  '확정',
                  style: TextStyle(color: Colors.white), // 텍스트 색상을 흰색으로 설정
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close, color: Colors.white),
                label: const Text(
                  '닫기',
                  style: TextStyle(color: Colors.white), // 텍스트 색상을 흰색으로 설정
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
