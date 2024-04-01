import 'package:flutter/material.dart';

class NumberCard extends StatelessWidget {
  final String carNumber;
  final String? name;
  final int color;
  final String etc;

  const NumberCard({
    super.key,
    required this.carNumber,
    this.name,
    required this.color,
    required this.etc,
  });

  String splitNames() {
    if (name == '') {
      return '';
    } else if (name!.length == 2) {
      return name!.substring(0, 2);
    } else if (name!.length == 3) {
      return name!.substring(1, 3); // 두 번째와 세 번째 글자 추출
    } else if (name!.length == 4) {
      return name!.substring(2, 4); // 세 번째와 네 번째 글자 추출
    } else {
      return "에러";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              carNumber,
              style: TextStyle(
                color: color == 1
                    ? Colors.white
                    : (color == 2 && name == '')
                        ? Colors.red
                        : Colors.yellow,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (etc != '')
                Expanded(
                  child: Icon(
                    Icons.priority_high_outlined,
                    size: 16,
                    color: Colors.green,
                  ),
                ),
              Text(
                splitNames(),
                style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // Icon(
          //   Icons.priority_high_outlined,
          //   color: Colors.yellow,
          // ),
        ],
      ),
    );
  }
}
