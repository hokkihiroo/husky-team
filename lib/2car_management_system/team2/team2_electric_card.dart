import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/2car_management_system/team2/team2_adress_const.dart';

class ElectricCard extends StatelessWidget {
  final String theDay;
  final int chargeNumber;
  final int selectedLocation;
  final String carModel;
  final Timestamp inTime;
  final DateTime? outTime;

  const ElectricCard(
      {super.key,
      required this.theDay,
      required this.inTime,
      required this.outTime,
      required this.chargeNumber,
      required this.carModel,
      required this.selectedLocation});


  String _getLocationText(int location) {
    switch (location) {
      case 1:
        return '차량내';
      case 2:
        return '거점내';
      case 3:
        return '기타';
      default:
        return '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8.0), // 좌우 여백 추가
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Row(
        children: [
          _buildCell(width: 45, text: theDay),
          _buildCell(width: 55, text: chargeNumber.toString()),
          _buildCell(width: 70, text: carModel),
          _buildCell(width: 60, text: getInTime(inTime)),
          _buildCell(
            width: 55,
            text: outTime != null ? getOutTime(outTime!) : '11:00',
            textColor: outTime == null ? Colors.black : Colors.white,
          ),
          _buildCell(
            width: 60,
            text: _getLocationText(selectedLocation),
          ),
        ],
      ),
    );
  }

  Widget _buildCell({
    required double width,
    required String text,
    Color? textColor,
  }) {
    return Container(
      width: width,
      alignment: Alignment.center, // 텍스트 왼쪽 정렬
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
