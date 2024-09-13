import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/3notice/Address.dart';
import 'package:team_husky/notification.dart';
import 'package:team_husky/user/custom_text_form.dart';

class ManageGongji extends StatefulWidget {
  String name ='';
   ManageGongji({super.key,required this.name});

  @override
  State<ManageGongji> createState() => _ManageGongjiState();
}

class _ManageGongjiState extends State<ManageGongji> {

  final _formKey = GlobalKey<FormState>();

  void _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  String subject = '';  // 제목
  String contents = ''; // 내용

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '공지관리',
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
        onTap: (){
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
                    CustomTextForm(
                      key: ValueKey(2),
                      onSaved: (val) {
                        setState(() {
                          contents = val!;
                        });
                      },
                      hintText: '내용',
                      maxLines: 10,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.brown),
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
                          style: ElevatedButton.styleFrom(primary: Colors.black),
                          onPressed: () async {
                            _tryValidation();
                            String documentId = FirebaseFirestore.instance
                                .collection(GONGJI)
                                .doc()
                                .id;
                            try {
                              await FirebaseFirestore.instance
                                  .collection(GONGJI)
                                  .doc(documentId)
                                  .set({
                                'writer': widget.name,
                                'subject': subject,
                                'createdAt': FieldValue.serverTimestamp(),
                                'docId' : documentId,
                                'contents' : contents,

                              });
                              //알람울려달라고 서버로 던짐
                              PushNotication.sendPushMessage(
                                  title: '팀허스키 ',
                                  message: '공지가 등록되었습니다.');
                            } catch (e) {
                              print(e);
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
