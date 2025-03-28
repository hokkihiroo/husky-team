import 'package:flutter/material.dart';

class Team3HyundaeCard extends StatelessWidget {
  final String oilCount;
  final String name;
  final int brandNum;

  const Team3HyundaeCard({
    super.key,
    required this.oilCount,
    required this.name,
    required this.brandNum,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 13,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    oilCount == '0'
                        ? '000 ${brandNum == 3 ? '' : 'km'}'
                        : '$oilCount ${brandNum == 3 ? '' : 'km'}',
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 13,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
