import 'package:flutter/material.dart';

class WorkerMemberCard extends StatelessWidget {
  final String workerName;

  const WorkerMemberCard({
    super.key,
    required this.workerName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 250,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            workerName,
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
          ),
          Text(
            '삭제하기',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
