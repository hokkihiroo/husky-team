import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyPicture extends StatefulWidget {
  final String uid;
  final String team;

  const MyPicture({
    super.key,
    required this.uid,
    required this.team,
  });

  @override
  State<MyPicture> createState() => _MyPictureState();
}

class _MyPictureState extends State<MyPicture> {
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
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[200],
            backgroundImage:
                pickedImage != null ? FileImage(pickedImage!) : null,
            child: pickedImage == null
                ? const Icon(Icons.person, size: 50, color: Colors.grey)
                : null,
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.image, color: Colors.blueAccent),
            label: const Text(
              '이미지 선택',
              style: TextStyle(color: Colors.blueAccent),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.blueAccent),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
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
                        .child('mypicture')
                        .child('${widget.uid}.png');

                    try {
                      await refImage.putFile(pickedImage!);
                      final url = await refImage.getDownloadURL();

                      await FirebaseFirestore.instance
                          .collection('user')
                          .doc(widget.uid)
                          .update({
                        'picUrl': url,
                      });

                      await FirebaseFirestore.instance
                          .collection('insa')
                          .doc(widget.team)
                          .collection('list')
                          .doc(widget.uid)
                          .update({
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
