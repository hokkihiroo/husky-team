import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'team2_adress_const.dart';

class CarListCard extends StatelessWidget {
  final int index;
  final String carNum;
  final String carBrand;
  final String carModel;
  final Timestamp inTime;
  final DateTime? outTime;

  const CarListCard({super.key,
    required this.index,
    required this.carNum,
    required this.inTime,
    required this.outTime,
    required this.carBrand,
    required this.carModel});

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
          _buildCell(width: 45, text: index.toString().padLeft(2, '0')),
          _buildCell(width: 60, text: carBrand),
          _buildCell(width: 60, text: carModel),
          _buildCell(width: 60, text: carNum),
          _buildCell(width: 60, text: getInTime(inTime)),
          _buildCell(
            width: 55,
            text: outTime != null ? getOutTime(outTime!) : '11:00',
            textColor: outTime == null ? Colors.black : Colors.white,
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
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}