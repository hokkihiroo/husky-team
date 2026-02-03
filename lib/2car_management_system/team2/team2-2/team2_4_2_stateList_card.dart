import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StateListCard extends StatelessWidget {
final String theDay;
final String theTime;
final String state;
final String wayToDrive;


const StateListCard(
      {super.key,
        required this.theDay,
        required this.theTime,
        required this.state,
        required this.wayToDrive,
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
          SizedBox(width: 10,),
          _buildCell(width: 60, text: theDay),
          _buildCell(width: 60, text: theTime),
          SizedBox(width: 15,),
          _buildCell(width: 120, text: state),
          _buildCell(width: 100, text: wayToDrive),
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
      alignment: Alignment.centerLeft, // 텍스트 왼쪽 정렬
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.yellow,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
