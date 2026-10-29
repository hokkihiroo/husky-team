class EventCarModel {
  // 차량 기본 정보
  final String carNumber;
  final String brand;
  final String carModel;
  final String registName;

  // 차량 운행 정보
  final String mileage;
  final String fuelAmount;
  final String keyQuantity;

  // 타이어 정보
  final String tireBrand;
  final String frontTireModel;
  final String rearTireModel;

  const EventCarModel({
    required this.carNumber,
    required this.brand,
    required this.carModel,
    required this.registName,
    required this.mileage,
    required this.fuelAmount,
    required this.keyQuantity,
    required this.tireBrand,
    required this.frontTireModel,
    required this.rearTireModel,
  });

  // Firestore Map 데이터를 차량 모델로 변환
  factory EventCarModel.fromMap(Map<String, dynamic> data) {
    return EventCarModel(
      carNumber: data['carNumber']?.toString() ?? '',
      brand: data['model']?.toString() ?? '',
      carModel: data['detail']?.toString() ?? '',
      registName: data['registName']?.toString() ?? '',

      mileage: data['mileage']?.toString() ?? '',
      fuelAmount: data['fuelAmount']?.toString() ?? '',
      keyQuantity: data['keyQuantity']?.toString() ?? '',

      tireBrand: data['tireBrand']?.toString() ?? '',
      frontTireModel: data['frontTireModel']?.toString() ?? '',
      rearTireModel: data['rearTireModel']?.toString() ?? '',
    );
  }
}