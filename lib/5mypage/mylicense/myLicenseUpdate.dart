import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/5mypage/mylicense/PDFViewer.dart';
import 'package:team_husky/5mypage/mylicense/downloadPDF.dart';

class MyLicenseUpdate extends StatefulWidget {
  const MyLicenseUpdate({super.key});

  @override
  State<MyLicenseUpdate> createState() => _LicenseUpdateState();
}

class _LicenseUpdateState extends State<MyLicenseUpdate> {
  // PDF 업로드함수

  Future<void> uploadPdfFile() async {
    try {
      // 1. 사용자에게 파일 선택 창 열기
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'], // PDF만 선택 가능
      );

      if (result == null) {
        print('No file selected.');
        return; // 사용자가 파일 선택을 취소
      }

      final file = File(result.files.single.path!);

      // 2. Firebase Storage 경로 설정
      final fileName = path.basename(file.path); // 파일 이름 가져오기
      final storageRef = FirebaseStorage.instance.ref().child('pdfs/$fileName');

      // 3. Firebase Storage에 업로드
      final uploadTask = storageRef.putFile(file);

      // 4. 업로드 진행 상태 확인 (선택 사항)
      uploadTask.snapshotEvents.listen((event) {
        final progress = (event.bytesTransferred / event.totalBytes) * 100;
        print('Upload is $progress% complete.');
      });

      // 5. 업로드 완료 후 다운로드 URL 가져오기
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      print('PDF uploaded successfully. Download URL: $downloadUrl');
    } catch (e) {
      print('Error uploading PDF: $e');
    }
  }


  //어제로 이동
  void _previousDay() {
    // final goToOneDayAgo = selectedDate.subtract(Duration(days: 1));
    // final year = goToOneDayAgo.year.toString();
    // final month = goToOneDayAgo.month.toString().padLeft(2, '0');
    // final day = goToOneDayAgo.day.toString().padLeft(2, '0');
    setState(() {
      // selectedDate = goToOneDayAgo;
      // DBAdress = year + month + day;
    });
  }

  //다음날로 이동
  void _nextDay() {
    // final today = DateTime.now();
    // final nextDay = selectedDate.add(Duration(days: 1));
    // final year = nextDay.year.toString();
    // final month = nextDay.month.toString().padLeft(2, '0');
    // final day = nextDay.day.toString().padLeft(2, '0');

    setState(() {
      // if (nextDay.isBefore(today)) {
      //   setState(() {
      //     selectedDate = nextDay;
      //     DBAdress = year + month + day;
      //   });
      // }
    });
  }

  //오늘로 이동
  void goToday() {
    setState(() {
      // selectedDate = DateTime.now();
      // DBAdress = formatTodayDate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '나의 운전면허관리',
          style: TextStyle(
            color: Colors.white, // 텍스트를 흰색으로 변경
            fontWeight: FontWeight.bold, // 굵은 글씨
            fontSize: 20, // 텍스트 크기 증가
            letterSpacing: 1.2, // 글자 간격 추가
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        // 아이콘 색상 변경
        centerTitle: true,
        // 제목 중앙 정렬
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.black], // 그라데이션 색상
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3), // 그림자 색상
                offset: Offset(0, 4), // 그림자 위치
                blurRadius: 10, // 그림자 흐림 정도
              ),
            ],
          ),
        ),
        elevation: 0, // AppBar 그림자 제거
      ),
      body: Column(
        children: [
          _DateControl(
            onPressLeft: _previousDay,
            onPressRight: _nextDay,
            onPressGoToday: goToday,
          ),

// 이공간에 flutter_pdfview 를 통해 파이어 베이스에 저장된 pdf를 이미지화 시키고 싶어
//     파이어 베이스와 기본적인것들은 다 연동이 되어있어
//       코어니 어스니 스토리지같은것들은.
        // 여기에 한번 그려줘

          // Expanded(
          //   child: FutureBuilder<File>(
          //     future: downloadPdf('example.pdf'), // PDF 파일 이름
          //     builder: (context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return Center(child: CircularProgressIndicator());
          //       } else if (snapshot.hasError) {
          //         return Center(child: Text('Error: ${snapshot.error}'));
          //       } else if (snapshot.hasData) {
          //         return PdfViewer(pdfFile: snapshot.data!);
          //       } else {
          //         return Center(child: Text('No PDF found.'));
          //       }
          //     },
          //   ),
          // ),

          ElevatedButton(
            onPressed: uploadPdfFile, // 업로드 함수 연결
            child: Text('PDF 파일 업로드'),
          ),

        ],
      ),
    );
  }
}

class _DateControl extends StatelessWidget {
  final VoidCallback onPressLeft;
  final VoidCallback onPressRight;
  final VoidCallback onPressGoToday;

  const _DateControl(
      {super.key,
      required this.onPressLeft,
      required this.onPressRight,
      required this.onPressGoToday,
      });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            Icons.chevron_left_outlined,
            color: Colors.black,
          ),
          onPressed: onPressLeft,
        ),

        SizedBox(
          width: 2,
        ),
        Text('1분기',
        style: TextStyle(
          fontSize: 20,
        ),),
        IconButton(
          icon: Icon(
            Icons.chevron_right_outlined,
            color: Colors.black,

          ),
          onPressed: onPressRight,
        ),
        GestureDetector(
          onTap: onPressGoToday,
          child: Text(
            'TODAY',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
}
