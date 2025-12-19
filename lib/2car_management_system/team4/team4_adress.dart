import 'package:cloud_firestore/cloud_firestore.dart';


final BRANDMANAGE ='local/q0LRMbznxA2yPca1DKNw/team2/SBMhSMQHzp4A0pnveh5L/brandName/';

final TEAM4FIELD ='local/q0LRMbznxA2yPca1DKNw/B71qHzRliuN9iQeTygTe/fL35GKC4jObRZpSPmSQ8/field';

final TEAM4MEMBER ='local/q0LRMbznxA2yPca1DKNw/B71qHzRliuN9iQeTygTe/fL35GKC4jObRZpSPmSQ8/member';

final TEAM4CARLIST ='local/q0LRMbznxA2yPca1DKNw/B71qHzRliuN9iQeTygTe/LXhg3awh7ikVeUqVarsP/';

final TEAM4ELECTRICLIST ='local/q0LRMbznxA2yPca1DKNw/B71qHzRliuN9iQeTygTe/pNHnni1uB4xc61VODmx9/';


String Team4formatTodayDate() {
  final now = DateTime.now();
  final year = now.year.toString();
  final month = now.month.toString().padLeft(2, '0');
  final day = now.day.toString().padLeft(2, '0');
  return year + month + day;
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
String Team4getInTime(Timestamp inTime) {
  final String a = inTime.toDate().hour.toString().padLeft(2, '0');
  final String b = inTime.toDate().minute.toString().padLeft(2, '0');
  final String c = '$a:$b';
  return c;
}

String Team4getOutTime(DateTime outTime) {
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

String electricDay() {
  final now = DateTime.now();
  final month = now.month.toString().padLeft(2, '0');
  final day = now.day.toString().padLeft(2, '0');
  return '$month/$day';
}

String electricDate() {
  final now = DateTime.now();
  final year = now.year.toString();
  final month = now.month.toString().padLeft(2, '0');
  return year + month;
}

