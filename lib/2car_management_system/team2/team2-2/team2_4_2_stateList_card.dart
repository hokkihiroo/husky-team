import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StateListCard extends StatelessWidget {
final String smallDataId;
final String carModel;

final String theDay;
final String theTime;
final String etc;


const StateListCard(
      {super.key,
        required this.smallDataId,
        required this.carModel,
        required this.theDay,
        required this.theTime,
        required this.etc,
        });


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
          SizedBox(width: 6,),
          _buildCell(width: 70, text: theDay),
          _buildCell(width: 60, text: theTime),
          _buildCell(width: 170, text: etc),
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
          color: Colors.yellow,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
