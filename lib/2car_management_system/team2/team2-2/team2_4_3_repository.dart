import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_husky/2car_management_system/team2/team2_adress_const.dart';

/// [UserRepository]
/// - 데이터 접근 전용 클래스
/// - UI / 상태관리와 완전히 분리
class StateRepository {
  final FirebaseFirestore _firestore;


  StateRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;


  static String collection = FIELD;


  Future<void> createData({
    required String dataId,
    required String state,        //상태
    required String wayToDrive, //시승방법
    String? wayToDrive2, //시승방법
    required int totalKmBefore, // 출발전 총거리
    required int leftGasBefore, // 출발전 남은 주유량
    required int hiPassBefore, // 출발전 하이패스
    String? prepareName, //   시승준비자 이름
    String? finishdName, //     시승종료자 이름 데이터변경자
    String? movedName, //     시승종료자 이름 데이터변경자
    String? repairName, //     시승종료자 이름 데이터변경자
    int? totalKmAfter, //     변경 혹은 도착후 총거리
    int? leftGasAfter, //  변경 혹은 도착후 주유잔량
    int? hiPassAfter, //  변경 혹은 도착후 하이패스
    int? oilPriceValue, //  변경 혹은 도착후 하이패스
  }) async {

   final thisMonth = carStateAddress();    //이거 시승차 상태관리에 필요한 날짜


    try {
      await _firestore
          .collection(collection)
          .doc(dataId)
          .collection(thisMonth)
          .doc() // 랜덤 ID로 새 문서 생성
          .set({
        'createdAt': FieldValue.serverTimestamp(),
        'prepareName': prepareName ?? '',
        'finishdName': finishdName ?? '',
        'movedName': movedName ?? '',
        'repairName': repairName ?? '',
        'state': state,                               //차량의 상태기록
        'wayToDrive': wayToDrive,                     // 시승방법 기록 대면,현장동승, 기타 등등
        'totalKmBefore': totalKmBefore,
        'leftGasBefore': leftGasBefore,
        'hiPassBefore': hiPassBefore,
        'totalKmAfter': totalKmAfter,
        'leftGasAfter': leftGasAfter,
        'hiPassAfter': hiPassAfter,
        'oilPriceValue': oilPriceValue,
        'wayToDrive2': wayToDrive2,

      });
      print('✅ 데이터 생성 성공');
    } catch (e) {
      print('❌ 데이터 생성 실패: $e');
      // 원하면 여기서 사용자에게 에러 UI 보여주기 가능
    }
  }


  /// ❌ 사용자 삭제
  Future<void> deleteUser(String userId) {
    return _firestore
        .collection(collection)
        .doc(userId)
        .delete();
  }
}
