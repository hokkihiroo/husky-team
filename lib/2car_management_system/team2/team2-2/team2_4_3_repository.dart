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
    required String state,
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
        'name': 'name',
        'color': 'color',
        'location': 'location',
        'state': state,
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
