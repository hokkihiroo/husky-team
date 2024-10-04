import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditGongjiDetail extends StatelessWidget {
  String category;
  String subject;
  String writer;
  String contents;
  String docId;
  String categoryDocId;

  EditGongjiDetail({
    required this.category,
    required this.subject,
    required this.writer,
    required this.contents,
    required this.docId,
    required this.categoryDocId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('내용 수정')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                initialValue: subject,
                decoration: InputDecoration(
                  labelText: '제목',

                  labelStyle: TextStyle(
                      fontWeight: FontWeight.bold, // '내용' 텍스트를 bold로 설정
                      fontSize: 25,
                      color: Colors.purple),
                  contentPadding: EdgeInsets.only(
                      top: 24.0, bottom: 12.0), // labelText와 입력 데이터 사이 간격 설정
                ),
                onChanged: (value) {
                  subject = value;
                },
                maxLength: 10, // 최대 10글자까지 입력 가능
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
                      top: 24.0, bottom: 12.0), // labelText와 입력 데이터 사이 간격 설정
                ),
                onChanged: (value) {
                  contents = value; // 입력된 내용으로 contents 변수 업데이트
                },
                maxLines: null,
                // 사용자가 입력한 만큼 높이가 자동으로 늘어남
                minLines: 1,
                // 최소 1줄의 높이로 설정
                maxLength: null, // 입력 문자 수에 제한을 두지 않음
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () async {
                  // Firestore에 수정된 데이터를 저장하는 로직
                  try {
                    await FirebaseFirestore.instance
                        .collection('gongji')
                        .doc(categoryDocId)
                        .collection('List')
                        .doc(docId)
                        .update({
                      'subject': subject,
                      'contents': contents,
                      // 기타 필요한 필드들
                    });
                    Navigator.pop(context); // 수정 완료 후 원래 화면으로 돌아가기
                  } catch (e) {
                    print('수정 실패: $e');
                  }
                  Navigator.pop(context); // 수정 완료 후 원래 화면으로 돌아가기
                },
                child: Text('수정 완료'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
