import 'package:cloud_firestore/cloud_firestore.dart';

import 'address.dart';

class EventMainRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ============================================================
  // 브랜드 목록
  // ============================================================

  Stream<QuerySnapshot<Map<String, dynamic>>> brandStream() {
    return _firestore
        .collection(EVENT)
        .orderBy('createdAt')
        .snapshots();
  }

  // ============================================================
  // 선택된 브랜드의 차종 목록
  // ============================================================

  Stream<QuerySnapshot<Map<String, dynamic>>> chajongStream(
      String brandId,
      ) {
    return _firestore
        .collection(EVENT)
        .doc(brandId)
        .collection('LIST')
        .snapshots();
  }

  // ============================================================
// 브랜드 추가
// ============================================================

  Future<void> addBrand(String brand) async {
    await _firestore.collection(EVENT).add({
      'name': brand,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}


