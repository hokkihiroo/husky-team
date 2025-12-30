

String myInfoAdress ='user';

String getCurrentYearAndMonth() {
  final DateTime now = DateTime.now(); // 현재 날짜 및 시간 가져오기
  final int year = now.year;          // 현재 연도
  final int month = now.month;        // 현재 월

  return '$year년 $month월';           // 연도와 월을 문자열로 반환
}
//이게 조직부터 마이페이지 접근금지 아이디
List<String> restrictedEmails() {
  return [
    'sj@teamhusky.co.kr',
    // 나중에 여기 계속 추가
  ];
}
