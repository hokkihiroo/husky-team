import 'package:flutter/material.dart';

class Team3HyundaeCard extends StatelessWidget {
  final String oilCount;
  final String name;
  final int brandNum;

  const Team3HyundaeCard({
    super.key,
    required this.oilCount,
    required this.name, required this.brandNum,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 100,
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 양쪽으로 정렬
        children: [
          SizedBox(
            width: 110, // 이름 공간 고정
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.yellow,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              oilCount == '0'
                  ? '000 ${brandNum == 3 ? '' : 'km'}'
                  : '$oilCount ${brandNum == 3 ? '' : 'km'}',
              style: const TextStyle(
                color: Colors.yellow,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
