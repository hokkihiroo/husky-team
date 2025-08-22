import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SalaryPicture extends StatefulWidget {
  final String uid;
  final String team;
  final String date;


  const SalaryPicture({
    super.key,
    required this.uid,
    required this.team,
    required this.date,
  });

  @override
  State<SalaryPicture> createState() => _SalaryPictureState();
}

class _SalaryPictureState extends State<SalaryPicture> {
  File? pickedImage1;
  File? pickedImage2;

  Future<void> _pickImage(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (index == 1) {
          pickedImage1 = File(pickedFile.path);
        } else {
          pickedImage2 = File(pickedFile.path);
        }
      });
    }
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
          // 수정됨: 사진1, 사진2 두 개 선택 가능 & 박스를 클릭하면 이미지 선택
          Row( // 수정됨
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 수정됨
            children: [
              GestureDetector( // 수정됨
                onTap: () => _pickImage(1), // 수정됨
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  child: pickedImage1 != null // 수정됨
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      pickedImage1!,
                      fit: BoxFit.cover,
                    ),
                  )
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.photo, size: 40, color: Colors.grey),
                      SizedBox(height: 8),
                      Text(
                        '사진1 선택',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector( // 수정됨
                onTap: () => _pickImage(2), // 수정됨
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  child: pickedImage2 != null // 수정됨
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      pickedImage2!,
                      fit: BoxFit.cover,
                    ),
                  )
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.photo, size: 40, color: Colors.grey),
                      SizedBox(height: 8),
                      Text(
                        '사진2 선택',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),


          const SizedBox(height: 20),
          const Text(
            '*급여명부가 해당직원이* \n *맞는지 확인하세요*',
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
                  // if (pickedImage != null) {
                  //   // 로딩 인디케이터 표시
                  //   showDialog(
                  //     context: context,
                  //     barrierDismissible: false,
                  //     builder: (BuildContext context) {
                  //       return const Center(
                  //         child: CircularProgressIndicator(),
                  //       );
                  //     },
                  //   );
                  //
                  //   final refImage = FirebaseStorage.instance
                  //       .ref()
                  //       .child('mySalaryPicture')
                  //       .child(widget.date)
                  //       .child('${widget.uid}.png');
                  //
                  //   try {
                  //     await refImage.putFile(pickedImage!);
                  //     final url = await refImage.getDownloadURL();
                  //
                  //     await FirebaseFirestore.instance
                  //         .collection('user')
                  //         .doc(widget.uid)
                  //         .collection('salary')
                  //         .doc('SJLmYrEd97eR6EaPX67b')
                  //         .collection(widget.date)
                  //         .doc(widget.uid)
                  //         .set({
                  //       'licenseUrl': url,
                  //
                  //     });
                  //
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       const SnackBar(content: Text('사진등록 완료')),
                  //     );
                  //   } catch (e) {
                  //     print(e);
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       const SnackBar(content: Text('사진 등록 실패')),
                  //     );
                  //   }
                  //   Navigator.of(context).pop(); // 로딩 닫기
                  // }
                  // Navigator.of(context).pop(); // 다이얼로그 닫기
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
