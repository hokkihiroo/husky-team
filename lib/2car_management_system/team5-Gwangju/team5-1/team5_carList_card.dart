import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../team5_adress.dart';

class Team5CarlistCard extends StatelessWidget {
  final int index;
  final String carNum;
  final String carBrand;
  final String carModel;
  final String enterName;
  final Timestamp inTime;
  final DateTime? outTime;
  final DateTime? movingTime;

  const Team5CarlistCard({
    super.key,
    required this.index,
    required this.carNum,
    required this.inTime,
    required this.outTime,
    required this.carBrand,
    required this.carModel,
    required this.enterName,
    required this.movingTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildCell(
            width: 45,
            text: index.toString().padLeft(2, '0'),
          ),
          _buildCell(
            width: 60,
            text: carBrand,
          ),
          _buildCell(
            width: 60,
            text: carModel,
          ),
          _buildCell(
            width: 60,
            text: carNum,
          ),
          _buildCell(
            width: 60,
            text: getInTime(inTime),
          ),

          // 출차시간
          // null이면 빈칸으로 표시하고 기존 너비는 유지
          _buildCell(
            width: 55,
            text: outTime != null ? getOutTime(outTime!) : '',
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
      alignment: Alignment.center,
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          // 자가주차일 경우 행 전체 파란색
          color: enterName == '자가주차'
              ? Colors.blue
              : textColor ?? Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}