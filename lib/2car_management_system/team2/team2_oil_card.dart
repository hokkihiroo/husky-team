import 'package:flutter/material.dart';

class OilCard extends StatelessWidget {
  final String oilCount;
  final String name;
  final String carNumber;

  const OilCard({
    super.key,
    required this.oilCount,
    required this.name,
    required this.carNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(
          color: Colors.yellow, // ✅ 노란 테두리
          width: 1.0,            // 테두리 두께
        ),
        borderRadius: BorderRadius.circular(6), // 테두리 둥글기 (선택)
      ),
      child: Row(
        children: [
          Expanded(
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
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  carNumber,
                  style: const TextStyle(
                    color: Colors.yellow,
                    fontSize: 13,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$oilCount km',
                  style: const TextStyle(
                    color: Colors.yellow,
                    fontSize: 13,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
