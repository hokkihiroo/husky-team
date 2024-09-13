import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/1insa/Address.dart';

import '../../../../user/custom_text_form.dart';

class MakeTeam extends StatefulWidget {
  const MakeTeam({super.key});

  @override
  State<MakeTeam> createState() => _MakeTeamState();
}

class _MakeTeamState extends State<MakeTeam> {
  final _formKey = GlobalKey<FormState>();

  void _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  String image = 'asset/img/husky_Logo.png'; //팀명
  String name = ''; //팀명
  String position = ''; //팀 위치

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '팀만들기',
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
      body: Container(
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
                      name = val!;
                    });
                  },
                  hintText: '팀이름',
                ),
                SizedBox(
                  height: 25,
                ),
                CustomTextForm(
                  key: ValueKey(2),
                  onSaved: (val) {
                    setState(() {
                      position = val!;
                    });
                  },
                  hintText: '팀위치',
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
                            .collection(INSA)
                            .doc()
                            .id;
                        try {
                          await FirebaseFirestore.instance
                              .collection(INSA)
                              .doc(documentId)
                              .set({
                            'image': image,
                            'name': name,
                            'position': position,
                            'createdAt': FieldValue.serverTimestamp(),
                            'docId' : documentId,

                          });
                        } catch (e) {
                          print(e);
                        }
                        Navigator.pop(context);
                      },
                      child: Text(
                        '팀생성',
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
    );
  }
}
