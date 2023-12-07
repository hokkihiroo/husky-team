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

// 입차 리스트 주소
final CARLIST ='local/q0LRMbznxA2yPca1DKNw/team1/7ttV1ueseWgiC2HhKj2Z/';