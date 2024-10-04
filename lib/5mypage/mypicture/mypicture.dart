import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyPicture extends StatefulWidget {
  final String uid;
  final String team;

  const MyPicture({super.key,
    required this.uid,
    required this.team});

  @override
  State<MyPicture> createState() => _MyPictureState();
}

class _MyPictureState extends State<MyPicture> {
  File? pickedImage;

  void _picImage() async {
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
      padding: EdgeInsets.only(top: 20),
      width: 150,
      height: 300,
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue,
            backgroundImage:
                pickedImage != null ? FileImage(pickedImage!) : null,
          ),
          SizedBox(
            height: 10,
          ),
          OutlinedButton.icon(
              onPressed: () {
                _picImage();
              },
              icon: Icon(Icons.image),
              label: Text('이미지 찾기')),
          SizedBox(
            height: 80,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                  onPressed: () async{

                    if (pickedImage != null) {
                      // 로딩 인디케이터 표시
                      showDialog(
                        context: context,
                        barrierDismissible: false, // 로딩 중에는 닫을 수 없도록 설정
                        builder: (BuildContext context) {
                          return Center(
                            child: CircularProgressIndicator(), // 로딩 인디케이터
                          );
                        },
                      );

                      final refImage = FirebaseStorage.instance
                          .ref()
                          .child('mypicture')
                          .child(widget.uid +'.png');



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
                          SnackBar(content: Text('사진등록 완료')),
                        );
                      } catch (e) {
                        print(e);
                      }
                      // 로딩 인디케이터 닫기
                      Navigator.of(context).pop();

                    }
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.circle),
                  label: Text('확정')),
              TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.close),
                  label: Text('닫기')),
            ],
          ),
        ],
      ),
    );
  }
}
