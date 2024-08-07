import 'package:cloud_firestore/cloud_firestore.dart';

final LOTARY ='local/q0LRMbznxA2yPca1DKNw/team1/1ACUzVo3Quod24RLILGr/rotary';

final OUTSIDE ='local/q0LRMbznxA2yPca1DKNw/team1/1ACUzVo3Quod24RLILGr/outside';

final MAIN ='local/q0LRMbznxA2yPca1DKNw/team1/1ACUzVo3Quod24RLILGr/150';

final MOON ='local/q0LRMbznxA2yPca1DKNw/team1/1ACUzVo3Quod24RLILGr/moon';

final SINSA ='local/q0LRMbznxA2yPca1DKNw/team1/1ACUzVo3Quod24RLILGr/sinsa';



// 픽업에 필요한 위치파악
String CheckLocation(int location){
  if(location ==0){
    return LOTARY;
  }else if (location ==1){
    return OUTSIDE;
  }else if(location==2){
    return MAIN;
  }else if(location==3){
    return MOON;
  }else if(location==4){
    return SINSA;
  }
  return '';
}
// 날짜를 yyyyMMdd형식으로 출력하는 함수
String formatTodayDate() {
  final now = DateTime.now();
  final year = now.year.toString();
  final month = now.month.toString().padLeft(2, '0');
  final day = now.day.toString().padLeft(2, '0');
  return year + month + day;
}

String getTodayTime() {
  final now = DateTime.now();
  final hour = now.hour.toString().padLeft(2, '0');
  final minute = now.minute.toString().padLeft(2, '0');
  final todayTime ='시각:$hour시 $minute분';
  return todayTime;

}
// 시승차 스케줄 주소
final CARSCHEDULE ='local/q0LRMbznxA2yPca1DKNw/team1/TxPOvECdU2W8gOh7bkPZ/';


// 입차 리스트 주소
final CARLIST ='local/q0LRMbznxA2yPca1DKNw/team1/7ttV1ueseWgiC2HhKj2Z/';
 // -------------------날짜 변환 함수 -----------------------------
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

String checkOutLocation(int location){
  if(location ==0){
    return '로터리';
  }else if (location ==1){
    return '외벽';
  }else if(location==2){
    return '광장';
  }else if(location==3){
    return '문';
  }else if(location==4){
    return '신사면옥';
  }
  return '';
}
String getRemainTime(createdAtDateTime){


DateTime now = DateTime.now();
Duration difference = now.difference(createdAtDateTime);

int hours = difference.inHours;
int minutes = difference.inMinutes.remainder(60);
String val ='$hours시간$minutes분';
return val;
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

String getDayOfWeek(DateTime date) {
  List<String> days = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
  return days[date.weekday - 1];
}