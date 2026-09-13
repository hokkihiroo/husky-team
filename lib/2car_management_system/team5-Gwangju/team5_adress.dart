
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

final TEAM5FIELD ='local/q0LRMbznxA2yPca1DKNw/NWIXrK7TWAq7gW8x1w1b/fL35GKC4jObRZpSPmSQ8/field';

final TEAM5CARLIST ='local/q0LRMbznxA2yPca1DKNw/NWIXrK7TWAq7gW8x1w1b/LXhg3awh7ikVeUqVarsP/'; //입차리스트 주소

final COLOR5 ='local/q0LRMbznxA2yPca1DKNw/NWIXrK7TWAq7gW8x1w1b/yJ82irnxnFs2Pe2JlMAA/';  //시승차 리스트 주소

final BRANDMANAGE ='local/q0LRMbznxA2yPca1DKNw/team2/SBMhSMQHzp4A0pnveh5L/brandName/';

// 전기차 리스트 주소
final ELECTRICLIST ='local/q0LRMbznxA2yPca1DKNw/NWIXrK7TWAq7gW8x1w1b/pNHnni1uB4xc61VODmx9/';

// b1b2에서 눌러서 차량들 내역볼때 나오는 주소
final STATELIST ='local/q0LRMbznxA2yPca1DKNw/NWIXrK7TWAq7gW8x1w1b/fL35GKC4jObRZpSPmSQ8/field/';



String formatTodayDate() {
  final now = DateTime.now();
  final year = now.year.toString();
  final month = now.month.toString().padLeft(2, '0');
  final day = now.day.toString().padLeft(2, '0');
  return year + month + day;
}

String getDayOfWeek(DateTime date) {
  List<String> days = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
  return days[date.weekday - 1];
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

String formatKm(int value) {
  final formatter = NumberFormat('#,###');
  return '${formatter.format(value)}km';
}

//금액포맷 원단위, 표시
String formatWon(int value) {
  final formatter = NumberFormat('#,###');
  return '${formatter.format(value)}원';
}

//시승차에서 이동시간을 서버에서 불러와서 이코드로 시간 분을 구함
String movingTimeGet(createdAtDateTime) {
  final String a = createdAtDateTime.hour.toString().padLeft(2, '0');
  final String b = createdAtDateTime.minute.toString().padLeft(2, '0');
  final String c = '$a:$b';
  return c;

}

String getInTime(Timestamp inTime) {
  final String a = inTime.toDate().hour.toString().padLeft(2, '0');
  final String b = inTime.toDate().minute.toString().padLeft(2, '0');
  final String c = '$a:$b';
  return c;
}


String getOutTime(DateTime outTime) {
  final String a = outTime.hour.toString().padLeft(2, '0');
  final String b = outTime.minute.toString().padLeft(2, '0');
  final String c = '$a:$b';
  return c;
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

//전기차 리스트용
String elecToDate() {
  final now = DateTime.now();
  final year = now.year.toString();
  final month = now.month.toString().padLeft(2, '0');
  return year + month ;
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


//시승차 상태 저장할때 쓰는 년 월 주소값
String carStateAddress() {
  final now = DateTime.now();
  final year = now.year.toString();
  final month = now.month.toString().padLeft(2, '0');
  return year + month ;
}


String getLocationName(int location) {
  switch (location) {
    case 11:
      return 'B1';
    case 12:
      return 'B2';
    case 13:
      return '외부주차장';
    case 0:
      return '스탠바이';
    default:
      return '알 수 없음';
  }
}
