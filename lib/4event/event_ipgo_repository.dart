import 'package:cloud_firestore/cloud_firestore.dart';

import 'address.dart';

// ============================================================
// 기능 : 모델 / 상세 데이터
// ============================================================

class EventIpgoItem {
  final String id;
  final String name;

  const EventIpgoItem({
    required this.id,
    required this.name,
  });
}

// ============================================================
// 기능 : 입고 등록 Repository
// ============================================================

class EventIpgoRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==========================================================
  // 차량 모델 목록 조회
  //
  // EVENT
  //   └─ 브랜드ID
  //       └─ MODEL
  //           └─ 모델 문서
  //               └─ model : AMG
  // ==========================================================

  Future<List<EventIpgoItem>> getModels(String brandId) async {
    final snapshot = await _firestore
        .collection(EVENT)
        .doc(brandId)
        .collection('MODEL')
        .get();

    return snapshot.docs
        .map((document) {
      final model = (document.data()['model'] ?? '').toString().trim();

      return EventIpgoItem(
        id: document.id,
        name: model,
      );
    })
        .where((item) => item.name.isNotEmpty)
        .toList();
  }

  // ==========================================================
  // 차량 상세 목록 조회
  //
  // EVENT
  //   └─ 브랜드ID
  //       └─ MODEL
  //           └─ 모델 문서ID
  //               └─ DETAIL
  //                   └─ 상세 문서
  //                       └─ detail : GT55
  // ==========================================================

  Future<List<EventIpgoItem>> getDetails({
    required String brandId,
    required String modelId,
  }) async {
    final snapshot = await _firestore
        .collection(EVENT)
        .doc(brandId)
        .collection('MODEL')
        .doc(modelId)
        .collection('DETAIL')
        .get();

    return snapshot.docs
        .map((document) {
      final detail =
      (document.data()['detail'] ?? '').toString().trim();

      return EventIpgoItem(
        id: document.id,
        name: detail,
      );
    })
        .where((item) => item.name.isNotEmpty)
        .toList();
  }

  // ==========================================================
  // 입고 등록 화면 : 브랜드명 조회
  // ==========================================================

  Future<String> getBrandName(String brandId) async {
    final document =
    await _firestore.collection(EVENT).doc(brandId).get();

    if (!document.exists) {
      throw Exception('브랜드 문서를 찾을 수 없습니다.');
    }

    return (document.data()?['name'] ?? '').toString().trim();
  }

  // ==========================================================
  // 입고 등록 화면 : 차량 모델 추가
  // ==========================================================

  Future<void> addModel({
    required String brandId,
    required String model,
  }) async {
    await _firestore
        .collection(EVENT)
        .doc(brandId)
        .collection('MODEL')
        .add({
      'model': model.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // ==========================================================
  // 입고 등록 화면 : 차량 상세 추가
  //
  // 선택된 모델의 DETAIL 컬렉션에 저장
  // ==========================================================

  Future<void> addDetail({
    required String brandId,
    required String modelId,
    required String detail,
  }) async {
    await _firestore
        .collection(EVENT)
        .doc(brandId)
        .collection('MODEL')
        .doc(modelId)
        .collection('DETAIL')
        .add({
      'detail': detail.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // ==========================================================
  // 차량 등록하기
  //
  // 등록 경로 : EVENT / 브랜드ID / LIST
  //
  // 차량번호 예시 : 123가4567
  // ==========================================================

  Future<void> registerCar({
    required String brandId,
    required String brandName,
    required String modelId,
    required String model,
    required String detailId,
    required String detail,
    required String carNumberFirst,
    required String carNumberHangul,
    required String carNumberLast,
    required String mileage,
    required String fuelAmount,
    required String keyQuantity,
    required String registName,
  }) async {
    final carNumber =
        '${carNumberFirst.trim()}'
        '${carNumberHangul.trim()}'
        '${carNumberLast.trim()}';

    await _firestore
        .collection(EVENT)
        .doc(brandId)
        .collection('LIST')
        .add({
      'brandId': brandId,
      'brandName': brandName,
      'modelId': modelId,
      'model': model,
      'detailId': detailId,
      'detail': detail,
      'carNumber': carNumber,
      'carNumberFirst': carNumberFirst.trim(),
      'carNumberHangul': carNumberHangul.trim(),
      'carNumberLast': carNumberLast.trim(),
      'createdAt': FieldValue.serverTimestamp(),
      'mileage': mileage.trim().isEmpty
          ? null
          : int.parse(mileage.trim()),

      'fuelAmount': fuelAmount.trim().isEmpty
          ? null
          : int.parse(fuelAmount.trim()),

      'keyQuantity': keyQuantity.trim().isEmpty
          ? null
          : int.parse(keyQuantity.trim()),

      'registName': registName.trim(),
    });
  }
}