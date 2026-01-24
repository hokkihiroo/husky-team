
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_husky/2car_management_system/team2/team2-1/team2_electric.dart';

final FIELD ='local/q0LRMbznxA2yPca1DKNw/team2/fL35GKC4jObRZpSPmSQ8/field';

final TEAM2GANGNAMCAR ='local/q0LRMbznxA2yPca1DKNw/team2/SBMhSMQHzp4A0pnveh5L/gangnamCar';

final CHUNGJUCARLIST ='local/q0LRMbznxA2yPca1DKNw/team2/SBMhSMQHzp4A0pnveh5L/gangnamCar/';

final BRANDMANAGE ='local/q0LRMbznxA2yPca1DKNw/team2/SBMhSMQHzp4A0pnveh5L/brandName/';

final FORGENESIS ='local/q0LRMbznxA2yPca1DKNw/team2/SBMhSMQHzp4A0pnveh5L/forGenesis/';

final CARLIST ='local/q0LRMbznxA2yPca1DKNw/team2/LXhg3awh7ikVeUqVarsP/'; //입차리스트 주소

final COLOR5 ='local/q0LRMbznxA2yPca1DKNw/team2/yJ82irnxnFs2Pe2JlMAA/';  //시승차 리스트 주소

// 전기차 리스트 주소
final ELECTRICLIST ='local/q0LRMbznxA2yPca1DKNw/team2/pNHnni1uB4xc61VODmx9/';

final STATELIST ='local/q0LRMbznxA2yPca1DKNw/team2/fL35GKC4jObRZpSPmSQ8/field/';



// 시간과 분이 스트링으로 되어있는데 이함수를 통해 서버에 다시 DateTime 형태로 변환저장
Timestamp movingTimeToTimestamp(String timeStr) {
  final now = DateTime.now();

  final parts = timeStr.split(':');
  final hour = int.parse(parts[0]);
  final minute = int.parse(parts[1]);

  final dateTime = DateTime(
    now.year,
    now.month,
    now.day,
    hour,
    minute,
  );

  return Timestamp.fromDate(dateTime);
}
//시승차에서 이동시간을 서버에서 불러와서 이코드로 시간 분을 구함
String movingTimeGet(createdAtDateTime) {
  final String a = createdAtDateTime.hour.toString().padLeft(2, '0');
  final String b = createdAtDateTime.minute.toString().padLeft(2, '0');
  final String c = '$a:$b';
  return c;

}

String getRemainTime(createdAtDateTime){


  DateTime now = DateTime.now();
  Duration difference = now.difference(createdAtDateTime);

  int hours = difference.inHours;
  int minutes = difference.inMinutes.remainder(60);
  String val ='$hours시간$minutes분';
  return val;
}

String getTodayTime() {
  final now = DateTime.now();
  final hour = now.hour.toString().padLeft(2, '0');
  final minute = now.minute.toString().padLeft(2, '0');
  final todayTime ='시각:$hour시 $minute분';
  return todayTime;

}

String formatTodayDate() {
  final now = DateTime.now();
  final year = now.year.toString();
  final month = now.month.toString().padLeft(2, '0');
  final day = now.day.toString().padLeft(2, '0');
  return year + month + day;
}
//전기차 리스트용
String elecToDate() {
  final now = DateTime.now();
  final year = now.year.toString();
  final month = now.month.toString().padLeft(2, '0');
  return year + month ;
}

String getWeeks(int dayOfWeek){
  if(dayOfWeek ==1){
    return '월';
  }else if (dayOfWeek==2){
    return '화';
  }else if(dayOfWeek==3){
    return '수';
  }else if(dayOfWeek==4){
    return '목';
  }else if(dayOfWeek==5){
    return '금';
  }else if(dayOfWeek==6){
    return '토';
  }else if(dayOfWeek==7){
    return '일';
  }
  return '';
}
String getInTime(Timestamp inTime) {
  final String a = inTime.toDate().hour.toString().padLeft(2, '0');
  final String b = inTime.toDate().minute.toString().padLeft(2, '0');
  final String c = '$a:$b';
  return c;
}

String checkOutLocation(int location){
  if(location ==0){
    return '입차대기';
  }else if (location ==1){
    return '가벽';
  }else if(location==2){
    return 'A존';
  }else if(location==3){
    return 'B존';
  }else if(location==4){
    return 'B2';
  }else if(location==5){
    return '외부';
  }
  return '';
}

String getOutTime(DateTime outTime) {
  final String a = outTime.hour.toString().padLeft(2, '0');
  final String b = outTime.minute.toString().padLeft(2, '0');
  final String c = '$a:$b';
  return c;
}

String getDayOfWeek(DateTime date) {
  List<String> days = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
  return days[date.weekday - 1];
}


String electricDate() {
  final now = DateTime.now();
  final year = now.year.toString();
  final month = now.month.toString().padLeft(2, '0');
  return year + month;
}

String electricDay() {
  final now = DateTime.now();
  final month = now.month.toString().padLeft(2, '0');
  final day = now.day.toString().padLeft(2, '0');
  return '$month/$day';
}
// 장소표기 전기차 관련

Timestamp convertStringTimeToTimestamp(String timeStr, {int addMinutes = 0}) {
  final parts = timeStr.split(':');
  int hour = int.parse(parts[0]);
  int minute = int.parse(parts[1]);

  // 오늘 날짜 기준으로 DateTime 객체 만들기
  final now = DateTime.now();
  final baseTime = DateTime(now.year, now.month, now.day, hour, minute);

  // 분 추가
  final updatedTime = baseTime.add(Duration(minutes: addMinutes));

  return Timestamp.fromDate(updatedTime);
}
//시승차 선택시 다이어로그만들때 각각의 시승차가 브랜드별 길이가 다를때 6자리까지는 보이고 나머지 2자리는 아래로 깔리게 하는 코드
String formatCarNumber(String value) {
  if (value.length <= 6) return value;
  return value.substring(0, 6) + '\n' + value.substring(6);
}
//시승차 상태 저장할때 쓰는 년 월 주소값
String carStateAddress() {
  final now = DateTime.now();
  final year = now.year.toString();
  final month = now.month.toString().padLeft(2, '0');
  return year + month ;
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

