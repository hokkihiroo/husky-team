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

// 이게 헷갈릴수 있어서 적어놓음 강남팀은 강남전용이라 강남전용 주소적어놓은거고
// 청주도 그렇게 적었다가 3번째부터는 중간에 팀을 넣어서 알아서 각각찾아갈수있게 만든거임

String getBrandNameList() {
    return 'local/q0LRMbznxA2yPca1DKNw/team2/SBMhSMQHzp4A0pnveh5L/brandName/';
}

String getForGenesis(String teamDocId) {
  if (teamDocId == 'PJcc0iQSHShpJvONGBC7') {
    return 'local/q0LRMbznxA2yPca1DKNw/team1/SBMhSMQHzp4A0pnveh5L/forGenesis/';
  } else if (teamDocId == 'zSvgctyCZUnOx8rYMioF') {
    return 'local/q0LRMbznxA2yPca1DKNw/team2/SBMhSMQHzp4A0pnveh5L/forGenesis/';
  } else {
    return 'local/q0LRMbznxA2yPca1DKNw/$teamDocId/SBMhSMQHzp4A0pnveh5L/forGenesis/'; // 기본 경로 설정
  }
}
