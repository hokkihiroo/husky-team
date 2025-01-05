import 'package:cloud_firestore/cloud_firestore.dart';

String getAddress (goods){
  String address ='insa/$goods/list';
  return address;
}

final GANGNAMCARLIST ='local/q0LRMbznxA2yPca1DKNw/team1/SBMhSMQHzp4A0pnveh5L/gangnamCar/';


String getGangnamCarList(String teamDocId) {
  if (teamDocId == 'PJcc0iQSHShpJvONGBC7') {
    return 'local/q0LRMbznxA2yPca1DKNw/team1/SBMhSMQHzp4A0pnveh5L/gangnamCar/';
  } else if (teamDocId == 'zSvgctyCZUnOx8rYMioF') {
    return 'local/q0LRMbznxA2yPca1DKNw/team2/SBMhSMQHzp4A0pnveh5L/gangnamCar/';
  } else {
    return 'local/q0LRMbznxA2yPca1DKNw/$teamDocId/SBMhSMQHzp4A0pnveh5L/gangnamCar/'; // 기본 경로 설정
  }
}


