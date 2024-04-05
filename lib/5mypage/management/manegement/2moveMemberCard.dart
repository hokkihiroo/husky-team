import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class MoveMemberCard extends StatelessWidget {
  final String name;
  final String team;
  final String position;

  const MoveMemberCard({
    Key? key,
    required this.name,
    required this.team,
    required this.position,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0), // 핸드폰 좌우로 2센치미터의 여백 설정
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 10.0,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                team,
                style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 10.0,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                position,
                style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 10.0,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
