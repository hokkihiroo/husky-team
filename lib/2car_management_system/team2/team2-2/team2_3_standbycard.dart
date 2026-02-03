import 'package:flutter/material.dart';


class StandByCard extends StatelessWidget {
  final String carNumber;
  final String? name;
  final int color;
  final int location;
  final String etc;
  final String? carBrand;
  final String? carModel;
  final String? option9;

  const StandByCard({
    super.key,
    required this.carNumber,
    this.name,
    required this.color,
    required this.location,
    required this.etc,
    this.carBrand,
    this.carModel,
    this.option9,
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
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: 55,
          color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  carNumber,
                  style: TextStyle(
                    color: location == 5 ? Colors.yellow : Colors.purple,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),


              ),


              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (etc != '')
                    Icon(
                      Icons.priority_high_outlined,
                      size: 16,
                      color: Colors.green,
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
            ],
          ),
        ),

        // ⭐ 브랜드가 있을 때만 별 아이콘 추가
        if (carBrand != null && carBrand != '' && carModel != null && carModel != '')
          Positioned(
            top: 20, // 위로 살짝 올리기
            left: 0,
            right: 0,
            child: Icon(
              Icons.star,
              color: Colors.yellow,
              size: 12,
            ),
          ),
        // ⭐ 브랜드가 있을 때만 별 아이콘 추가

        if (option9!=null && option9 != '')
          Positioned(
            top: 20, // 위로 살짝 올리기
            left: 20,
            right: 0,
            child: Icon(
              Icons.grade,
              color: Colors.green,
              size: 13,
            ),
          ),

      ],
    );
  }
}
