import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;
  final String? title;
  final Widget? bottomNavigationBar;

  const DefaultLayout({
    super.key,
    required this.child,
    this.backgroundColor,
    this.title,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      appBar: renderAppBar(),
      body: child,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  AppBar? renderAppBar() {
    if (title == null) {
      return null;
    } else {
      return AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: backgroundColor ?? Colors.white,
        elevation: 0,
        title: Text(
          title!,
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: false,
        foregroundColor: Colors.black,
      );
    }
  }
}



// 직접입력 버튼 브랜드관리에서 직접입력하는버튼 이쪽으로 빼놧음
// ElevatedButton(
//   style: ElevatedButton.styleFrom(
//     padding: EdgeInsets.symmetric(
//         horizontal: 24, vertical: 14),
//     backgroundColor: Colors.black,
//     // 검정 배경
//     foregroundColor: Colors.yellow,
//     // 노란 글씨
//     shape: RoundedRectangleBorder(
//       borderRadius:
//           BorderRadius.circular(12),
//     ),
//     textStyle: TextStyle(
//       fontSize: 16,
//       fontWeight: FontWeight.bold,
//     ),
//   ),
//   onPressed: () {
//     Navigator.of(context)
//         .pop(); // 이전 다이얼로그 닫기
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         TextEditingController
//             brandController =
//             TextEditingController();
//         TextEditingController
//             modelController =
//             TextEditingController();
//
//         return AlertDialog(
//           title: Text(
//             '직접입력',
//             style: TextStyle(
//                 fontWeight:
//                     FontWeight.bold),
//           ),
//           content: Column(
//             mainAxisSize:
//                 MainAxisSize.min,
//             children: [
//               TextField(
//                 controller:
//                     brandController,
//                 decoration:
//                     InputDecoration(
//                   labelText: '브랜드',
//                   border:
//                       OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 12),
//               TextField(
//                 controller:
//                     modelController,
//                 decoration:
//                     InputDecoration(
//                   labelText: '차종',
//                   border:
//                       OutlineInputBorder(),
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () =>
//                   Navigator.of(context)
//                       .pop(),
//               child: Text('취소'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 String brand =
//                     brandController.text
//                         .trim();
//                 String model =
//                     modelController.text
//                         .trim();
//
//                 try {
//                   await FirebaseFirestore
//                       .instance
//                       .collection(FIELD)
//                       .doc(dataId)
//                       .update({
//                     'carBrand': brand,
//                     'carModel': model,
//                   });
//                 } catch (e) {
//                   print(e);
//                 }
//                 try {
//                   await FirebaseFirestore
//                       .instance
//                       .collection(
//                           CarListAdress)
//                       .doc(dataId)
//                       .update({
//                     'carBrand': brand,
//                     'carModel': model,
//                   });
//                 } catch (e) {
//                   print(e);
//                 }
//
//                 Navigator.of(context)
//                     .pop(); // 다이얼로그 닫기
//               },
//               child: Text('확인'),
//             ),
//           ],
//         );
//       },
//     );
//   },
//   child: Text('직접입력'),
// ),
// 닫기 버튼 (작고 기본 스타일)

